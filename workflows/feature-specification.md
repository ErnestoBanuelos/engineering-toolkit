---
asset_id: WF-003
asset_type: Workflow
title: Feature Specification Workflow
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-004
  - STD-005
  - ADR-002
  - ADR-007
  - ADR-009
related:
  - TPL-SPEC-000
  - TPL-SPEC-001
  - TPL-SPEC-002
  - PB-001
tags:
  - specification
  - workflow
  - feature
  - governance
---

# Feature Specification Workflow

## Purpose

This workflow defines the canonical sequence of activities that takes a feature idea through
to an approved, implementation-ready specification. It enforces the governance requirements
of ADR-007 and the specification quality requirements of STD-004.

The workflow is technology-agnostic and applies regardless of language, deployment model,
team structure, or feature size.

---

## Workflow Overview

```
Idea
  ↓
Specification [Draft]
  ↓
Independent Audit [In Review]
  ↓
Resolution [Reviewed]
  ↓
Engineering Approval [Approved]
  ↓
Implementation [Active]
```

Each stage has defined inputs, outputs, decision points, deliverables, and quality gates.
A stage may not begin until all entry criteria for that stage are met.

---

## Stage 1 — Idea

### Purpose

Capture the capability intent before any specification work begins. This stage prevents
specification authors from jumping directly to solution design.

### Inputs

| Input | Description | Required |
|---|---|---|
| Capability name | A short, unambiguous name for the new capability | Yes |
| Problem statement | One paragraph describing the problem this capability solves | Yes |
| Requesting role | The human role that identified the need | Yes |
| Priority | Business or engineering priority (high, medium, low) | Optional |
| Constraints known at this stage | Any known boundaries, inherited rules, or existing systems affected | Optional |

### Outputs

| Output | Description |
|---|---|
| Idea record | A brief written record of the problem statement and the requesting role |

### Decision Point 1 — Is this capability already covered?

Before proceeding to specification, check whether the needed capability is already
provided by an existing asset in the toolkit or in the consuming project.

| Outcome | Action |
|---|---|
| Capability exists and is sufficient | Stop. Reference the existing capability. |
| Capability exists but is insufficient | Proceed to specification with an extension intent |
| Capability does not exist | Proceed to specification |

### Quality Gate 1

- Problem statement written in terms of observable behaviour, not implementation.
- Requesting role identified.
- Duplication check performed.

---

## Stage 2 — Specification

### Purpose

Author the complete feature specification from the idea. The specification defines
the desired behaviour, constraints, errors, integrations, and measurable quality targets.
It does not describe implementation.

### Entry Criteria

- Quality Gate 1 passed.
- Author assigned (named human role).

### Inputs

| Input | Description | Required |
|---|---|---|
| Idea record | Output of Stage 1 | Yes |
| `spec.template.md` | TPL-SPEC-001 from the toolkit | Yes |
| Relevant ADRs | Any ADRs governing the domain of this capability | Yes |
| Existing integration contracts | Documentation of any systems this capability will connect to | When applicable |
| NFR guidance | STD-005 | Yes |

### Activities

1. Copy `spec.template.md` to the target repository.
2. Fill the Purpose section from the problem statement.
3. Fill Section 1 (Behaviour): inputs, processing logic, output structure.
4. Write a minimum of four acceptance criteria following the rules in STD-004 Section 2.
5. Fill Section 2 (Concurrency): answer all concurrency questions.
6. Fill Section 3 (Errors): enumerate every failure mode.
7. Fill Section 4 (Boundaries): list inherited constraints with citations, in-scope items,
   out-of-scope items, and ownership boundaries.
8. Fill Section 5 (Integrations): describe every external integration.
9. Fill Section 6 (NFR Budget): define all measurable targets per STD-005.
10. Self-review against the anti-patterns listed in STD-004 Section 10.

### Outputs

| Output | Description |
|---|---|
| `spec.md` | Completed specification at version 1.0.0 in Draft status |

### Decision Point 2 — Is the specification self-consistent?

Before submitting for audit, the author performs a self-check:

