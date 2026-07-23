# Architecture Debate — Example

**Scenario:** A backend notification service, `herald`, delivers transactional
email and push notifications for a SaaS billing platform. The engineering team must
decide how to implement idempotency for notification delivery — ensuring that a
network retry or a queue duplicate does not result in a customer receiving the same
invoice email twice.

This example demonstrates a complete Architecture Debate record for this decision.

---

# Architecture Debate Record

**Decision ID:** `DEBATE-004`
**Date:** 2026-06-14
**Status:** Decided
**Decision owner:** Platform Engineering Lead
**Review date:** 2026-12-14, or when `herald` exceeds 5 million notifications per month

---

## Problem Statement

The `herald` notification service must guarantee that each transactional notification
(invoice emails, payment confirmations, failed-payment alerts) is delivered exactly
once to each recipient. The current implementation does not deduplicate at the delivery
layer. A queue consumer retry or an upstream duplicate event causes duplicate delivery.
The scope of this decision is the deduplication mechanism at the point of delivery — not
upstream event deduplication, which is owned by the event bus team.

Choosing incorrectly risks either duplicate customer-facing notifications (direct
customer impact, trust erosion) or under-delivery when a transient failure is mistakenly
treated as a duplicate (silent delivery failure with financial and compliance
implications).

---

## Decision Criteria

| # | Criterion | Description | Priority |
|---|---|---|---|
| C1 | Correctness under concurrent retries | Does the mechanism prevent duplicates when two consumers process the same message simultaneously? | High |
| C2 | Failure atomicity | If the mechanism's state store becomes unavailable, does the system fail safely (no delivery) or fail open (possible duplicate)? | High |
| C3 | Operational complexity | How many additional infrastructure components does the mechanism require? How much is added to the on-call surface? | Medium |
| C4 | Latency impact | What is the added per-notification latency at p99? | Medium |
| C5 | Reversibility | Can the mechanism be replaced without reprocessing historical records or notifying customers? | Low |

---

## Options

### Option A — Database idempotency key with SELECT-then-INSERT

Before delivering a notification, the consumer queries a `delivered_notifications`
table for the notification ID. If a row exists, the delivery is skipped. If not, the
consumer delivers and inserts the row.

**Strongest case (Defender):**
This approach requires no additional infrastructure — the service already depends on
a PostgreSQL instance. The `delivered_notifications` table can be indexed on
`notification_id`. Under normal (non-concurrent) operation, it is correct and adds
approximately 2 ms of latency per notification for a single-node database. It is
immediately reversible: drop the table and remove the check.

**Most credible failure modes (Attacker):**
The critical assumption is that "normal operation" does not include concurrent retries.
Under a queue backpressure event — exactly the scenario where retries are most likely —
multiple consumers will race on the SELECT-then-INSERT sequence. Both will find no row,
both will deliver, and both will attempt the INSERT. Without a unique constraint on
`notification_id`, both INSERTs succeed and the duplicate is silent. A unique constraint
prevents the second INSERT but does not prevent the second delivery, because the
delivery happens before the INSERT. The window between "delivery issued" and "INSERT
committed" is exactly where the duplicate occurs.

**Criteria evaluation:**

| Criterion | Score | Rationale |
|---|---|---|
| C1 — Correctness under concurrent retries | 2 | SELECT-then-INSERT has a TOCTOU race window; concurrent retries will produce duplicates without application-level locking |
| C2 — Failure atomicity | 3 | If PostgreSQL is unavailable, SELECT fails and delivery is blocked — correct safe-failure behavior |
| C3 — Operational complexity | 5 | No new infrastructure; uses the existing database dependency |
| C4 — Latency impact | 4 | ~2 ms added per notification under normal load |
| C5 — Reversibility | 5 | Table can be dropped; mechanism can be disabled without side effects |

---

### Option B — Database INSERT with unique constraint, deliver-after-INSERT

The consumer attempts to INSERT a row into `delivered_notifications` with a unique
constraint on `notification_id` before delivering. If the INSERT succeeds, the consumer
delivers. If the INSERT fails with a unique violation, the consumer skips delivery.
Delivery only occurs after a successful INSERT.

**Strongest case (Defender):**
This approach eliminates the TOCTOU race window by inverting the order: the deduplication
state is written before delivery occurs. The unique constraint on the database ensures
that exactly one consumer wins the INSERT race. A duplicate delivery can only occur if
the INSERT succeeds and the process dies before the delivery completes — in which case
the notification ID is already in the table, and the retry will skip delivery. The only
failure mode is under-delivery on a crash between INSERT and delivery, which is
recoverable by the dead-letter queue and manual review.

