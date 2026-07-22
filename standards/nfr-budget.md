---
asset_id: STD-005
asset_type: Standard
title: NFR Budget Standard
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - ADR-002
  - ADR-003
  - ADR-009
related:
  - STD-004
  - TPL-SPEC-001
tags:
  - nfr
  - performance
  - quality
  - measurement
---

# NFR Budget Standard

## Purpose

This standard defines how measurable Non-Functional Requirement (NFR) budgets are written,
structured, and verified. It applies to every engineering specification, regardless of the
technology stack, language runtime, deployment model, or team.

An NFR budget is not a wish list. It is a set of contractual, numeric, independently
verifiable targets that a capability must meet before it is approved for production.

An NFR without a measurement method is a preference, not a requirement. Every metric in
an NFR budget must be independently reproducible: given the same inputs and the same
measurement procedure, two engineers must reach the same verdict.

---

## 1. Measurement Rules

The following rules apply to every metric in every NFR budget.

### Rule 1 — Numeric targets only

Every target must be a number, a ratio, a count, or a range. Qualitative targets
("fast", "responsive", "reliable", "accurate") are not acceptable.

**Acceptable forms:**

| Form | Example |
|---|---|
| Upper bound | `≤ 200 ms` |
| Lower bound | `≥ 99.5%` |
| Exact count | `0 breaches per 100 invocations` |
| Range | `between 1 and 5 items` |
| Ratio with denominator | `≤ 5% of outputs` |

### Rule 2 — Named measurement method

Every metric must name how it is measured. The measurement method must be specific enough
that a different engineer can reproduce the measurement without asking questions.

Minimum required fields for a measurement method:

- What is counted or timed (the observable).
- How many samples are used (the denominator).
- What tooling or procedure is used (manual review, automated test, specific command).
- Whether the reference input size (Rule 3) applies.

### Rule 3 — Defined reference input size

Every metric must state the input size at which the target applies. If the target applies
across all input sizes, that must be stated explicitly. If the target varies with input
size, each size tier must be defined.

Reference input size is stated in terms appropriate to the capability:

| Capability type | Reference size unit |
|---|---|
| Text processing | Lines, words, or tokens |
| API endpoint | Request payload size in bytes or fields |
| Data pipeline | Rows, records, or file size |
| User interface | Page elements or render items |
| Batch job | Number of items in the batch |

### Rule 4 — Independent verifiability

The measurement must be reproducible by someone who was not involved in authoring the
specification. Self-verification is not acceptable as the sole evidence of an NFR being
met. At minimum, the measurement procedure must be described in sufficient detail that an
independent engineer can execute it.

### Rule 5 — Baseline declared when relative

When a target is stated as relative (e.g., "no more than 10% degradation"), the baseline
must be declared in the same metric row. A relative target with an undeclared baseline is
not measurable.

---

## 2. NFR Categories

### 2.1 Latency

Latency measures the elapsed time between an input being received and the first meaningful
output being produced.

**Required fields:**

| Field | Description |
|---|---|
| Percentile | p50, p95, p99, or maximum (state which) |
| Target | Duration in ms or s |
| Input size | Reference input size at which target applies |
| Measurement method | How measured; exclude warmup runs if applicable |

**Example — well-formed:**

> p95 response time for a single-record read operation: ≤ 150 ms at reference input size
> (payload ≤ 4 KB). Measured with 1,000 consecutive requests against the service under
> nominal load (10 concurrent users). Exclude the first 50 requests as warmup.

**Example — malformed:**

> The service must respond quickly. ✗

**Common failures:**

- Target stated without percentile (p50 and p99 are both "latency" but differ by orders
  of magnitude).
- Measurement conditions not stated (latency under no load vs. production load are
  different numbers).
- Warmup excluded without documentation.

---

### 2.2 Throughput

Throughput measures how many units of work the capability can process per unit of time.

**Required fields:**

| Field | Description |
|---|---|
| Unit | What is counted (requests, records, events, operations) |
| Target | Count per time unit (per second, per minute, per hour) |
| Sustained duration | How long the target must be maintained continuously |
| Concurrency level | Number of concurrent senders during the measurement |
| Measurement method | How measured and what load profile was used |

**Example — well-formed:**

> The processing pipeline must sustain ≥ 500 records/second for a continuous 60-second
> window under a load of 20 concurrent producers. Measured using the benchmark harness at
> `tools/bench/pipeline_bench`. Throughput sampled every 5 seconds; minimum must be met in
> ≥ 90% of 5-second windows.

**Example — malformed:**

> The pipeline should handle high throughput. ✗

**Common failures:**

- Throughput target without a sustained duration (a burst of 1 second does not equal
  sustained throughput).
- Concurrency level not stated (single-threaded throughput and 100-concurrent throughput
  are different numbers).
- Measurement tool not named.

---

### 2.3 Payload

Payload measures the size of inputs and outputs produced or consumed by the capability.

**Required fields:**

