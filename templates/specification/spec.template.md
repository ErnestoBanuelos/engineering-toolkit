---
asset_id: TPL-SPEC-001
asset_type: Template
title: Feature Specification Template
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-004
  - STD-005
  - ADR-002
  - ADR-003
related:
  - TPL-SPEC-000
  - TPL-SPEC-002
tags:
  - specification
  - template
  - feature
---

<!--
USAGE
  Copy this file to your target repository before editing.
  Replace every {{PLACEHOLDER}} with project-specific content.
  Do not modify this template in-place.
  Follow STD-004 for section requirements.
  Follow STD-005 for NFR Budget section.
-->

# {{CAPABILITY_NAME}} — Feature Specification

**Capability:** {{CAPABILITY_NAME}}  
**Spec version:** 1.0.0  
**Status:** Draft  
**Author role:** {{AUTHOR_ROLE}}  
**Date:** {{DATE}}  

---

## Purpose

{{PURPOSE_STATEMENT}}

<!--
  One paragraph. State why this capability exists and what problem it solves.
  Do not describe the implementation. Describe the intent.
  Complete the sentence: "This capability exists so that..."
-->

---

## 1. Behaviour

### 1.1 Overview

<!--
  Describe what the capability does at a high level.
  Identify:
    - The inputs it accepts
    - The processing it performs
    - The outputs it produces
  Keep this section to 2-4 paragraphs.
-->

{{OVERVIEW}}

### 1.2 Accepted Inputs

The capability accepts the following input types:

| Input type | Description | Required / Optional |
|---|---|---|
| {{INPUT_TYPE_1}} | {{INPUT_TYPE_1_DESCRIPTION}} | {{REQUIRED_OR_OPTIONAL}} |
| {{INPUT_TYPE_2}} | {{INPUT_TYPE_2_DESCRIPTION}} | {{REQUIRED_OR_OPTIONAL}} |

<!--
  Add rows as needed.
  For each required input, Section 3 (Errors) must define what happens when it is absent.
-->

### 1.3 Processing Logic

<!--
  Describe the processing logic in numbered steps.
  Each step must be a complete, unambiguous instruction.
  Steps must be ordered. If a step can be parallelised, state that explicitly.
  Do not describe implementation (classes, functions, algorithms).
  Describe observable behaviour.
-->

The capability applies the following logic in the order shown:

1. {{PROCESSING_STEP_1}}
2. {{PROCESSING_STEP_2}}
3. {{PROCESSING_STEP_3}}

<!--
  Add steps as needed.
  For each step that has a failure mode, add the failure mode to Section 3 (Errors).
-->

### 1.4 Output Structure

Every output produced by this capability contains the following sections in the following
order:

```
{{OUTPUT_STRUCTURE}}
```

<!--
  Replace {{OUTPUT_STRUCTURE}} with the literal structure of the output.
  For structured outputs, list every required section and its purpose.
  No section may be omitted in a valid output.
  If a section has no content, state what the empty-content indicator is.
-->

### 1.5 Acceptance Criteria

<!--
  Minimum of four ACs. Each AC must cover exactly one behaviour.
  AC set must collectively cover: primary success, boundary, failure, safety/constraint.
  Every "Then" clause must describe an observable outcome (field value, count, error code, artefact).
  ACs must be independent: no AC depends on the output of another.
-->

**AC-1 — {{AC_1_TITLE}}**

- **Given** {{AC_1_GIVEN}}
- **When** {{AC_1_WHEN}}
- **Then** {{AC_1_THEN}}

**AC-2 — {{AC_2_TITLE}}**

- **Given** {{AC_2_GIVEN}}
- **When** {{AC_2_WHEN}}
- **Then** {{AC_2_THEN}}

**AC-3 — {{AC_3_TITLE}}**

- **Given** {{AC_3_GIVEN}}
- **When** {{AC_3_WHEN}}
- **Then** {{AC_3_THEN}}

**AC-4 — {{AC_4_TITLE}}**

- **Given** {{AC_4_GIVEN}}
- **When** {{AC_4_WHEN}}
- **Then** {{AC_4_THEN}}

<!--
  Add additional ACs as needed for distinct behaviours.
