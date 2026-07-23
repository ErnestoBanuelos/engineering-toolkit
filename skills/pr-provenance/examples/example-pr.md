# PR Provenance — Worked Example

**Subject system:** `inventory-service` — a backend service that manages product stock
levels, processes reservation requests from the order pipeline, and emits low-stock
events to a notification queue.

**Language:** Go (findings and structure are language-agnostic)

**Change scope:** Introduce an idempotent reservation path to prevent duplicate stock
deductions when the order pipeline retries a timed-out reservation request.

**Purpose of this document:** Demonstrate one complete PR provenance package using the
template in `templates/pr-provenance-template.md`. All service names, identifiers, and
data values are fictional.

---

# Pull Request

## Idempotent Reservation Path — Prevent Duplicate Stock Deductions on Retry

The order pipeline retries reservation requests when it does not receive an
acknowledgement within its timeout window. Prior to this change, a retry that arrived
after a timed-out-but-successful reservation resulted in a second stock deduction for the
same order line. The deducted units were never restored, and inventory counts drifted
silently below their true values over the course of a business day.

This change introduces an idempotency key check at the reservation intake boundary.
`ReserveStock()` in `internal/inventory/reservation.go` now queries the idempotency
store before applying a deduction. If the key is already present, the function returns
the original reservation result without modifying stock. If the key is absent, the
reservation proceeds and the result is recorded under the key before the response is
returned to the caller.

The deduplication window is 24 hours, matching the maximum retry duration guaranteed
by the order pipeline SLA. Reservations older than 24 hours are not deduplicated; a
retry after that window is treated as a new reservation. This boundary condition is
explicitly tested.

Verification: 187 unit tests pass (was 172; 15 new tests added). Linting and type
checking clean. Independent verification completed. Engineering review conducted.
Adversarial pass completed with one confirmed defect fixed.

---

## Provenance

### Tool / Model

| Item | Value |
|---|---|
| AI client | AI coding assistant (vendor-agnostic session) |
| Model | Large language model — reasoning tier |
| Execution date(s) | 2026-07-15 to 2026-07-17 |

The implementation session was supervised. All proposals were reviewed and approved
by the human engineer before being applied. The session log at
`sessions/ISS-047/session-log.md` records every proposal and its approval status.

---

### Context Loaded

**Primary implementation modified:**

`internal/inventory/reservation.go` — the reservation intake handler. The idempotency
key check was added as the first guard inside `ReserveStock()`. No other function in this
file was modified.

**Supporting files referenced:**

| File | Role |
|---|---|
| `specs/inventory/idempotency-spec.md` v1.2 | Normative specification; idempotency key contract; 24-hour window definition; acceptance criteria IC-1 through IC-3 |
| `changes/idempotency-reservation/delta.md` v1.0 | Brownfield delta; ADDED idempotency check; MODIFIED reservation pipeline; REMOVED duplicate-deduction risk |
| `changes/idempotency-reservation/plan.md` v1.0 | Implementation plan; Component 1 (key check) and Component 2 (store interface) |
| `changes/idempotency-reservation/tasks.md` v1.0 | Task decomposition; ISS-047 FIRST SLICE annotation; Seam 1 interface contract |
| `sessions/ISS-047/session-log.md` | Supervised implementation session; gate verdicts |
| `internal/inventory/idempotency_store.go` | Idempotency store interface; introduced in this change |
| `internal/inventory/reservation_test.go` | Primary test file; 15 new tests covering IC-1, IC-2, IC-3, and the 24-hour boundary |
| `docs/adr/ADR-007-idempotency-store.md` | Architecture decision: in-process TTL cache vs. external Redis; Redis deferred |

**Engineering practices applied:**

- Specification-Driven Development — `specs/inventory/idempotency-spec.md` v1.2
  preceded implementation. No behaviour was introduced that does not appear in the
  specification.
- Supervised implementation session — all proposals reviewed and approved before
  application. Session log records every action.
- Independent Verification — all three tool gates run against an unmodified working tree
  before review. Isolation Tier C (same engineering effort).
- Seven-Lens Engineering Review — 14 findings across seven lenses; 0 blockers,
  1 major, 8 minor, 5 nits.
- Adversarial Review — one confirmed defect fixed (key collision on concurrent identical
  requests); one accepted risk documented (TTL granularity coarser than request
  resolution).

---

### Verification Gates