| Field | Description |
|---|---|
| Direction | Input payload, output payload, or both |
| Maximum size | Upper bound in bytes, kilobytes, megabytes, lines, tokens, or records |
| Minimum size | Lower bound (when a minimum is meaningful) |
| Handling when exceeded | Error code or truncation behaviour when the limit is breached |
| Measurement method | How payload size is measured |

**Example — well-formed:**

> Maximum request payload: 1 MB. Maximum response payload: 512 KB. Payloads exceeding these
> limits are rejected with HTTP 413 before processing begins. Payload size measured as the
> Content-Length header value after gzip decompression. Measured by injecting payloads of
> 990 KB, 1,000 KB, 1,010 KB and verifying the 413 boundary.

**Example — malformed:**

> Inputs should not be too large. ✗

**Common failures:**

- Limit stated without the error behaviour when the limit is breached.
- Limit ambiguous (bytes, characters, and tokens are different units for text; must specify).
- No lower bound when an empty-payload error case exists.

---

### 2.4 Availability

Availability measures what fraction of time the capability is operational and able to
produce correct output.

**Required fields:**

| Field | Description |
|---|---|
| Target | Percentage uptime over the measurement window |
| Measurement window | Calendar period (e.g., rolling 30 days) |
| Planned maintenance | Whether planned downtime is excluded from the calculation |
| Failure definition | What constitutes an availability event (timeout, error response, wrong output) |
| Measurement method | SLO calculation, health check, or synthetic probe |

**Example — well-formed:**

> Availability target: ≥ 99.5% measured over a rolling 30-day window. Planned maintenance
> windows (declared ≥ 48 hours in advance) are excluded from the calculation. An availability
> event is defined as any response with HTTP status 5xx or a response time exceeding 10
> seconds. Measured via synthetic probes firing every 60 seconds from an external monitoring
> service.

**Example — malformed:**

> The service must be highly available. ✗

**Common failures:**

- "Five nines" stated without the measurement window (99.999% of a 1-minute window is
  trivially achievable; 99.999% of a year is not).
- Failure definition not stated (an HTTP 200 with wrong data may not count as a failure
  depending on the monitoring tool).
- Planned maintenance not addressed.

---

### 2.5 Cost

Cost NFRs define spending limits and alerting thresholds for capabilities with direct
infrastructure or API billing exposure.

**Required fields:**

| Field | Description |
|---|---|
| Cost baseline | The expected cost at nominal usage (must be computed, not guessed) |
| Hard cap | The absolute spend ceiling (must be ≥ 120% of cost baseline) |
| Alert threshold | The spend level that triggers a warning (must be ≤ 75% of hard cap) |
| Attribution | Which team or budget line owns which cost |
| Measurement window | Calendar period for cost tracking |
| Enforcement mechanism | What happens when the hard cap is reached (request rejection, queue drain, circuit breaker) |

**Example — well-formed:**

> Cost baseline: $2,400/month (variable component $2,000; infrastructure component $400).
> Hard cap: $2,880/month (120% of baseline). Alert threshold: $2,160/month (75% of hard cap).
> Variable component owned by the product team. Infrastructure component owned by the platform
> team. Hard cap enforced by circuit breaker returning HTTP 429 to callers. Measured over
> rolling 30-day billing period.

**Example — malformed:**

> We will monitor costs and make sure they don't go too high. ✗

**Common failures:**

- Hard cap below 120% of baseline (insufficient headroom for traffic spikes).
- Alert threshold above 75% of hard cap (insufficient warning time before cap is reached).
- Attribution not stated (no clear owner means no clear escalation path).
- Enforcement mechanism absent (a cap with no enforcement is not a cap).

---

### 2.6 Resource Consumption

Resource consumption NFRs define limits on compute (CPU), memory, disk, and network
resources used by the capability.

**Required fields:**

| Field | Description |
|---|---|
| Resource type | CPU, memory, disk I/O, network I/O, file descriptors, threads |
| Steady-state target | Resource use under nominal load |
| Peak target | Resource use under maximum rated load |
| Reference load | The load level at which steady-state and peak are measured |
| Measurement method | Tool or command used to measure resource use |
| Limit enforcement | What happens when the limit is exceeded |

**Example — well-formed:**

> Memory consumption at reference load (50 concurrent requests): steady-state ≤ 512 MB;
> peak (measured as maximum reading over 5 minutes at 100 concurrent requests) ≤ 1 GB.
> Process is terminated and restarted if RSS exceeds 1.2 GB (120% of peak target). Measured
> using process-level RSS sampling at 10-second intervals.

**Example — malformed:**

> The service should use reasonable memory. ✗

**Common failures:**

- Steady-state and peak not distinguished (a service that uses 2 GB only during batch
  processing is different from one that uses 2 GB continuously).
- Reference load not stated (memory use at 1 request/second vs. 1,000 requests/second
  are different numbers).
- No enforcement mechanism (a limit with no enforcement is a preference).

---

### 2.7 Scalability

Scalability NFRs define how the capability's performance characteristics change as load
increases.

**Required fields:**

