---
asset_id: STD-004
asset_type: Standard
title: Engineering Specification Standard
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - ADR-002
  - ADR-003
  - ADR-005
  - ADR-007
  - ADR-009
related:
  - STD-005
  - TPL-SPEC-000
  - TPL-SPEC-001
  - TPL-SPEC-002
  - WF-003
  - PB-001
tags:
  - specification
  - feature
  - design
  - process
---

# Engineering Specification Standard

## Purpose

This standard defines how engineering feature specifications are written, reviewed, and
approved in this organisation. It applies to every new capability, regardless of the
technology stack, language runtime, deployment model, or team.

A specification is the primary artefact that authorises implementation. Implementation
begins from an approved specification. Implementation that precedes a specification is
an anti-pattern (see Section 10).

This standard does not describe what to build. It describes how to describe what to build.

**Related ADRs:** ADR-002 (Engineering Asset Model), ADR-005 (Skill Authoring Standard),
ADR-007 (Repository Governance), ADR-009 (Evidence & Verification Model).

---

## 1. Required Sections

Every feature specification must contain the following sections in the following order.
No section may be omitted. A section with no content must state `None` or `Not applicable`
with a brief rationale.

| Section | Purpose | Minimum content |
|---|---|---|
| **Purpose** | State why this capability exists and what problem it solves | One paragraph; no implementation detail |
| **1. Behaviour** | Define what the capability does | Detection/processing logic, output structure, acceptance criteria |
| **2. Concurrency** | Define execution model and parallel safety | Stateless vs stateful, idempotency, race conditions, parallel limits |
| **3. Errors** | Define every failure mode | Error catalogue, error format, partial-input handling |
| **4. Boundaries** | Define what the capability does and does not do | Explicit in-scope and out-of-scope items, inherited constraints |
| **5. Integrations** | Define every system the capability connects to | Direction of data flow, contracts, ordering dependencies |
| **6. NFR Budget** | Define measurable non-functional targets | See STD-005 for measurement rules |

Sections are numbered 1 through 6. The Purpose section carries no number.

---

## 2. Acceptance Criteria Rules

Acceptance criteria (ACs) live inside Section 1 (Behaviour) as a named sub-section.

### 2.1 Structural Rules

Every AC must follow the Given / When / Then structure exactly:

```
Given   — the precondition state of the system before the operation
When    — the operation or event that triggers the behaviour
Then    — the observable, verifiable outcome
```

### 2.2 Independence Rule

Each AC must test exactly one behaviour. ACs must not share preconditions that make
one AC depend on the output of another. A set of ACs is independent when any single
AC can be evaluated in isolation.

### 2.3 Quantity Rule

A specification must contain a minimum of four ACs. There is no maximum, but each AC
must cover a distinct behaviour. Duplicate behaviours across ACs are an anti-pattern.

### 2.4 Coverage Rule

The AC set must collectively cover:

- The primary success case (the capability behaves correctly with valid input).
- At least one boundary case (minimum valid input, maximum valid input, or empty input).
- At least one failure case (invalid input, missing input, or constraint violation).
- At least one safety or constraint case (the capability respects its inherited boundaries).

### 2.5 Observability Rule

Every `Then` clause must describe an observable outcome: a field value, a section present,
an error code emitted, a count produced, or an escalation triggered. Outcomes stated as
internal states ("the system knows", "the model understands") are not observable and must
be rewritten.

---

## 3. Concurrency Guidance

The concurrency section must answer all of the following questions. If a question is not
applicable, it must be stated as not applicable with a reason.

| Question | Required answer |
|---|---|
| Is the capability stateless or stateful? | State which and describe any state the capability holds |
| Is the capability synchronous or asynchronous? | State which; if asynchronous, describe the completion model |
| Can multiple invocations run simultaneously? | State yes or no; if yes, describe safety guarantees |
| Are there race conditions? | State whether shared mutable resources exist; if yes, describe the locking or ordering mechanism |
| Is the capability idempotent? | State yes or no; if yes, prove it (same input → same output); if no, describe the non-idempotent state |
| Are there parallel input limits? | State the maximum number of parallel inputs; describe the error when the limit is exceeded |

A capability that processes a single input synchronously must still answer each question
explicitly. "This capability is synchronous and processes one input at a time, so the remaining
questions are not applicable" is a complete and acceptable answer.

---