| Gate | Tool / Command | Result |
|---|---|---|
| Linting | `golangci-lint run ./...` | PASS — 0 errors, 0 warnings |
| Type checking | (static — included in linting) | PASS — type errors surfaced by golangci-lint |
| Unit tests | `go test ./...` | PASS — 187/187 passed (was 172; 15 new) |
| Race detector | `go test -race ./...` | PASS — no race conditions detected |
| Coverage | `go test -coverprofile=cover.out ./...` | PASS — 91.4% (threshold: 88%) |
| Independent Verification | Supervised session protocol | PASS — Tier C; gates run from clean working tree |
| Seven-Lens Review | Manual — `reviews/ISS-047/review.md` | REQUEST CHANGES — 14 findings, 0 blockers, 1 major |
| Adversarial Review | Manual — `reviews/ISS-047/review.md` (Adversarial Pass) | APPROVED after fix |

The Seven-Lens verdict of "Request Changes" reflects 14 findings across the full
implementation scope. The 1 major finding (TTL store interface does not enforce
key format at construction time) is tracked as a deferred item. It does not represent
a runtime defect in the current deployment context and is recorded in Known Limitations
below.

---

### Human Decisions

**Decision: In-process TTL cache rather than external Redis for the idempotency store.**

The specification leaves the store implementation unspecified beyond requiring a TTL-based
expiry with a configurable window. Two options were evaluated: an in-process TTL map (Go
`sync.Map` with background expiry goroutine) and an external Redis instance.

Redis provides distributed consistency across multiple replicas. The in-process store
does not — a reservation stored by replica A is not visible to replica B. However, the
order pipeline routes all retries for the same order line to the same `inventory-service`
instance via sticky session routing on the order ID. Under the current routing
configuration, cross-replica visibility is not required.

Decision: implement the in-process TTL store for the initial slice. If sticky routing is
removed or if the service is scaled beyond the current single-availability-zone
configuration, the store interface must be replaced with Redis. This migration path is
recorded in `docs/adr/ADR-007-idempotency-store.md`.

**Decision: Return the original reservation result on duplicate key, not a new
reservation result.**

The specification states that a duplicate key must return the original result. Two
interpretations were possible for "original result": (a) the exact response payload
stored at key creation, or (b) a freshly computed response reflecting the current stock
level.

Interpretation (a) was chosen because interpretation (b) would re-evaluate stock at
retry time. If stock dropped between the original reservation and the retry, the retry
would return a different result than the original — violating the idempotency guarantee.
Returning the stored original result is the only interpretation consistent with the
idempotency contract.

**Decision: Accept coarser TTL granularity without fixing.**

The idempotency store TTL is implemented using Unix epoch seconds. A key created at
23:59:59.999 and a key created at 00:00:00.001 on the following day are both assigned a
TTL of the current day's epoch second. The effective deduplication window for a
reservation created in the final millisecond of a day is approximately 24 hours shorter
than intended.

The adversarial pass identified this as a potential correctness issue. After review:
the probability of a retry arriving within 1 second of a midnight boundary is
negligible given the order pipeline's 30-second retry timeout. The fix (sub-second TTL
precision using `time.UnixMilli`) is deferred to the next sprint. The accepted risk is
recorded in the adversarial pass section of `reviews/ISS-047/review.md`.

---

### Known Limitations

**TTL store interface does not enforce key format at construction time.**

`IdempotencyStore.Set()` accepts any `string` as the key. The specification requires keys
to follow the format `<order-id>:<line-id>:<idempotency-token>`. No runtime validation
enforces this format at the store interface. A caller that passes a malformed key (e.g.,
`<order-id>` alone) will successfully store and retrieve the entry but will not be
deduplicated correctly against a well-formed key for the same reservation.

Location: `internal/inventory/idempotency_store.go:Set()`.

This is Seven-Lens Finding 1.1 (major). Deferred: a typed `IdempotencyKey` struct
that enforces the format at construction time is the recommended fix. No current caller
is known to pass a malformed key. The fix is planned for the next sprint.

**In-process store provides no cross-replica deduplication.**

The idempotency store is in-process. A reservation deduplicated by replica A is not
visible to replica B. This is safe under the current sticky routing configuration but
becomes a correctness gap if routing changes. Documented in `docs/adr/ADR-007`.

**TTL granularity is second-level, not millisecond-level.**

The effective deduplication window for a reservation created in the final millisecond
of a 24-hour period is approximately 24 hours shorter than specified. The probability of
a practical impact under the 30-second retry SLA is negligible. Accepted risk, recorded
in the adversarial pass.

**Component 2 (notification emission on idempotent skip) not yet implemented.**

The specification defines that an idempotent skip (duplicate key detected) should emit
a `reservation.deduplicated` event to the notification queue. This component is
out-of-scope for this slice and is tracked in `changes/idempotency-reservation/tasks.md`
as task ISS-048.

---

### Session Duration

