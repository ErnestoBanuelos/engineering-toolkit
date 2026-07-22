---
asset_id: WF-004
asset_type: Workflow
title: Brownfield Change Analysis Workflow
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-006
  - ADR-002
  - ADR-007
  - ADR-009
related:
  - TPL-BD-000
  - TPL-BD-001
  - TPL-BD-002
  - PB-002
  - AUTO-002
  - WF-003
tags:
  - brownfield
  - delta
  - workflow
  - change-management
  - backward-compatibility
  - governance
---

# Brownfield Change Analysis Workflow

## Purpose

This workflow defines the canonical sequence of activities that takes a
post-approval change request through analysis, documentation, review, and
approval before implementation begins.

The primary output is a Brownfield Delta: a formal, reviewable record of what
the change preserves, adds, modifies, and removes from the existing contract.

The workflow enforces the governance requirements of ADR-007 and the
delta quality requirements of STD-006.

The workflow is technology-agnostic. It applies regardless of language,
deployment model, domain, team size, or the nature of the change.

---

## Workflow Overview

```
Current Behaviour
      ↓
  Proposed Change
      ↓
   Delta Draft
      ↓
  REMOVED Audit
      ↓
 Risk Assessment
      ↓
Engineering Review
      ↓
    Approval
      ↓
 Implementation
```

Each stage has defined inputs, outputs, decision points, deliverables, and
quality gates. A stage may not begin until all entry criteria for that stage
are met.

---

## Stage 1 — Current Behaviour

### Purpose

Establish a complete, accurate record of the existing approved behaviour before
any analysis of the proposed change begins. This stage prevents the most common
delta authoring error: analysing the change before fully understanding the
baseline.

### Inputs

| Input | Description | Required |
|---|---|---|
| Approved baseline specification | The specification at the version in effect at the time of the change request | Yes |
| Change request | A description of the proposed change from the requester | Yes |
| Requester identity and role | Who is requesting the change and in what capacity | Yes |

### Activities

1. Locate the approved baseline specification. Confirm its version and status.
   A specification must be in Approved or Active status (ADR-002) to be the
   subject of a Brownfield Delta. If the specification is in Draft or Reviewed
   status, the change is handled through the Feature Specification Workflow
   (WF-003), not this workflow.

2. Read the specification from start to finish. Do not read it with the change
   in mind. Read it as a consumer would: to understand every existing contract,
   classification, output field, error code, and constraint.

3. List every caller-visible behaviour. Focus on:
   - Output structure and field names
   - Classification schemes (enumerations, severity levels, status values)
   - Error codes and their trigger conditions
   - Constraints stated as unconditional rules
   - Integration contracts that consumers depend on
   - Acceptance criteria that define the specification's behavioural ceiling

4. Record any ambiguities in the baseline. An ambiguous baseline specification
   produces an ambiguous delta. Resolve ambiguities before proceeding.

### Decision Point 1 — Is the baseline well-understood?

| Outcome | Action |
|---|---|
| Every caller-visible behaviour can be stated | Proceed to Stage 2 |
| One or more behaviours are ambiguous | Record the ambiguity; seek clarification from the approver before proceeding |
| The baseline specification does not exist or is not in Approved/Active status | This workflow does not apply; use WF-003 instead |

### Outputs

| Output | Description |
|---|---|
| Baseline inventory | A structured list of caller-visible behaviours in the approved specification |

### Quality Gate 1

- Baseline specification confirmed at Approved or Active status.
- Every caller-visible behaviour listed.
- No ambiguities unresolved.

---

## Stage 2 — Proposed Change

### Purpose

Analyse the proposed change to determine its scope and identify the categories
of change it introduces: new behaviour, modifications to existing behaviour,
and removal of existing guarantees.

### Entry Criteria

- Quality Gate 1 passed.
- Baseline inventory complete.

### Inputs

| Input | Description | Required |
|---|---|---|
| Baseline inventory | Output of Stage 1 | Yes |
| Change request | The proposed change description | Yes |

### Activities

1. Categorise the change into three types:
   - **Additive**: introduces new behaviour that did not exist before.
   - **Modification**: changes existing behaviour while preserving the consumer
     contract.
   - **Removal**: eliminates a guarantee or constraint that consumers could
     previously rely on.

2. For each additive change, ask:
   - Does this addition require any existing behaviour to change in order to
     accommodate it?
   - Does this addition remove any existing guarantee (e.g., a maximum value
     ceiling, a fixed enumeration size, an unconditional constraint)?

3. For each modification, ask:
   - Is the modification truly backward compatible? Would a consumer whose code
     was correct before the modification still produce correct results after it?
   - If the answer is no, reclassify as a removal.