## 4. Boundary Definition Guidance

Boundaries define the edges of the capability. A well-defined boundary prevents scope creep,
reduces ambiguity during implementation, and allows independent audit.

### 4.1 Inherited Constraints

List every constraint inherited from a parent system, a platform policy, or an organisational
rule. Every inherited constraint must cite its source (the document or standard it comes from).
A constraint with no cited source may be challenged during audit.

### 4.2 In-Scope Items

List every behaviour or responsibility explicitly included in this capability. An in-scope item
that is not listed may be disputed during implementation.

### 4.3 Out-of-Scope Items

List every behaviour or responsibility explicitly excluded. An out-of-scope list prevents
assumptions. An empty out-of-scope list is a warning sign: reviewers should challenge whether
obvious adjacent behaviours have been considered and deliberately excluded.

### 4.4 Granularity Rule

Every boundary condition must be implementable. A boundary stated as "the capability respects
system limits" is not implementable. A boundary stated as "the capability does not process
inputs exceeding 10,000 tokens; inputs above this threshold trigger an `INPUT_TOO_LARGE`
error" is implementable. Test every boundary by asking: could an engineer write a test for
this?

### 4.5 Ownership Boundary

If the capability touches data or systems owned by multiple teams, the ownership boundaries
must be stated explicitly. Each team's ownership surface must be identified.

---

## 5. Error Specification Guidance

### 5.1 Error Catalogue

Every specification must contain a complete error catalogue. An error that is not catalogued
is an error that is not handled. The error catalogue must contain:

| Field | Content |
|---|---|
| Error code | A symbolic constant in UPPER_SNAKE_CASE |
| Trigger condition | The exact condition that causes this error |
| Required output | What the caller receives when this error occurs |

### 5.2 Error Format

Every error type must have a defined format. The format must be explicit: field names,
field order, field types, and whether each field is required or optional.

### 5.3 Partial Input Handling

When the capability can operate in a degraded mode (some required input is present, some is
absent), the degraded-mode behaviour must be specified. The specification must state:

- What subset of functionality remains available.
- What is annotated or flagged as incomplete.
- Whether degraded-mode output is labelled as such.

Degraded-mode execution must never produce output that is indistinguishable from a complete
result.

### 5.4 Error Hierarchy

When errors have a natural severity ordering, the ordering must be stated. Higher-severity
errors must take precedence over lower-severity ones when both are triggered simultaneously.

---

## 6. Integration Specification Guidance

Every integration must be described with the following information:

| Field | Content |
|---|---|
| Integrated system | Name of the system or capability |
| Direction | Incoming data, outgoing data, or bidirectional |
| Contract | What fields are consumed or produced, their types, and their constraints |
| Ordering | Whether this integration must precede, follow, or can be concurrent with others |
| Failure mode | What happens if the integrated system is unavailable or returns unexpected data |

### 6.1 Inherited Integration

When the capability inherits integrations from a parent system, the inheritance must be
stated explicitly: which integrations are shared, which are overridden, and which are new.

### 6.2 Unidirectional Integrations

When an integration is unidirectional (data flows only one way), this must be stated.
Bidirectional assumptions in a unidirectional integration are a common source of defects.

### 6.3 Integration Ordering

When the output of this capability feeds into another capability, the ordering dependency
must be stated. When two integrations can run concurrently, this must be stated.

---

## 7. NFR Guidance

Non-functional requirements (NFRs) must be measurable. An NFR without a measurement method
is a preference, not a requirement.

The full NFR measurement standard is defined in STD-005. This section provides the
minimum requirements for specification authors.

### 7.1 Minimum NFR Categories

Every specification must address at minimum:

- **Correctness** — what percentage of valid inputs produce correct output?
- **Safety/Constraint compliance** — what is the acceptable breach rate?
- **Output structure compliance** — what percentage of outputs conform to the defined format?
- **Consistency** — does the same input produce the same output across repeated executions?

Additional categories (latency, throughput, resource consumption, availability) must be
included when the capability has service-level implications.

### 7.2 Reference Input Size

Every NFR must define the reference input size at which the target applies. An NFR without
a reference input size cannot be measured consistently.

### 7.3 Measurement Method

Every NFR metric must name its measurement method: which tool, which test, which data set.
"We will measure this" is not a measurement method. "Run N test cases with known inputs,
measure field X in output, compute the ratio" is a measurement method.