**Most credible failure modes (Attacker):**
The critical assumption is that INSERT latency under concurrent load is acceptable. For a
high-throughput burst (10,000 notifications/minute from a billing cycle run), concurrent
INSERTs on the same table will contend on the unique index. At p99, this contention
can add 15–20 ms per notification on a standard PostgreSQL instance, which is a 7–10x
latency increase over baseline. Additionally, the `delivered_notifications` table grows
unboundedly without a retention policy. At 5 million notifications per month, the table
reaches 60 million rows per year. Without index maintenance, queries degrade
over 12–18 months.

**Criteria evaluation:**

| Criterion | Score | Rationale |
|---|---|---|
| C1 — Correctness under concurrent retries | 5 | Unique constraint ensures exactly-once INSERT; deliver-after-INSERT eliminates the race window |
| C2 — Failure atomicity | 4 | If PostgreSQL is unavailable, INSERT fails and delivery is blocked — safe failure; crash after INSERT but before delivery causes under-delivery, not over-delivery |
| C3 — Operational complexity | 4 | No new infrastructure; requires a retention policy job (low complexity) |
| C4 — Latency impact | 3 | ~2 ms nominal; 15–20 ms p99 under high-concurrency bursts |
| C5 — Reversibility | 5 | Table can be dropped; mechanism can be disabled without side effects |

---

### Option C — Distributed lock (Redis SETNX) with TTL

Before delivering, the consumer acquires a lock using `SETNX notification:<id>` with a
TTL equal to the maximum expected delivery time. If the lock is acquired, delivery
proceeds. If not, the consumer skips.

**Strongest case (Defender):**
SETNX is an atomic operation. There is no race window between check and delivery. The
TTL prevents permanent lock retention if a consumer crashes during delivery. At
`herald`'s current scale, a single Redis node handles hundreds of thousands of SETNX
operations per second with sub-millisecond latency. This approach adds less than 1 ms
to the delivery path at p99 under normal operation.

**Most credible failure modes (Attacker):**
This approach introduces Redis as a new infrastructure dependency. `herald` does not
currently use Redis. The operational surface increases: Redis availability becomes part
of the notification delivery SLA. If Redis is unavailable, the consumer cannot acquire
the lock and notifications are not delivered — a fail-safe behavior, but one that
requires Redis to have the same availability target as the notification service itself.
The TTL introduces a second failure mode: if delivery takes longer than the TTL (e.g.,
a slow downstream SMTP provider), the lock expires, a second consumer acquires it, and
a duplicate is delivered. Selecting the TTL requires knowledge of delivery time
distribution that the team does not currently have.

**Criteria evaluation:**

| Criterion | Score | Rationale |
|---|---|---|
| C1 — Correctness under concurrent retries | 5 | SETNX is atomic; no race window |
| C2 — Failure atomicity | 3 | Redis unavailability blocks delivery — fail-safe, but adds a new availability dependency; TTL expiry can produce duplicates on slow delivery |
| C3 — Operational complexity | 2 | Requires introducing and operating Redis; increases on-call surface; requires TTL tuning |
| C4 — Latency impact | 5 | < 1 ms per notification at p99 under normal operation |
| C5 — Reversibility | 3 | Redis infrastructure costs persist after removal; TTL-based locks do not leave a persistent record |

---

## Structured Debate

### Option A — Defender/Attacker Exchange

**Defender:** Option A adds no new infrastructure and is immediately reversible. Under
sequential processing — which covers the majority of `herald`'s normal operation — it
is correct and fast. The team can implement and deploy it within the current sprint
using existing database access patterns.

**Attacker:** The critical assumption is sequential processing. The billing cycle
produces bursts where the same notification ID can appear in the queue more than once
simultaneously. The SELECT-then-INSERT sequence has a race window between the SELECT
returning no rows and the INSERT committing. Under concurrent consumption, this window
produces silent duplicate delivery. This is the exact scenario the team is trying to
prevent, and it is the exact scenario the mechanism fails to prevent.

**Defender response:** The race condition is real and cannot be addressed by adding a
unique constraint alone — the delivery happens before the INSERT. Application-level
locking would address the race but would serialize all delivery and eliminate the
throughput advantage. Option A is not suitable for concurrent consumers.

---

### Option B — Defender/Attacker Exchange

**Defender:** Option B eliminates the race window by writing the deduplication record
before delivery. The unique constraint ensures that exactly one consumer commits
successfully on a duplicate. The sequence is correct under concurrent operation. It
uses no new infrastructure. The latency cost is acceptable for the current scale, and
the retention concern is addressable with a straightforward scheduled job.

**Attacker:** The latency concern is not merely operational — it is correctness-adjacent.
If the billing cycle produces 10,000 notifications per minute and the p99 delivery
latency rises to 20 ms per notification, the batch takes 200 seconds instead of 20.
This may breach the SLA for "invoice sent within N minutes of charge." The team has
not measured baseline delivery latency under batch load; the 15–20 ms estimate is
theoretical. If the actual latency is higher, the mechanism creates a correctness-
adjacent SLA failure that is harder to detect than a duplicate.

