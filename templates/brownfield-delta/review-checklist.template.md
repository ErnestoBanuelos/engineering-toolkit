---
asset_id: TPL-BD-002
asset_type: Template
title: Brownfield Delta Review Checklist Template
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-006
  - ADR-007
  - ADR-009
related:
  - TPL-BD-000
  - TPL-BD-001
  - WF-004
  - PB-002
tags:
  - brownfield
  - delta
  - review
  - checklist
  - template
---

<!--
USAGE INSTRUCTIONS (remove this block before submitting the review)

This checklist is completed in two passes:

Pass 1 — Author self-review
  Complete before submitting the delta for independent review.
  The author must declare any items that are FAIL before submission.
  A delta with known FAIL items may be submitted if the FAIL is documented
  with a rationale; it may not be submitted with blank rows.

Pass 2 — Independent reviewer
  Completed by a reviewer who did not author the delta.
  The reviewer must apply Isolation Tier A (STD-006 Section 10):
  no benefit of the doubt is extended for omissions.

Both passes must be complete before the delta reaches Approved status.
-->

# Brownfield Delta Review Checklist

**Delta under review:** {{DELTA_FILE_PATH}}
**Baseline specification:** {{BASELINE_SPEC_PATH}} — version {{BASELINE_SPEC_VERSION}}
**Change title:** {{CHANGE_TITLE}}

---

## Part 1 — Author Self-Review

**Reviewer:** {{AUTHOR_NAME_OR_ROLE}}
**Date:** {{DATE}}
**Pass:** Author self-review (Pass 1)

### 1.1 Structural completeness

| Item | Status | Notes |
|---|---|---|
| Delta contains all required sections (Preserved Behaviour, ADDED, MODIFIED, REMOVED, REMOVED Audit, Risk Note, Proof Test, Engineering Review, Verification Report) | | |
| Sections appear in the required order | | |
| No `{{PLACEHOLDER}}` tokens remain in any section | | |
| Delta metadata header is complete (version, baseline reference, date, author role, requester) | | |

### 1.2 Preserved Behaviour

| Item | Status | Notes |
|---|---|---|
| Exactly one sentence | | |
| States a caller-visible, testable output property | | |
| Does not describe internal structure or architecture | | |
| Identifies the behaviour whose regression would be most costly | | |

### 1.3 ADDED

| Item | Status | Notes |
|---|---|---|
| Every newly introduced caller-visible behaviour is listed | | |
| No internal changes are included | | |
| Every item is individually numbered (A-1, A-2, ...) | | |
| No fabrications: every item is directly caused by this change | | |
| Completeness check applied: "Can a consumer encounter anything new not listed here?" | | |

### 1.4 MODIFIED

| Item | Status | Notes |
|---|---|---|
| Every behaviour that changes while remaining backward compatible is listed | | |
| Every item has a Before description | | |
| Every item has an After description | | |
| No breaking changes are classified as MODIFIED (those belong in REMOVED) | | |
| Every item in ADDED has a corresponding MODIFIED entry, or its absence is explained | | |

### 1.5 REMOVED

| Item | Status | Notes |
|---|---|---|
| At least one item is present (or absence is explicitly justified) | | |
| Maximum value assumption reviewed | | |
| N-level enumeration assumption reviewed | | |
| Unconditional constraint relaxation reviewed | | |
| Format stability guarantee reviewed | | |
| Acceptance criteria ceiling assumption reviewed | | |
| Consumer parser/matcher assumption reviewed | | |
| No fabricated removals | | |
| Every item describes a genuine caller-visible guarantee that disappears | | |

### 1.6 REMOVED Audit

| Item | Status | Notes |
|---|---|---|
| Every ADDED item examined for implicit removals | | |
| Every MODIFIED item examined for implicit removals | | |
| All six common removal categories reviewed with explicit notes | | |
| Completion statement present and uses the correct format | | |

### 1.7 Risk Note and Proof Test

| Item | Status | Notes |
|---|---|---|
| Highest-risk preserved behaviour identified | | |
| Risk explained in terms of a specific failure mode, not vague possibility | | |
| Proof test is in Given / When / Then format | | |
| Proof test targets the boundary between new and preserved behaviour | | |
| Proof test would distinguish a correct result from a regression | | |

### 1.8 Engineering Review

| Item | Status | Notes |
|---|---|---|
| All five required questions answered | | |
| Each answer includes examination rationale (not just "yes") | | |
| Items found during review were incorporated before submission | | |

**Author self-review result:** {{PASS / FAIL — [N] items require attention}}

**Author declaration:** I have completed Pass 1 of this checklist. All FAIL
items are documented with rationale in the Notes column above.

**Signature:** {{AUTHOR_NAME_OR_ROLE}} — {{DATE}}

---

