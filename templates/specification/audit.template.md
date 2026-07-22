---
asset_id: TPL-SPEC-002
asset_type: Template
title: Specification Audit Template
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-004
  - ADR-007
  - ADR-009
related:
  - TPL-SPEC-000
  - TPL-SPEC-001
  - PB-001
tags:
  - specification
  - audit
  - template
  - review
---

<!--
USAGE
  This template is for the auditor — not the author.
  The auditor must not have participated in authoring the specification under review.
  Copy this file to the target repository before editing.
  Replace every {{PLACEHOLDER}} with audit-specific content.
  Do not modify this template in-place.
  Follow STD-004 Section 8 for audit requirements.
-->

# {{CAPABILITY_NAME}} — Specification Audit

**Spec under review:** `{{SPEC_FILE_PATH}}`  
**Spec version:** {{SPEC_VERSION}}  
**Audit version:** 1.0.0  
**Date:** {{DATE}}  
**Reviewer role:** {{REVIEWER_ROLE}}  
**Isolation tier:** {{ISOLATION_TIER}}

---

## Isolation Statement

<!--
  State which isolation tier applies and what it means for this audit.

  Tier A: The reviewer has not participated in authoring this specification prior to this
  audit. No benefit of the doubt is extended for omissions. Assumptions are not made.
  Every finding is grounded in the specification text.

  Tier B: The reviewer has read prior drafts but has not contributed text. State this
  explicitly. Declare any prior exposure to the specification.

  Tier C: Self-review. The reviewer is the author. Not acceptable for publication.
  Acceptable only for initial draft quality checks.

  Replace this comment block with a single declarative statement, e.g.:
  "This audit is conducted at Isolation Tier A. The reviewer has not authored, co-authored,
  or reviewed any draft of this specification prior to this audit."
-->

{{ISOLATION_STATEMENT}}

---

## Audit Scope

The following sections were examined:

- [ ] Purpose
- [ ] 1. Behaviour (including acceptance criteria)
- [ ] 2. Concurrency
- [ ] 3. Errors
- [ ] 4. Boundaries
- [ ] 5. Integrations
- [ ] 6. NFR Budget

---

## Finding {{FINDING_1_ID}}

**ID:** {{FINDING_1_ID}}  
**Section:** {{FINDING_1_SECTION}}  
**Severity:** {{HIGH_MEDIUM_LOW}}  
**Finding title:** {{FINDING_1_TITLE}}

**Observation:**

<!--
  State what the specification says (or omits).
  Quote the relevant text directly.
  State why it is a finding: what cannot be implemented, what is ambiguous, what is missing.
  Be specific. "This is unclear" is not a finding. "An engineer cannot implement this
  because X is not defined" is a finding.
-->

{{FINDING_1_OBSERVATION}}

**Resolution chosen:** {{INCORPORATE_REJECT_DEFER}}

**Rationale for resolution:**

<!--
  Explain why this resolution was chosen.
  INCORPORATE: the finding is valid and the spec must be updated.
  REJECT: the finding is invalid. State why: the text is unambiguous, the concern is
          not applicable, or the observation misread the spec.
  DEFER: the finding is valid but outside scope or requires a dependency to resolve.
         Add a gap entry to the spec.
-->

{{FINDING_1_RATIONALE}}

**Spec update applied:**

<!--
  If INCORPORATE: describe the change made to the specification.
    Before: [the original text]
    After:  [the replacement text]
  If REJECT: state "No spec update. Finding rejected."
  If DEFER: state the gap entry added to the specification.
-->

{{FINDING_1_SPEC_UPDATE}}

---

## Finding {{FINDING_2_ID}}

**ID:** {{FINDING_2_ID}}  
**Section:** {{FINDING_2_SECTION}}  
**Severity:** {{HIGH_MEDIUM_LOW}}  
**Finding title:** {{FINDING_2_TITLE}}

**Observation:**

{{FINDING_2_OBSERVATION}}