**Defender response:** The latency concern is real and should be load-tested before
production deployment. If p99 under batch load exceeds 10 ms, a connection pool or
partitioned table may be required. This is a mitigation within Option B's scope.
The correctness property — no duplicate delivery — is not affected by latency.

---

### Option C — Defender/Attacker Exchange

**Defender:** SETNX provides the strongest per-operation correctness guarantee at the
lowest per-operation latency. For a service that may need to scale to millions of
notifications, the sub-millisecond lock acquisition is the only option that will not
become a bottleneck at scale. The infrastructure investment now positions `herald` for
growth that the database-based options will struggle with.

**Attacker:** `herald` currently processes 150,000 notifications per month — far below
the scale at which Redis becomes necessary. Introducing Redis to solve a concurrency
problem that PostgreSQL can handle correctly (Option B) increases the on-call surface,
adds deployment complexity, and creates a new availability dependency. The TTL failure
mode — duplicate delivery when the SMTP provider is slow — is not bounded by the
team's control. Option C trades a solvable correctness problem (concurrent INSERT race)
for an unsolvable one (delivery time variability in external dependencies).

**Defender response:** The TTL concern is valid and cannot be fully addressed without
end-to-end delivery time SLOs from the downstream SMTP provider — which the team
does not have. If the delivery time distribution is unknown, the TTL is a guess. A TTL
that is too short produces duplicates; a TTL that is too long delays lock release and
reduces throughput. This is a fundamental limitation of the approach at the current
state of the team's operational knowledge.

---

## Comparison Summary

| Criterion | Option A | Option B | Option C | Winner |
|---|---|---|---|---|
| C1 — Correctness (concurrent) | 2 | 5 | 5 | B / C |
| C2 — Failure atomicity | 3 | 4 | 3 | B |
| C3 — Operational complexity | 5 | 4 | 2 | A |
| C4 — Latency impact | 4 | 3 | 5 | C |
| C5 — Reversibility | 5 | 5 | 3 | A / B |
| **Weighted total (H=3, M=2, L=1)** | **32** | **40** | **34** | **B** |

_Weighting: High criteria (C1, C2) scored × 3; Medium criteria (C3, C4) scored × 2;
Low criterion (C5) scored × 1._

---

## Decision

**Chosen option:** Option B — Database INSERT with unique constraint, deliver-after-INSERT

**Rationale:**
Option B is the only approach that eliminates the concurrent-retry race window without
introducing a new infrastructure dependency. The correctness guarantee (C1: 5/5) is the
dominant criterion given the customer impact of duplicate invoice emails. Option B also
provides the strongest failure atomicity (C2: 4/5): a crash after INSERT but before
delivery produces under-delivery, not over-delivery, and the dead-letter queue provides
a recovery path. The latency concern raised in the debate is addressable by load testing
before production deployment; if p99 latency under batch load exceeds the SLA threshold,
table partitioning will be evaluated before go-live.

**Why Option A was not chosen:**
Option A fails under concurrent consumers (C1: 2/5). The SELECT-then-INSERT race window
allows duplicate delivery in exactly the burst scenario where retries are most likely.
This is a fundamental correctness failure, not a tunable concern.

**Why Option C was not chosen:**
Option C introduces Redis as a new infrastructure dependency, increasing the on-call
surface (C3: 2/5). More critically, the TTL-based deduplication creates a failure mode
where a slow downstream delivery causes the lock to expire and a duplicate to be issued
— a correctness failure driven by external latency that the team cannot bound (C2: 3/5).
At `herald`'s current scale, these costs are not justified by the latency benefit.

---

## Reversal Conditions

**Reversal trigger:**
If p99 delivery latency under batch load exceeds 10 ms after applying connection pool
and table partitioning mitigations, OR if `herald` exceeds 5 million notifications per
month and the `delivered_notifications` table maintenance overhead exceeds 4 hours per
month, reopen this decision with Redis (Option C) as the primary alternative.

**Review date:**
2026-12-14, or when monthly notification volume reaches 5 million — whichever comes first.

**Who must approve reversal:**
Platform Engineering Lead, with sign-off from On-call Lead.

---

## Related Artefacts

| Artefact | Path | Relationship |
|---|---|---|
| `herald` service specification | `specs/herald/v2.1.md` | Governs delivery guarantees and SLA requirements |
| ADR-012 | `foundation/adr/ADR-012-herald-idempotency.md` | Formal decision record downstream of this debate |
| Load test results | `reviews/herald-batch-load/load-test-2026-06-15.md` | Evidence for latency evaluation under batch load |

---

## Change Log

| Date | Author | Change |
|---|---|---|
| 2026-06-14 | Platform Engineering Lead | Initial record — decision reached |