-->

---

## 2. Concurrency

<!--
  Answer every question in this section.
  If a question is not applicable, state it explicitly with a reason.
  A blank or missing answer is not acceptable.
-->

### 2.1 Execution Model

**Stateful / Stateless:** {{STATEFUL_OR_STATELESS}}

<!--
  State which and describe any state the capability holds between invocations.
  If stateless, confirm: no state is retained between invocations.
-->

**Synchronous / Asynchronous:** {{SYNC_OR_ASYNC}}

<!--
  If asynchronous, describe the completion model (callback, event, polling, future).
-->

### 2.2 Parallel Invocation

<!--
  Can multiple invocations run simultaneously?
  If yes: describe safety guarantees (isolated, shared read-only state, lock-protected writes).
  If no: describe what happens when a second invocation is attempted.
-->

{{PARALLEL_INVOCATION_DESCRIPTION}}

**Maximum parallel inputs:** {{MAX_PARALLEL_INPUTS}}

<!--
  State the limit and reference the error in Section 3 that fires when it is exceeded.
  If there is no limit, state "No limit. Each invocation is fully isolated."
-->

### 2.3 Race Conditions

<!--
  Does the capability access shared mutable resources?
  If yes: name the resource and describe the locking or ordering mechanism.
  If no: state "No shared mutable resources. Race conditions are not possible."
-->

{{RACE_CONDITION_DESCRIPTION}}

### 2.4 Idempotency

<!--
  Is the capability idempotent? (Same input → same output, always.)
  If yes: state this explicitly.
  If no: describe what causes non-idempotent behaviour (timestamps, random values, counters).
-->

{{IDEMPOTENCY_DESCRIPTION}}

---

## 3. Errors

### 3.1 Error Catalogue

Every failure mode this capability can produce is listed below. An error not in this
catalogue is an unhandled error.

| Error code | Trigger condition | Required output |
|---|---|---|
| `{{ERROR_CODE_1}}` | {{ERROR_1_TRIGGER}} | {{ERROR_1_OUTPUT}} |
| `{{ERROR_CODE_2}}` | {{ERROR_2_TRIGGER}} | {{ERROR_2_OUTPUT}} |

<!--
  Add rows as needed.
  Error codes must be UPPER_SNAKE_CASE symbolic constants.
  Every required input from Section 1.2 must have a corresponding MISSING_* or INVALID_* error.
  Every processing step from Section 1.3 must have a corresponding error for its failure mode.
-->

### 3.2 Error Format

Every error response from this capability follows this format:

```
{{ERROR_FORMAT}}
```

<!--
  Replace {{ERROR_FORMAT}} with the literal format of every error response.
  List every field, its type, and whether it is required or optional.
  Example:
    Error: <ERROR_CODE>
    Detail: <one-sentence description of what went wrong>
    Required: <one-sentence description of what is needed to proceed>
-->

### 3.3 Partial Input Handling

<!--
  Can the capability operate in a degraded mode when some inputs are missing?
  If yes:
    - Describe what functionality is available in degraded mode.
    - Describe what is flagged as incomplete.
    - Confirm that degraded output is labelled as such (not indistinguishable from complete output).
  If no:
    - State that missing required inputs always trigger an error from Section 3.1.
-->

{{PARTIAL_INPUT_HANDLING}}

---

## 4. Boundaries

### 4.1 Inherited Constraints

<!--
  List every constraint inherited from a parent system, platform policy, or organisational rule.
  Every constraint must cite its source.
  A constraint without a source citation may be challenged during audit.
-->

| Constraint | Source |
|---|---|
| {{INHERITED_CONSTRAINT_1}} | {{SOURCE_1}} |
| {{INHERITED_CONSTRAINT_2}} | {{SOURCE_2}} |

### 4.2 In-Scope

<!--
  List every behaviour explicitly included in this capability.
  Be specific. A vague in-scope item creates implementation disputes.
-->

The following behaviours are explicitly in scope:

- {{IN_SCOPE_1}}
- {{IN_SCOPE_2}}
- {{IN_SCOPE_3}}

### 4.3 Out-of-Scope