**Resolution chosen:** {{INCORPORATE_REJECT_DEFER}}

**Rationale for resolution:**

{{FINDING_2_RATIONALE}}

**Spec update applied:**

{{FINDING_2_SPEC_UPDATE}}

---

## Finding {{FINDING_3_ID}}

**ID:** {{FINDING_3_ID}}  
**Section:** {{FINDING_3_SECTION}}  
**Severity:** {{HIGH_MEDIUM_LOW}}  
**Finding title:** {{FINDING_3_TITLE}}

**Observation:**

{{FINDING_3_OBSERVATION}}

**Resolution chosen:** {{INCORPORATE_REJECT_DEFER}}

**Rationale for resolution:**

{{FINDING_3_RATIONALE}}

**Spec update applied:**

{{FINDING_3_SPEC_UPDATE}}

<!--
  Add additional Finding sections as needed.
  A minimum of one finding is required per audit (STD-004 Section 8.2).
  An audit with zero findings is a signal that the review was not rigorous.
-->

---

## Audit Summary Table

| Finding ID | Section | Severity | Title (abbreviated) | Resolution |
|---|---|---|---|---|
| {{FINDING_1_ID}} | {{FINDING_1_SECTION}} | {{HIGH_MEDIUM_LOW}} | {{FINDING_1_TITLE_SHORT}} | {{INCORPORATE_REJECT_DEFER}} |
| {{FINDING_2_ID}} | {{FINDING_2_SECTION}} | {{HIGH_MEDIUM_LOW}} | {{FINDING_2_TITLE_SHORT}} | {{INCORPORATE_REJECT_DEFER}} |
| {{FINDING_3_ID}} | {{FINDING_3_SECTION}} | {{HIGH_MEDIUM_LOW}} | {{FINDING_3_TITLE_SHORT}} | {{INCORPORATE_REJECT_DEFER}} |

---

## Spec Update Record

<!--
  For every INCORPORATE resolution, document the change made to the specification.
  This record is the evidence that the spec was updated as a result of this audit.
  If no updates were made (all findings REJECTED or DEFERRED), state that explicitly.
-->

### Change 1 — {{FINDING_ID}} INCORPORATED

**Location:** {{SPEC_SECTION}}

**Before:**

> {{BEFORE_TEXT}}

**After:**

> {{AFTER_TEXT}}

<!--
  Add Change N sections as needed for each INCORPORATED finding.
-->

---

## Verification Summary

| Check | Result |
|---|---|
| All mandatory spec sections present | {{PASS_FAIL}} |
| All ACs follow Given / When / Then | {{PASS_FAIL}} |
| Minimum 4 ACs present | {{PASS_FAIL}} |
| ACs are independent | {{PASS_FAIL}} |
| All Then clauses are observable | {{PASS_FAIL}} |
| Concurrency questions answered | {{PASS_FAIL}} |
| Error catalogue complete | {{PASS_FAIL}} |
| Error format defined | {{PASS_FAIL}} |
| Boundary out-of-scope list present | {{PASS_FAIL}} |
| All inherited constraints cited | {{PASS_FAIL}} |
| All integrations have direction, contract, ordering, failure mode | {{PASS_FAIL}} |
| All NFR targets are numeric | {{PASS_FAIL}} |
| All NFR metrics have named measurement methods | {{PASS_FAIL}} |
| Reference input size defined | {{PASS_FAIL}} |
| Minimum 1 finding produced | {{PASS_FAIL}} |
| All INCORPORATE resolutions applied to spec | {{PASS_FAIL}} |
| All DEFER resolutions have gap entries in spec | {{PASS_FAIL}} |

---

## Audit Completion Statement

<!--
  A single paragraph summarising:
  - How many findings were produced.
  - Which resolutions were applied.
  - Whether the specification is cleared for the next stage (Engineering Approval)
    or requires further revision.
-->

{{AUDIT_COMPLETION_STATEMENT}}