### 7.4 Numeric Targets

NFR targets must be numeric. Accepted forms:

- Exact threshold: `≤ 200 ms`
- Ratio: `≥ 99.5%`
- Count: `0 breaches per 100 invocations`
- Range: `between 2 and 5 sections`

"Fast", "reliable", "accurate" are not NFR targets.

---

## 8. Review Expectations

Every specification must pass independent review before implementation begins. This is a
governance requirement (ADR-007 Section 4, Level 3).

### 8.1 Audit Tier

Specification audits must use Isolation Tier A as the preferred tier:

| Tier | Definition |
|---|---|
| **Tier A** | The reviewer has not participated in authoring this specification prior to this audit. No benefit of the doubt is extended for omissions. |
| **Tier B** | The reviewer has read prior drafts but has not contributed text. Reviewer must declare involvement at the start of the audit. |
| **Tier C** | The reviewer is the author. Self-review only. Not acceptable for publication. Acceptable only for initial draft quality checks. |

### 8.2 Required Findings

An audit must produce a minimum of one finding. An audit that produces zero findings is a
signal that the review was not rigorous. When a specification is genuinely complete, the
finding may be minor — but a finding must be produced.

Every finding must be assigned one of three resolutions:

| Resolution | Meaning |
|---|---|
| **INCORPORATE** | The finding is valid and the specification is updated before proceeding. |
| **REJECT** | The finding is invalid with documented rationale. The specification is unchanged. |
| **DEFER** | The finding is valid but outside scope. A gap entry is added to the specification. |

### 8.3 Spec Update Requirement

Every INCORPORATE resolution must produce a documented spec update: the before state, the
after state, and the finding ID that triggered the change.

### 8.4 Completion Gate

A specification may not proceed to implementation until:

- All INCORPORATE resolutions are applied and verified.
- All REJECT resolutions are documented with rationale.
- All DEFER resolutions have a corresponding gap entry in the specification.
- A named human has approved the specification (ADR-007 L3 governance).

---

## 9. Anti-Patterns

The following practices violate this standard and must be corrected before a specification
is approved.

| Anti-pattern | Description | Correction |
|---|---|---|
| Implementation-first specification | The specification is written after code exists, to describe what was built | Stop implementation. Write the specification from intent. Review before resuming. |
| Unmeasurable NFR | NFR targets use qualitative language ("fast", "accurate") | Replace with numeric targets and named measurement methods per STD-005 |
| Merged acceptance criteria | A single AC tests multiple behaviours | Split into independent ACs, one behaviour each |
| Unobservable Then clause | A Then clause describes internal state, not observable output | Rewrite to describe a field value, count, error code, or produced artefact |
| Missing error catalogue | The error section describes behaviour but does not enumerate error codes | Add a complete error catalogue with codes, triggers, and output formats |
| Implicit out-of-scope | The boundary section lists only what the capability does, not what it does not do | Add an explicit out-of-scope list |
| Unevidenced inherited constraint | An inherited constraint is stated without citing its source | Add a citation (document name, section, or rule) for every inherited constraint |
| Circular integration | Integration A depends on B; integration B depends on A; no ordering is defined | Define the ordering or break the circular dependency |
| Self-audit | The author reviews their own specification at Tier A | Assign a reviewer who was not involved in authoring |
| Zero-finding audit | An audit report contains no findings | Conduct the audit again at Tier A; report at minimum one finding |
| Specification written for a known solution | The specification describes the implementation rather than the desired behaviour | Rewrite from the perspective of observable behaviour; remove implementation details |

---

## 10. Specification Lifecycle

Specifications follow the Engineering Asset lifecycle defined in ADR-002.

| State | Trigger | Gate |
|---|---|---|
| Draft | Author begins writing | None |
| In Review | Author submits for audit | Audit assigned to Tier A reviewer |
| Reviewed | Audit complete; findings resolved | All INCORPORATE resolutions applied |
| Approved | Human approver signs off | ADR-007 L3 governance complete |
| Active | Implementation begins | Approved state required |
| Superseded | A replacement specification is approved | Original spec is updated with `superseded_by` reference |
| Archived | The capability is decommissioned | Human decision required |

A specification in Draft state must not govern implementation. A specification in Active
state may not be materially changed without re-entering the review cycle. Editorial changes
(grammar, formatting, broken links) may be made at L1 without a full review cycle.