## Part 2 — Independent Reviewer

<!--
Complete this section only if you are NOT the author of the delta.
Declare your independence before proceeding.
-->

**Reviewer:** {{REVIEWER_NAME_OR_ROLE}}
**Date:** {{DATE}}
**Pass:** Independent review (Pass 2)
**Isolation tier:** {{TIER_A / TIER_B}} (Tier A preferred — STD-006 Section 10)

### Independence declaration

| Question | Response |
|---|---|
| Did you author any part of this delta? | {{YES / NO}} |
| Did you review a prior draft of this delta? | {{YES / NO}} |
| Are you the approver for this delta? | {{YES / NO}} |

If you answered YES to the first question, you are not an independent reviewer
for this delta. Reassign.

### 2.1 Content challenge — Preserved Behaviour

| Challenge | Finding |
|---|---|
| Could a consumer write a test for this preserved behaviour from this sentence alone? | |
| Is this the most important preserved behaviour, or is there a more critical one? | |
| Does the preserved behaviour connect to the Risk Note? | |

### 2.2 Content challenge — ADDED

| Challenge | Finding |
|---|---|
| Read the change description. Is there anything new that a consumer could encounter that is not listed in ADDED? | |
| Are there any additions that appear to be out of scope for this change? | |

### 2.3 Content challenge — MODIFIED

| Challenge | Finding |
|---|---|
| For every ADDED item, is there a MODIFIED entry for the corresponding existing behaviour, or is its absence explained? | |
| Are there any MODIFIED items that actually break existing consumers and should be in REMOVED? | |

### 2.4 Content challenge — REMOVED

| Challenge | Finding |
|---|---|
| Imagine you are implementing a consumer of this capability. You built against the approved specification. Which of your assumptions does this change invalidate? Are all of them in REMOVED? | |
| Is the REMOVED section suspiciously short? (A meaningful change to a live contract typically removes at least two implicit consumer assumptions.) | |
| Is any item in REMOVED fabricated (has no basis in the approved specification)? | |

### 2.5 Content challenge — REMOVED Audit

| Challenge | Finding |
|---|---|
| Does the audit completion statement accurately reflect the state of REMOVED? | |
| Were any categories dismissed with insufficient examination? | |

### 2.6 Content challenge — Risk Note and Proof Test

| Challenge | Finding |
|---|---|
| Is the identified risk the highest-risk preserved behaviour, or is there a higher-risk one? | |
| Does the proof test target the boundary, or does it only test the happy path of the new behaviour? | |
| Could you execute this proof test today, from the spec and delta alone? | |

### 2.7 Content challenge — Engineering Review

| Challenge | Finding |
|---|---|
| Could an implementation engineer understand exactly what changed from this delta alone, without reading the original specification? | |
| Are any backward compatibility assumptions missing? | |

### 2.8 Independent reviewer summary

| Finding ID | Section | Severity | Observation | Recommendation |
|---|---|---|---|---|
| RF-1 | | | | |
| RF-2 | | | | |
<!-- Add rows as required. -->

**Minimum one finding required.**

An independent review that produces zero findings is evidence that the
review was not sufficiently rigorous. If the delta is genuinely complete,
record the most minor observation found. Do not submit a zero-finding review.

**Independent reviewer result:** {{PASS / FAIL — [N] findings require resolution}}

**Reviewer declaration:** I have completed Pass 2 of this checklist. My
findings are listed in Section 2.8.

**Signature:** {{REVIEWER_NAME_OR_ROLE}} — {{DATE}}

---

## Part 3 — Resolution Record

<!--
Completed by the delta author after independent review.
One row per reviewer finding.
-->

| Finding ID | Resolution | Spec update | Rationale |
|---|---|---|---|
| RF-1 | {{INCORPORATE / REJECT / DEFER}} | | |
| RF-2 | {{INCORPORATE / REJECT / DEFER}} | | |
<!-- Add rows as required. -->

**Delta status after resolution:** {{READY FOR APPROVAL / REQUIRES FURTHER WORK}}

---

## Part 4 — Approval Record

<!--
Completed by the named human approver.
The approver must not be the delta author.
-->

**Approver:** {{APPROVER_NAME_OR_ROLE}}
**Date:** {{DATE}}

| Approval check | Status |
|---|---|
| All INCORPORATE findings from Part 3 have been applied | |
| All REJECT findings have documented rationale | |
| All DEFER findings have a gap entry in the delta | |
| Preserved Behaviour is testable and specific | |
| REMOVED section is complete and honest | |
| Delta is implementation-ready | |

**Approval decision:** {{APPROVED / RETURNED FOR REVISION}}

**Conditions (if any):** {{CONDITIONS}}

**Approver signature:** {{APPROVER_NAME_OR_ROLE}} — {{DATE}}