| Check | Pass condition |
|---|---|
| Every placeholder replaced | No `{{PLACEHOLDER}}` text remains |
| All sections present | 6 numbered sections plus Purpose |
| All ACs observable | Every Then clause describes a field, count, code, or artefact |
| NFR targets numeric | No qualitative language in Section 6 |
| Error catalogue complete | Every required input has a missing-input error |
| Out-of-scope list present | At minimum one item listed |

### Quality Gate 2

- All mandatory sections present and complete.
- Minimum four ACs, each covering one behaviour.
- All NFR targets numeric with named measurement methods.
- No placeholders remaining.

---

## Stage 3 — Independent Audit

### Purpose

An engineer who has not authored the specification reviews it for completeness, consistency,
and implementability. This is a governance requirement (ADR-007 L3, ADR-009).

### Entry Criteria

- Quality Gate 2 passed.
- Specification in Draft status.
- Reviewer assigned who has not participated in authoring.

### Inputs

| Input | Description | Required |
|---|---|---|
| `spec.md` | Completed specification from Stage 2 | Yes |
| `audit.template.md` | TPL-SPEC-002 from the toolkit | Yes |
| STD-004 | Engineering Specification Standard | Yes |
| STD-005 | NFR Budget Standard | Yes |
| PB-001 | Specification Review Playbook | Recommended |

### Activities

1. Copy `audit.template.md` to the target repository.
2. Declare the isolation tier (Tier A preferred).
3. Read the specification in full without making notes.
4. Re-read the specification, noting every ambiguity, omission, or unimplementable statement.
5. Produce a minimum of one finding (STD-004 Section 8.2).
6. Assign a resolution (INCORPORATE, REJECT, or DEFER) to each finding.
7. Document each finding with: ID, section, severity, observation, rationale, spec update.
8. Complete the Verification Summary checklist in the audit template.
9. Write the Audit Completion Statement.

### Decision Point 3 — Severity assessment

| Finding severity | Threshold |
|---|---|
| **High** | The specification cannot be implemented as written; an engineer would make an incorrect assumption |
| **Medium** | The specification is ambiguous; an engineer might make inconsistent choices |
| **Low** | The specification is incomplete in a minor way; the omission would likely be noticed during implementation |

### Outputs

| Output | Description |
|---|---|
| `audit.md` | Completed audit report with all findings assigned resolutions |

### Quality Gate 3

- Minimum one finding produced.
- Every finding assigned INCORPORATE, REJECT, or DEFER.
- Every INCORPORATE finding includes a documented spec update (before/after).
- Every DEFER finding includes a gap entry description.
- Verification Summary checklist complete.

---

## Stage 4 — Resolution

### Purpose

Apply the audit findings to the specification and produce the final reviewed version.

### Entry Criteria

- Quality Gate 3 passed.
- `audit.md` delivered to the specification author.

### Inputs

| Input | Description | Required |
|---|---|---|
| `spec.md` | Draft specification | Yes |
| `audit.md` | Completed audit report | Yes |

### Activities

For each finding in `audit.md`:

- **INCORPORATE:** Update the specification with the change described in the finding.
  Verify the update matches the "After" text in the audit.
- **REJECT:** No spec update required. Confirm the rejection rationale is documented
  in `audit.md`.
- **DEFER:** Add a gap entry to the specification in the relevant section. The gap entry
  must contain: the finding ID, what is deferred, an interim proxy if applicable, and
  the role needed to resolve it.

After processing all findings:

1. Update the spec version (1.0.0 → 1.0.1 for audit amendments, per semantic versioning).
2. Update the spec status header to reflect the amendments applied.
3. Confirm no placeholders remain.
4. Confirm no new omissions were introduced by the amendments.

### Decision Point 4 — Are all INCORPORATE findings applied?

| Outcome | Action |
|---|---|
| All INCORPORATE findings applied and verified | Proceed to Stage 5 |
| One or more INCORPORATE findings not applied | Return to Stage 4; apply remaining findings |
| Author disputes an INCORPORATE finding | Escalate to a second independent reviewer |

### Outputs

| Output | Description |
|---|---|
| `spec.md` | Updated specification at version 1.0.1+ in Reviewed status |

### Quality Gate 4

