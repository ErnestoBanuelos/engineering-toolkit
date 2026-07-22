---
asset_id: TPL-BD-001
asset_type: Template
title: Brownfield Delta Template
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-006
  - ADR-002
  - ADR-003
related:
  - TPL-BD-000
  - TPL-BD-002
  - WF-004
tags:
  - brownfield
  - delta
  - template
  - change-management
  - backward-compatibility
---

<!--
USAGE INSTRUCTIONS (remove this block before publishing the delta)

This template produces a Brownfield Delta: the canonical artefact for
governing a post-approval change to an existing engineering specification.

Before filling this template:
  1. Read STD-006 (Brownfield Delta Standard) in full.
  2. Read the approved baseline specification in its entirety.
  3. Understand every existing behaviour, output contract, and constraint.

Replace every {{PLACEHOLDER}} with real content.
A template that still contains {{...}} tokens is not ready for review.

Section ordering is fixed. Do not reorder, rename, or remove sections.
Each section has a minimum content requirement described below.

-->

# Change

{{CHANGE_TITLE}}

**Delta version:** {{VERSION}}
**Baseline specification:** {{BASELINE_SPEC_PATH}} — version {{BASELINE_SPEC_VERSION}}
**Status:** Draft
**Author role:** {{AUTHOR_ROLE}}
**Date:** {{DATE}}
**Requested by:** {{REQUESTER}}

---

## Preserved Behaviour

<!--
RULES (STD-006 Section 2):
- Exactly ONE sentence.
- Must describe a caller-visible, testable output property.
- Must not describe internal structure, architecture, or implementation.
- Must be the behaviour whose regression would be most costly.
- This sentence becomes the subject of the Risk Note below.

Bad example: "Backward compatibility is maintained."
             (not specific, not testable)

Good example: "All [existing state] inputs continue to produce the same
               [specific output fields/classifications/contract]
               as defined in version [X]."
-->

{{PRESERVED_BEHAVIOUR_ONE_SENTENCE}}

---

## ADDED

<!--
RULES (STD-006 Section 3):
- List every newly introduced caller-visible behaviour.
- Number each item A-1, A-2, A-3, ...
- Caller-visible only: internal changes do not belong here.
- No fabrications: every item must be directly caused by this change.
- After drafting, apply the completeness check:
  "Can a consumer encounter anything new that is not listed here?"
-->

### A-1 — {{ADDITION_TITLE}}

{{ADDITION_DESCRIPTION}}

### A-2 — {{ADDITION_TITLE}}

{{ADDITION_DESCRIPTION}}

<!-- Add additional A-N items as required. -->

---

## MODIFIED

<!--
RULES (STD-006 Section 4):
- List every behaviour whose implementation changes while remaining
  backward compatible with existing consumers.
- Number each item M-1, M-2, M-3, ...
- Every item must include a Before and After description.
- If the modification breaks existing consumers, it belongs in REMOVED,
  not here.
- After drafting, apply the completeness check:
  "For every item in ADDED, does any existing behaviour need to change
  to accommodate it? If yes, is it listed here?"
-->

### M-1 — {{MODIFICATION_TITLE}}

**Before:** {{BEFORE_DESCRIPTION}}

**After:** {{AFTER_DESCRIPTION}}

### M-2 — {{MODIFICATION_TITLE}}

**Before:** {{BEFORE_DESCRIPTION}}

**After:** {{AFTER_DESCRIPTION}}

<!-- Add additional M-N items as required. -->

---

## REMOVED

<!--
RULES (STD-006 Section 5):
- List every caller-visible guarantee that existed before and does not
  exist after this change.
- Include both EXPLICIT guarantees (documented in the specification) and
  IMPLICIT guarantees (consumer assumptions reasonably inferred from the
  approved specification).
- Number each item R-1, R-2, R-3, ...
- Do NOT fabricate removals.
- Spend extra effort here. Missing a removal is more dangerous than a
  missing ADDED or MODIFIED item.

Common removal categories to check (STD-006 Section 5.2):
  [ ] Maximum value assumptions (e.g., "X was the ceiling")
  [ ] N-level enumeration assumptions (e.g., "exactly N values existed")
  [ ] Unconditional constraint relaxations
  [ ] Format stability guarantees
  [ ] Acceptance criteria ceiling assumptions
  [ ] Consumer parser/matcher assumptions
-->

### R-1 — {{REMOVAL_TITLE}}

{{REMOVAL_DESCRIPTION}}

### R-2 — {{REMOVAL_TITLE}}

{{REMOVAL_DESCRIPTION}}

<!-- Add additional R-N items as required. -->

---

## REMOVED Audit

<!--
RULES (STD-006 Section 6):
- Apply the audit question to every ADDED and MODIFIED item:
  "Does this item remove any previous guarantee?"
- Apply the audit question to each category in STD-006 Section 5.2.
- State explicitly if a category is not affected and why.
- End with one of two completion statements (Section 6.3).

Do not rush this section. This is the most commonly incomplete
section of a Brownfield Delta.
-->