4. For each removal:
   - Identify whether it is explicit (the specification explicitly stated the
     guarantee) or implicit (a consumer could reasonably infer the guarantee
     from the specification as approved).
   - Both explicit and implicit removals must be documented.

5. Identify the most risky preserved behaviour: the behaviour that was in the
   baseline, must remain after the change, and is most susceptible to
   regression based on the change's implementation proximity.

### Decision Point 2 — Is the change scope bounded?

| Outcome | Action |
|---|---|
| Change scope is fully understood | Proceed to Stage 3 |
| Change scope requires clarification from the requester | Seek clarification before proceeding; do not estimate scope |
| Change is so significant that a new specification is required | Use WF-003; supersede the existing specification instead of amending it |

### Outputs

| Output | Description |
|---|---|
| Change scope analysis | Categorised list of additions, modifications, and removals |

### Quality Gate 2

- Change categorised into additions, modifications, and removals.
- Implicit removals identified (not only explicit ones).
- Most risky preserved behaviour identified.

---

## Stage 3 — Delta Draft

### Purpose

Author the complete Brownfield Delta from the change scope analysis. This
is the primary documentation stage.

### Entry Criteria

- Quality Gate 2 passed.
- `delta.template.md` (TPL-BD-001) available.
- Author assigned.

### Inputs

| Input | Description | Required |
|---|---|---|
| Baseline inventory | Output of Stage 1 | Yes |
| Change scope analysis | Output of Stage 2 | Yes |
| `delta.template.md` | TPL-BD-001 from the toolkit | Yes |
| STD-006 | Brownfield Delta Standard | Yes |

### Activities

1. Copy `delta.template.md` to the target repository change directory.

2. Fill the **Preserved Behaviour** section:
   - Write exactly one sentence.
   - State the most important caller-visible, testable output property that
     must survive the change.
   - Refer to STD-006 Section 2 for rules.

3. Fill the **ADDED** section:
   - List every newly introduced caller-visible behaviour identified in Stage 2.
   - Number each item A-1, A-2, ...
   - Do not include internal changes.

4. Fill the **MODIFIED** section:
   - List every behaviour whose implementation changes while remaining
     backward compatible.
   - For every item, write a Before description and an After description.
   - Number each item M-1, M-2, ...
   - For every item in ADDED, ask: "Does any existing behaviour need to change
     to accommodate this addition?" If yes, add it here.

5. Fill the **REMOVED** section:
   - This is the most effort-intensive section.
   - Apply STD-006 Section 5.2 (common removal categories) to each item
     in ADDED and MODIFIED.
   - Include both explicit and implicit removals.
   - Number each item R-1, R-2, ...

6. Self-review against the anti-patterns listed in STD-006 Section 9.

### Decision Point 3 — Is the delta draft internally consistent?

| Check | Pass condition |
|---|---|
| Every ADDED item is caller-visible | None describe internal changes |
| Every MODIFIED item has Before and After | No item is missing either description |
| Every MODIFIED item is backward compatible | Items that break consumers moved to REMOVED |
| No fabricated removals | Every R-N item citable from the baseline specification |
| Preserved Behaviour is one sentence | Not a list; not structural |

### Outputs

| Output | Description |
|---|---|
| `delta.md` | Draft Brownfield Delta at version 1.0.0 |

### Quality Gate 3

- All sections present and populated.
- No `{{PLACEHOLDER}}` tokens remaining.
- ADDED, MODIFIED, and REMOVED categories applied consistently.
- Preserved Behaviour states a testable output property.

---

## Stage 4 — REMOVED Audit

### Purpose

Apply the mandatory REMOVED Audit to the draft delta. This is a structured
self-challenge that verifies the REMOVED section is complete and honest before
the delta is submitted for independent review.

### Entry Criteria

- Quality Gate 3 passed.
- `delta.md` in Draft status.

### Activities

1. For each item in ADDED, ask:
   "Does adding this item remove any previous guarantee?"
   Record the answer in the REMOVED Audit section of the delta.

2. For each item in MODIFIED, ask:
   "Does this modification remove any previous guarantee from the original form?"
   Record the answer.

3. Apply each removal category from STD-006 Section 5.2 in sequence:
   - Maximum value assumptions
   - N-level enumeration assumptions
   - Unconditional constraint relaxations
   - Format stability guarantees
   - Acceptance criteria ceiling assumptions
   - Consumer parser/matcher assumptions

   For each category: state whether it is affected and why.

4. Apply the consumer perspective: read the approved specification as a
   consumer implementing against it for the first time. Which assumptions does
   the change invalidate? Are all of them in REMOVED?

5. Write the REMOVED Audit completion statement using the format in STD-006
   Section 6.3.