- Spec version updated to reflect amendments.
- Spec status updated to Reviewed.
- All INCORPORATE changes verified against audit `audit.md`.
- All DEFER gap entries present in spec.
- All REJECT rationales present in `audit.md`.

---

## Stage 5 — Engineering Approval

### Purpose

A named human approver validates that the specification is complete, consistent, and ready
to govern implementation. This is a governance requirement (ADR-007 L3).

### Entry Criteria

- Quality Gate 4 passed.
- Specification in Reviewed status.
- Approver identified (must not be the author).

### Inputs

| Input | Description | Required |
|---|---|---|
| `spec.md` | Reviewed specification | Yes |
| `audit.md` | Completed audit report | Yes |

### Activities

1. Read the specification and the audit report.
2. Verify that all INCORPORATE findings are applied.
3. Verify that the specification is implementable (use the Engineering Review questions
   in PB-001 Section 4 as a guide).
4. Approve or request revision.

### Decision Point 5 — Approve or revise?

| Outcome | Action |
|---|---|
| Specification is complete and implementable | Approve. Update spec status to Approved. |
| Specification has unresolved gaps | Request revision. Return to Stage 4. |
| Specification requires a new finding | Assign a new audit finding. Return to Stage 3. |

### Outputs

| Output | Description |
|---|---|
| Approval record | Named approver, date, and any conditions |
| `spec.md` | Specification at Approved status |

### Quality Gate 5

- Named human approver has signed off.
- Spec status is Approved.
- No outstanding INCORPORATE findings.

---

## Stage 6 — Implementation

### Purpose

Implementation begins from the approved specification. The specification is the
authoritative definition of desired behaviour throughout implementation.

### Entry Criteria

- Quality Gate 5 passed.
- Specification in Approved status.

### Inputs

| Input | Description | Required |
|---|---|---|
| `spec.md` | Approved specification | Yes |

### Activities

Implementation is outside the scope of this workflow. The specification governs
what is implemented, not how.

During implementation, if the specification is found to be incomplete or incorrect:

1. Stop implementation on the affected behaviour.
2. Record the gap as a new finding.
3. Return to Stage 3 (Audit) or Stage 5 (Approval) depending on severity.
4. Do not implement an interpretation of the specification that is not supported by
   the text.

### Decision Point 6 — Implementation gap detected

| Outcome | Action |
|---|---|
| Gap is editorial (formatting, typo, broken reference) | Fix in spec at L1; no review required |
| Gap is a missing detail that has one obvious interpretation | Record as finding; seek written confirmation from approver before proceeding |
| Gap is a substantive omission that requires a design decision | Return to Stage 3; do not implement until resolved |

### Outputs

| Output | Description |
|---|---|
| Implemented capability | Behaviour matches the approved specification |
| Updated `spec.md` | Any amendments made during implementation are reflected |

---

## Deliverables Summary

| Stage | Primary deliverable | Status at completion |
|---|---|---|
| 1 — Idea | Idea record | Not tracked as an Engineering Asset |
| 2 — Specification | `spec.md` v1.0.0 | Draft |
| 3 — Independent Audit | `audit.md` | Complete |
| 4 — Resolution | `spec.md` v1.0.1+ | Reviewed |
| 5 — Engineering Approval | Approval record + `spec.md` | Approved |
| 6 — Implementation | Implemented capability | Active |

---

## Anti-Patterns

| Anti-pattern | Description | Correction |
|---|---|---|
| Skipping the audit | Moving from Draft directly to Approved | Mandatory independent audit required (ADR-007 L3) |
| Author self-audits | The specification author conducts the audit | Assign a reviewer who was not involved in authoring |
| Zero-finding audit | Audit report contains no findings | Re-conduct at Tier A; at minimum one finding is required |
| Implementing before approval | Code exists before the specification reaches Approved status | Stop implementation; seek approval |
| Retroactive specification | Specification written after implementation to document what was built | Rewrite from intent; the specification must precede implementation |
| Bypassing resolution | INCORPORATE findings not applied before approval | All INCORPORATE findings must be applied; this is a Quality Gate 4 requirement |
| Silent amendment | Spec updated during implementation without returning to the review cycle | All substantive amendments must go through Stage 3 or 5 |