| Field | Description |
|---|---|
| Scaling model | Linear, sub-linear, or constant (state which is expected) |
| Load range | The range over which the model applies |
| Degradation allowance | Maximum permitted performance degradation per N-fold load increase |
| Scale-out mechanism | Horizontal scaling, vertical scaling, or sharding (state which is supported) |
| Bottleneck declaration | Any known bottleneck that limits scalability (must not be hidden) |
| Measurement method | How the scaling model is verified |

**Example — well-formed:**

> Latency scales sub-linearly from 10 to 1,000 concurrent users. At 10x load increase
> (100 → 1,000 concurrent users), p95 latency must not increase by more than 3×. Horizontal
> scaling supported by stateless request handling; no sticky sessions required. Known
> bottleneck: the single-writer database model limits write throughput to approximately
> 2,000 writes/second regardless of replica count. Verified by running the load profile at
> 100, 200, 500, and 1,000 concurrent users and recording p95 latency at each level.

**Example — malformed:**

> The service will scale as needed. ✗

**Common failures:**

- Scaling model not stated (linear and sub-linear are different claims).
- Known bottlenecks hidden or omitted.
- Load range not stated (a scalability claim with no upper bound is untestable).

---

### 2.8 Reliability

Reliability NFRs define the expected error rate and recovery behaviour of the capability.

**Required fields:**

| Field | Description |
|---|---|
| Error rate target | Acceptable errors per N invocations under nominal conditions |
| Recovery time | Maximum time to return to normal operation after a failure event |
| Retry policy | Whether the capability retries on failure and the retry parameters |
| Failure isolation | Whether one failure prevents other operations from succeeding |
| Data integrity | Whether partial failures produce corrupt or partial state |
| Measurement method | How error rate is measured |

**Example — well-formed:**

> Error rate target: ≤ 0.1% of requests over any 5-minute window under nominal load
> (≤ 200 concurrent requests). Recovery time after a dependency failure: ≤ 30 seconds before
> health check returns healthy. No retries on 4xx responses; up to 3 retries with
> exponential backoff (base 500 ms) on 5xx responses. Failures in the notification subsystem
> do not affect the processing subsystem (failure isolated by a queue). Partial processing
> failures are rolled back; no partial state is persisted. Error rate measured by counting
> 5xx responses in application logs over 5-minute windows.

**Example — malformed:**

> The service should handle errors gracefully. ✗

**Common failures:**

- Error rate target not stated for a specific window (0.1% over 5 minutes vs. 0.1% over
  24 hours are different thresholds).
- Recovery time not stated (how fast is "fast recovery"?).
- Partial failure behaviour not stated (is corrupt partial state acceptable?).

---

## 3. NFR Budget Structure

An NFR budget in a specification must follow this structure:

```
## N. NFR Budget

### N.1 Reference Input Size
[Define the input size for all measurements in this section]

### N.2 [Category Name]
[Table: Metric | Target | Measurement method]

### N.3 [Category Name]
[Table: Metric | Target | Measurement method]

[Additional category sub-sections as required]
```

Every row in every table must contain all three columns. A metric without a target or
without a measurement method is incomplete.

---

## 4. NFR Table Format

The canonical NFR table format is:

| Metric | Target | Measurement method |
|---|---|---|
| [Name of the measurable property] | [Numeric target] | [Named procedure] |

A fourth column — **Notes** — may be added for deferred items, interim proxies, or
context that does not fit in the measurement method column.

---

## 5. Deferred NFR Items

When a target cannot be defined at specification time (e.g., because the tokeniser,
the deployment model, or the load profile has not yet been decided), the item must
be marked as deferred and an interim proxy provided.

Format:

```
| [Metric] | DEFERRED | [Interim proxy: describe the proxy measurement that will be
                        used until the definitive target is established.
                        Gap: [describe what is needed to resolve the deferral]
                        Owner needed: [role]] |
```

A deferred NFR without an interim proxy is not acceptable. The capability must be
measurable at all times during its lifecycle, even under degraded measurement conditions.

---

## 6. Anti-Patterns

| Anti-pattern | Example | Correction |
|---|---|---|
| Qualitative target | "The service must be fast" | Replace with numeric bound: "p95 latency ≤ 200 ms" |
| No measurement method | "Error rate: ≤ 0.1%" with no measurement description | Add: "Measured by counting 5xx responses in logs over 5-minute windows" |
| No reference size | "Latency ≤ 150 ms" with no stated input size | Add: "at reference input size (payload ≤ 4 KB)" |
| Relative target without baseline | "No more than 10% slower than before" | Add: "Baseline: p95 = 120 ms as of version 2.1.0" |
| Hard cap below 120% of baseline | Cost hard cap set at 105% of baseline | Reset hard cap to ≥ 120% of cost baseline |
| Alert above 75% of hard cap | Alert set at 90% of hard cap | Reset alert to ≤ 75% of hard cap |
| Deferred NFR with no proxy | "Token count: TBD" | Add interim proxy: "Until tokeniser confirmed, use character count ≤ N" |
| NFR for non-observable property | "The model must understand the input" | Rewrite as observable: "≥ 95% of inputs produce outputs matching the expected format" |