6. If any new removals are found during this stage, add them to the REMOVED
   section and re-run steps 1–4 until no new removals are found.

### Decision Point 4 — Is REMOVED complete?

| Outcome | Action |
|---|---|
| REMOVED Audit completion statement written; no open items | Proceed to Stage 5 |
| Audit found additional removals | Add them to REMOVED; re-run the audit |
| A MODIFIED item is found to break consumers | Move it to REMOVED; re-run the audit |

### Outputs

| Output | Description |
|---|---|
| `delta.md` | Updated delta with REMOVED Audit section complete |

### Quality Gate 4

- REMOVED Audit section complete.
- Completion statement present.
- No MODIFIED items that break consumers.

---

## Stage 5 — Risk Assessment

### Purpose

Identify the highest-risk preserved behaviour and define a proof test that
demonstrates it survives the change. This stage produces the Risk Note section
of the delta.

### Entry Criteria

- Quality Gate 4 passed.

### Activities

1. Review the preserved behaviour statement from Stage 3.

2. Identify the specific implementation boundary where the new behaviour and
   the preserved behaviour are most proximate. Shared trigger conditions,
   conditional relaxations, and adjacent enumeration values are common
   high-risk boundaries.

3. Write the Risk Note:
   - Name the highest-risk preserved behaviour.
   - Explain specifically which implementation pattern makes regression likely.
   - Define the specific failure mode (not vague possibility).

4. Write the Proof Test:
   - Use Given / When / Then format.
   - Target the exact boundary condition between new and preserved behaviour.
   - State the distinguishing condition: what would a passing test produce vs.
     a failing test.

### Decision Point 5 — Is the proof test boundary-targeted?

| Outcome | Action |
|---|---|
| Proof test exercises the boundary between new and preserved behaviour | Proceed to Stage 6 |
| Proof test exercises only the new behaviour's happy path | Rewrite to target the boundary |
| No boundary condition can be identified | Restate: this only occurs if the change has no shared trigger surface with existing behaviour, which is rare; re-examine |

### Outputs

| Output | Description |
|---|---|
| `delta.md` | Delta with Risk Note and Proof Test complete |

### Quality Gate 5

- Risk Note names a specific implementation pattern.
- Proof Test is in Given / When / Then format.
- Proof Test targets the boundary between new and preserved behaviour.

---

## Stage 6 — Engineering Review

### Purpose

The delta author applies the Engineering Review self-challenge before
submitting for independent review. This prevents the most common categories
of delta incompleteness from reaching the reviewer.

### Entry Criteria

- Quality Gate 5 passed.
- All delta sections complete.

### Activities

Apply all five Engineering Review questions from STD-006 Section 8:

1. Is ADDED complete?
2. Is MODIFIED complete?
3. Is REMOVED honest?
4. Are backward compatibility guarantees missing?
5. Would an implementation engineer understand exactly what changed?

For each question:
- State the answer with rationale.
- Describe what was examined.
- Describe what was found (if anything) and incorporated.
- Describe what was examined and excluded, with the reason for exclusion.

### Decision Point 6 — Is the Engineering Review complete?

| Outcome | Action |
|---|---|
| All five questions answered with examination rationale | Proceed to Stage 7 |
| Any question answered "yes" without examination rationale | Provide the rationale before proceeding |
| Engineering Review found missing items | Incorporate them; re-run Stage 4 and Stage 6 |

### Outputs

| Output | Description |
|---|---|
| `delta.md` | Delta with Engineering Review section complete |
| `review-checklist.md` | Pass 1 (author self-review) complete |

### Quality Gate 6

- All five Engineering Review questions answered.
- Examination rationale present for each answer.
- Pass 1 of `review-checklist.md` (TPL-BD-002) complete.
- Delta in Draft status, ready for independent review.

---

## Stage 7 — Approval

### Purpose

An independent reviewer and a named human approver validate the delta before
implementation begins.

### Entry Criteria

- Quality Gate 6 passed.
- Independent reviewer assigned (not the delta author).
- Approver identified (not the delta author).

### Inputs

| Input | Description | Required |
|---|---|---|
| `delta.md` | Complete draft delta | Yes |
| `review-checklist.md` | Pass 1 (author self-review) complete | Yes |
| STD-006 | Brownfield Delta Standard | Yes |
| PB-002 | Backward Compatibility Review Playbook | Recommended |

### Activities

1. **Independent reviewer** completes Pass 2 of `review-checklist.md`:
   - Applies content challenges in Part 2 of TPL-BD-002.
   - Produces a minimum of one finding (Section 2.8).
   - A zero-finding review is evidence of insufficient rigour.