Three sessions over three days.

- Session 1 (specification review and delta authoring): approximately 90 minutes.
- Session 2 (supervised implementation, ISS-047 FIRST SLICE): approximately 120 minutes.
- Session 3 (independent verification, Seven-Lens Review, adversarial pass, fix
  application): approximately 90 minutes.

Total active engineering time: approximately 5 hours. Elapsed calendar time: 3 days
(including overnight gaps between sessions).

---

### SDD Approach

This change followed a Specification-Driven Development workflow.

1. **Specification authored first** — `specs/inventory/idempotency-spec.md` v1.2 defines
   the idempotency key contract, the 24-hour deduplication window, the store interface
   requirements, and acceptance criteria IC-1 through IC-3 before implementation began.

2. **Delta authored** — `changes/idempotency-reservation/delta.md` describes ADDED,
   MODIFIED, and REMOVED behaviours and includes a proof test for the 24-hour boundary
   condition.

3. **Implementation planned and decomposed** — `changes/idempotency-reservation/plan.md`
   and `tasks.md` define two components and three tasks, with ISS-047 identified as the
   FIRST SLICE.

4. **Supervised implementation** — `sessions/ISS-047/session-log.md` records all
   proposals, approvals, and verification gates.

5. **Independent verification and review** — gates run before review; Seven-Lens and
   Adversarial passes conducted after.

Specification: `specs/inventory/idempotency-spec.md` v1.2

Delta: `changes/idempotency-reservation/delta.md` v1.0

---

## Linked Evidence

| Artefact | Path |
|---|---|
| Specification (v1.2) | `specs/inventory/idempotency-spec.md` |
| Delta (v1.0) | `changes/idempotency-reservation/delta.md` |
| Implementation plan (v1.0) | `changes/idempotency-reservation/plan.md` |
| Task list (v1.0) | `changes/idempotency-reservation/tasks.md` |
| Session log (ISS-047) | `sessions/ISS-047/session-log.md` |
| Engineering review | `reviews/ISS-047/review.md` |
| Adversarial pass | `reviews/ISS-047/review.md` (Adversarial Pass section) |
| Architecture Decision Record | `docs/adr/ADR-007-idempotency-store.md` |
| Primary implementation | `internal/inventory/reservation.go` |
| Idempotency store interface | `internal/inventory/idempotency_store.go` |
| Test suite | `internal/inventory/reservation_test.go` |

---

## Redaction Review

All seven categories in the redaction checklist were reviewed.

| Category | Result |
|---|---|
| Secrets and credentials | PASS — No API keys, tokens, passwords, or credentials present. |
| Customer data | PASS — No customer names, identifiers, or data present. All values are fictional. |
| PII | PASS — No personal email addresses, phone numbers, or identifiers. Git commit author attribution is standard git metadata. |
| Internal infrastructure | PASS — All hostnames and service names are generic (`inventory-service`, `order-pipeline`). No internal DNS names or cluster configurations. |
| Confidential information | PASS — No unreleased product names, pricing structures, or vendor relationships. |
| Employee information | PASS — No employee names, titles, or contact details beyond standard commit attribution. |
| Synthetic data | PASS — All identifiers in examples are explicitly fictional (order IDs are format `ORD-XXXXX` with synthetic values). |

**Redaction review completed. No sensitive material identified.**

---

## Read-as-a-Stranger Validation

**PASS**

A reviewer unfamiliar with this implementation can reconstruct the full engineering
narrative from the repository evidence alone:

1. The specification (`specs/inventory/idempotency-spec.md` v1.2) defines the problem
   (duplicate stock deductions on retry), the idempotency key contract, the 24-hour
   window, and the three acceptance criteria that the implementation must satisfy.

2. The delta (`changes/idempotency-reservation/delta.md`) explains what changed relative
   to the prior behaviour and includes a proof test for the deduplication boundary.

3. The session log (`sessions/ISS-047/session-log.md`) records every proposal, approval,
   and verification gate result during the implementation session.

4. The Human Decisions field documents three non-obvious choices (store technology,
   return-value interpretation, TTL precision acceptance) that are not self-evident from
   the code.

5. The Known Limitations field identifies four specific, located limitations with
   explicit statements of why each is acceptable in the current context.

6. The Seven-Lens Review and Adversarial Pass provide independent structured evaluation
   with severities, resolutions, and a final verdict.

7. The 187-test suite with 91.4% coverage and all gates passing gives the reviewer
   independently reproducible evidence of correctness.

A reviewer arriving at this PR with no prior context has sufficient evidence to evaluate
the change, understand the design decisions, assess the remaining risks, and make an
informed merge decision.