<!--
  List every behaviour explicitly excluded from this capability.
  An empty out-of-scope list is a warning sign.
  Consider: what obvious adjacent behaviour has been deliberately excluded?
-->

The following behaviours are explicitly out of scope:

- {{OUT_OF_SCOPE_1}}
- {{OUT_OF_SCOPE_2}}
- {{OUT_OF_SCOPE_3}}

### 4.4 Ownership Boundaries

<!--
  If the capability touches data or systems owned by multiple teams, identify each
  team's ownership surface here.
  If the capability has a single owner, state: "Single owner: {{TEAM_NAME}}."
-->

{{OWNERSHIP_BOUNDARY_DESCRIPTION}}

---

## 5. Integrations

<!--
  Every system this capability connects to must have an entry in this section.
  If there are no integrations, state: "This capability has no external integrations."
  Use sub-sections 5.1, 5.2, etc. for each integration.
-->

### 5.1 {{INTEGRATION_1_NAME}}

**Direction:** {{INCOMING_OUTGOING_BIDIRECTIONAL}}  
**Contract:** {{CONTRACT_DESCRIPTION}}  
**Ordering:** {{ORDERING_DEPENDENCY}}  
**Failure mode:** {{FAILURE_MODE}}

<!--
  Contract: what fields are consumed or produced, their types, and constraints.
  Ordering: must this integration precede, follow, or can it run concurrently with others?
  Failure mode: what happens if this integration is unavailable or returns unexpected data?
-->

### 5.2 {{INTEGRATION_2_NAME}}

**Direction:** {{INCOMING_OUTGOING_BIDIRECTIONAL}}  
**Contract:** {{CONTRACT_DESCRIPTION}}  
**Ordering:** {{ORDERING_DEPENDENCY}}  
**Failure mode:** {{FAILURE_MODE}}

<!--
  Add 5.N sub-sections as needed for each integration.
-->

---

## 6. NFR Budget

<!--
  All NFR targets must be numeric.
  All measurement methods must be named procedures, not intent statements.
  Follow STD-005 for full guidance on each category.
-->

### 6.1 Reference Input Size

The following reference input size applies to all NFR measurements in this section unless
a specific metric states otherwise:

{{REFERENCE_INPUT_SIZE_DESCRIPTION}}

<!--
  Define the input size in units appropriate to this capability:
  lines, bytes, records, tokens, requests, etc.
-->

### 6.2 Correctness

| Metric | Target | Measurement method |
|---|---|---|
| {{CORRECTNESS_METRIC_1}} | {{TARGET_1}} | {{MEASUREMENT_1}} |
| {{CORRECTNESS_METRIC_2}} | {{TARGET_2}} | {{MEASUREMENT_2}} |

### 6.3 Safety and Constraint Compliance

| Metric | Target | Measurement method |
|---|---|---|
| {{SAFETY_METRIC_1}} | {{TARGET_1}} | {{MEASUREMENT_1}} |
| {{SAFETY_METRIC_2}} | {{TARGET_2}} | {{MEASUREMENT_2}} |

### 6.4 Output Structure Compliance

| Metric | Target | Measurement method |
|---|---|---|
| {{STRUCTURE_METRIC_1}} | {{TARGET_1}} | {{MEASUREMENT_1}} |

### 6.5 Consistency

| Metric | Target | Measurement method |
|---|---|---|
| Idempotency | Given identical inputs, output is identical across {{N}} repeated invocations | Run same input {{N}} times; diff outputs |

### 6.6 {{ADDITIONAL_NFR_CATEGORY}}

<!--
  Add sub-sections for Latency, Throughput, Payload, Availability, Cost, Resource
  Consumption, Scalability, or Reliability as required by this capability.
  Use the table format: Metric | Target | Measurement method
  Follow STD-005 for each category's required fields.
-->

| Metric | Target | Measurement method |
|---|---|---|
| {{NFR_METRIC_N}} | {{TARGET_N}} | {{MEASUREMENT_N}} |

<!--
  For deferred NFR items, use this format:

  | {{METRIC}} | DEFERRED | Interim proxy: {{PROXY_DESCRIPTION}}
                            Gap: {{WHAT_IS_NEEDED}}
                            Owner needed: {{ROLE}} |
-->