**Audit question applied:** "What behaviour existed before this change that
no longer exists after it?"

**For each ADDED item:**

- A-1: {{AUDIT_RESULT_FOR_A1}}
- A-2: {{AUDIT_RESULT_FOR_A2}}
<!-- Add entries for each A-N item. -->

**For each MODIFIED item:**

- M-1: {{AUDIT_RESULT_FOR_M1}}
- M-2: {{AUDIT_RESULT_FOR_M2}}
<!-- Add entries for each M-N item. -->

**Common removal categories reviewed:**

| Category | Affected? | Notes |
|---|---|---|
| Maximum value assumptions | {{YES/NO}} | {{NOTES}} |
| N-level enumeration assumptions | {{YES/NO}} | {{NOTES}} |
| Unconditional constraint relaxations | {{YES/NO}} | {{NOTES}} |
| Format stability guarantees | {{YES/NO}} | {{NOTES}} |
| Acceptance criteria ceiling assumptions | {{YES/NO}} | {{NOTES}} |
| Consumer parser/matcher assumptions | {{YES/NO}} | {{NOTES}} |

**Audit completion statement:**

{{COMPLETION_STATEMENT}}

<!-- Use one of:
"REMOVED is complete. [N] genuine removals identified. No fabricated
removals. Each removal describes a caller-visible guarantee that
disappears as a direct consequence of this change."

OR, if the audit found additional items:
"The initial REMOVED section was incomplete. [N] additional removals
identified during the audit. REMOVED now contains [M] items. Each is
a genuine caller-visible removal."
-->

---

## Risk Note

<!--
RULES (STD-006 Section 7):
- Identify the highest-risk preserved behaviour (typically at the
  boundary between old and new behaviour).
- Explain specifically which implementation pattern makes regression
  likely.
- Define a proof test that targets the exact boundary condition.
-->

### Highest-Risk Preserved Behaviour

{{HIGHEST_RISK_BEHAVIOUR}}

### Why It Is at Risk

{{RISK_EXPLANATION}}

The specific failure mode is: {{SPECIFIC_FAILURE_MODE}}

### Proof Test

**Test name:** {{PROOF_TEST_NAME}}

```
Given:
  {{PRECONDITION}}

When:
  {{OPERATION}}

Then:
  {{EXPECTED_OUTCOME}}
  {{DISTINGUISHING_CONDITION}}
```

This test targets {{BOUNDARY_DESCRIPTION}} and will fail if {{REGRESSION_DESCRIPTION}}.

---

## Engineering Review

<!--
RULES (STD-006 Section 8):
- Answer every question with rationale.
- State what was examined and what was found (or not found).
- Do not answer "yes, complete" without explaining what was checked.
- Any item found during this review must be incorporated into the
  relevant section before the delta is submitted for approval.
-->

### Is ADDED complete?

{{ADDED_COMPLETENESS_ANSWER}}

Items examined and excluded (with rationale): {{EXCLUDED_ITEMS}}

### Is MODIFIED complete?

{{MODIFIED_COMPLETENESS_ANSWER}}

For each ADDED item, confirmed a corresponding MODIFIED entry exists or
is not required: {{MODIFIED_COVERAGE_CONFIRMATION}}

### Is REMOVED honest?

{{REMOVED_HONESTY_ANSWER}}

Every R-N item verified against the approved specification: {{VERIFICATION_EVIDENCE}}

### Are backward compatibility guarantees missing?

{{BACKWARD_COMPAT_ANSWER}}

Consumer perspective review: {{CONSUMER_PERSPECTIVE_NOTES}}

### Would an implementation engineer understand exactly what changed?

{{IMPLEMENTATION_CLARITY_ANSWER}}

Self-contained check: {{SELF_CONTAINED_CONFIRMATION}}

---

## Verification Report

<!--
Complete this section last. Every row must be checked.
A blank row is a failing row.
-->

| Requirement | Status | Notes |
|---|---|---|
| Preserved Behaviour — exactly one sentence | {{PASS/FAIL}} | |
| Preserved Behaviour — observable and specific | {{PASS/FAIL}} | |
| ADDED — all items numbered | {{PASS/FAIL}} | |
| ADDED — no fabrications | {{PASS/FAIL}} | |
| MODIFIED — every item has Before and After | {{PASS/FAIL}} | |
| MODIFIED — no breaking changes disguised as modifications | {{PASS/FAIL}} | |
| REMOVED — common categories checked | {{PASS/FAIL}} | |
| REMOVED — no fabrications | {{PASS/FAIL}} | |
| REMOVED Audit — completion statement present | {{PASS/FAIL}} | |
| Risk Note — boundary condition targeted | {{PASS/FAIL}} | |
| Proof Test — Given/When/Then format | {{PASS/FAIL}} | |
| Engineering Review — all five questions answered with rationale | {{PASS/FAIL}} | |
| No {{PLACEHOLDER}} tokens remaining | {{PASS/FAIL}} | |

**Delta status:** {{READY FOR REVIEW / NOT READY — [N] items require attention}}