2. **Author** addresses every reviewer finding:
   - INCORPORATE: update the delta.
   - REJECT: document the rejection rationale.
   - DEFER: add a gap entry to the delta.
   - Complete Part 3 (Resolution Record) of `review-checklist.md`.

3. **Named human approver** reviews delta and resolution record:
   - Confirms all INCORPORATE findings are applied.
   - Confirms all REJECT findings are documented.
   - Approves or returns for revision.
   - Completes Part 4 (Approval Record) of `review-checklist.md`.

### Decision Point 7 — Approve or revise?

| Outcome | Action |
|---|---|
| Delta is complete, honest, and implementation-ready | Approve. Update delta status to Approved. |
| Delta has unresolved gaps | Return to Stage 3 or Stage 4 as appropriate |
| REMOVED section is found to be incomplete | Return to Stage 4 (REMOVED Audit) |

### Outputs

| Output | Description |
|---|---|
| `delta.md` | Delta at Approved status |
| `review-checklist.md` | All four parts complete |
| Approval record | Named approver, date, and any conditions |

### Quality Gate 7

- Named human approver has signed off.
- Delta status is Approved.
- No outstanding INCORPORATE findings.
- Pass 2 complete with at minimum one finding.

---

## Stage 8 — Implementation

### Purpose

Implementation begins from the approved delta in conjunction with the approved
(updated) specification. The delta governs what changes; the specification
governs the full behaviour.

### Entry Criteria

- Quality Gate 7 passed.
- Delta in Approved status.
- Specification updated to incorporate the change (or update is the first
  implementation activity, before any code is written).

### Activities

1. Update the baseline specification to reflect all ADDED and MODIFIED items.
   The specification must reach a new version (e.g., 1.0.0 → 1.1.0 for a
   new capability; 1.0.1 → 1.1.0 for a material amendment) before or
   concurrently with implementation.

2. Implement the change according to the ADDED and MODIFIED sections.

3. Implement the proof test defined in the Risk Note. This test must pass
   before the change is considered complete.

4. If implementation reveals that the delta is incomplete or incorrect:
   - Stop implementation on the affected behaviour.
   - Return to Stage 3 or Stage 4 as appropriate.
   - Do not implement an interpretation of the delta that is not supported
     by its text.

### Decision Point 8 — Implementation gap detected

| Outcome | Action |
|---|---|
| Gap is editorial (formatting, typo, broken reference in delta) | Fix the delta at L1; no review required |
| Gap reveals a missing REMOVED item | Return to Stage 4; extend REMOVED; re-approve |
| Gap reveals a missing ADDED item | Return to Stage 3; extend ADDED; re-approve |

### Outputs

| Output | Description |
|---|---|
| Implemented change | Behaviour matches the ADDED and MODIFIED sections of the approved delta |
| Updated specification | Specification at new version with all delta items incorporated |
| Proof test result | The proof test defined in the Risk Note passes |

---

## Deliverables Summary

| Stage | Primary deliverable | Status at completion |
|---|---|---|
| 1 — Current Behaviour | Baseline inventory | Not tracked as an Engineering Asset |
| 2 — Proposed Change | Change scope analysis | Not tracked as an Engineering Asset |
| 3 — Delta Draft | `delta.md` v1.0.0 | Draft |
| 4 — REMOVED Audit | `delta.md` with REMOVED Audit | Draft |
| 5 — Risk Assessment | `delta.md` with Risk Note | Draft |
| 6 — Engineering Review | `delta.md` complete; `review-checklist.md` Pass 1 | Draft — ready for review |
| 7 — Approval | `delta.md` Approved; `review-checklist.md` all parts complete | Approved |
| 8 — Implementation | Implemented change; updated specification | Active |

---

## Anti-Patterns

| Anti-pattern | Description | Correction |
|---|---|---|
| Skipping the baseline read | Author analyses the change without first reading the full approved specification | Mandatory: complete Stage 1 before beginning Stage 2 |
| Delta written after implementation | The delta is produced to document a change that was already implemented | Stop. The delta must precede implementation. A retroactive delta is not a governance artefact. |
| REMOVED Audit as a formality | The audit section states "complete" without examining any category | Apply the six-step procedure in STD-006 Section 6.2 |
| Zero-finding independent review | Reviewer produces no findings | Re-conduct; minimum one finding is required |
| MODIFIED used for breaking changes | A change that breaks consumers is classified as MODIFIED | Reclassify as REMOVED |
| Author self-approves | The delta author is also the approver | Approver must be a different named human |
| Proof test covers only the new path | The test demonstrates the new behaviour but not the boundary with preserved behaviour | Rewrite to target the boundary condition |
| Specification not updated before implementation | Implementation proceeds without updating the approved specification | Update the specification first; the implementation must derive from the specification |
