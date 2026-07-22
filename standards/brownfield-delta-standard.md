---
asset_id: STD-006
asset_type: Standard
title: Brownfield Delta Standard
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - ADR-000
  - ADR-002
  - ADR-003
  - ADR-007
  - ADR-009
related:
  - STD-004
  - TPL-BD-000
  - TPL-BD-001
  - TPL-BD-002
  - WF-004
  - PB-002
  - AUTO-002
tags:
  - brownfield
  - delta
  - change-management
  - backward-compatibility
  - specification
---

# Brownfield Delta Standard

## Purpose

This standard defines how engineering change deltas are produced, reviewed, and
approved when a previously approved specification is modified in a system that
already has dependent consumers or a running implementation.

A Brownfield Delta is the canonical artefact that answers the question:

> "What changes when this approved specification is amended, and what existing
> guarantees survive?"

The Brownfield Delta is not an implementation document. It does not describe
how to build the change. It describes what the change is, what it preserves,
what it adds, what it modifies, and — most critically — what it removes from
the existing contract.

The Brownfield Delta is the primary artefact that enables safe, reviewable
change governance in systems where breaking changes carry real cost.

**Related ADRs:** ADR-000 (Foundation Principles P4, P5, P7), ADR-002
(Engineering Asset Lifecycle), ADR-007 (Repository Governance),
ADR-009 (Evidence and Verification Model).

---

## 1. Scope

This standard applies to every change to an approved specification or
implemented capability that meets at least one of the following conditions:

| Condition | Rationale |
|---|---|
| The capability has dependent consumers (other systems, teams, or capabilities that rely on its output contract) | Consumer-breaking changes must be explicitly identified |
| The specification has Approved or Active status (ADR-002 lifecycle) | Approved specifications are contracts; amendments require governance |
| The change introduces, modifies, or removes a classification tier, output field, error code, or constraint | These are caller-visible changes whose impact must be reasoned about explicitly |
| The change was requested after specification sign-off | Post-approval changes have no prior safety net |

When none of the four conditions apply, a Delta is recommended but not
mandatory. The Brownfield Delta is always valuable; these conditions define
where it is required.

---

## 2. Preserved Behaviour Philosophy

The Preserved Behaviour section is the most important section of a Brownfield
Delta. It is also the most commonly written incorrectly.

### 2.1 Definition

A preserved behaviour is a caller-visible guarantee that existed before the
change and continues to exist after it.

"Caller-visible" means: a consumer of this capability's output could write a
test for it today, and that test would still pass after the change.

Internal implementation details are not preserved behaviours. Architecture
choices are not preserved behaviours. Team conventions are not preserved
behaviours.

### 2.2 Rules

**Rule PB-1 — One sentence.**

The Preserved Behaviour section contains exactly one sentence. It states the
single most important contract that the change must not break.

Choosing one sentence forces the author to identify the highest-priority
invariant rather than producing a list that dilutes responsibility.

**Rule PB-2 — Observable, not structural.**

The preserved behaviour must be statable as an observable output property.
It must not describe internal state, architecture, or implementation approach.

Correct: "All LOW, MEDIUM, and HIGH risk classifications continue to trigger
the same output format and recommendation set as defined in version 1.0."

Incorrect: "The existing three-tier classification model is preserved."

The first form can be tested. The second describes a structural property that
could survive while the observable behaviour changes.

**Rule PB-3 — Specific, not general.**

"Backward compatibility is maintained" is not a preserved behaviour statement.
Name the exact output field, contract, behaviour, or guarantee that is
preserved.

**Rule PB-4 — The risk subject.**

The Preserved Behaviour section becomes the subject of the Risk Note. Choose
the behaviour that represents the highest risk if it regresses, not the
behaviour that is easiest to state.

---

## 3. ADDED Section Rules

The ADDED section lists every newly introduced caller-visible behaviour.

### 3.1 What belongs in ADDED

Include every item that a consumer would encounter in the output, error
contract, or interface that did not exist before this change.

Common categories:

| Category | Examples |
|---|---|
| New classification values | New severity level, new status code, new verdict |
| New output fields or sections | New annotation, new report section, new sub-block |
| New error codes | New error triggered by new input conditions |
| New escalation requirements | Mandatory blocks, required roles, required annotations |
| New acceptance criteria | Behavioural coverage for the new additions |
| New NFR vocabulary | Classification values that automated checkers must accept |

### 3.2 Rules

**Rule A-1 — Caller-visible only.**

Do not include internal implementation changes in ADDED. If a consumer
cannot observe it in the output, it does not belong in ADDED.

**Rule A-2 — Each item numbered.**

Every addition is individually numbered (A-1, A-2, ...) to support review,
traceability, and cross-reference from MODIFIED and REMOVED.

**Rule A-3 — Completeness check.**

After drafting ADDED, apply the completeness check: re-read the proposed
change description and ask "what can a consumer now do or observe that they
could not do before?" Every answer belongs in ADDED.

**Rule A-4 — No fabrications.**

Do not include items in ADDED that are not directly caused by the change
request. Aspirational additions that are outside the scope of the change
request inflate the delta and introduce unreviewed scope.

---

## 4. MODIFIED Section Rules

The MODIFIED section describes every behaviour whose implementation changes
while remaining backward compatible with existing consumers.

### 4.1 What belongs in MODIFIED

Include every item where:

- the behaviour exists before and after the change; AND
- the implementation of that behaviour must be updated to accommodate the
  change; AND
- the existing consumer contract is preserved after the update.

Common categories:

| Category | Examples |
|---|---|
| Classification logic | An existing classification rule that must now co-exist with a new rule |
| Output schema | An existing output section that gains conditional content |
| Acceptance criteria coverage | An existing AC set that is extended by the change |
| Integration rules | An existing integration behaviour that gains a new condition |
| NFR targets | An existing measurable target whose threshold changes under specific conditions |
| Version and status | The specification version that must be incremented |

### 4.2 Rules

**Rule M-1 — Before and after.**

Every MODIFIED item must state the behaviour before the change and the
behaviour after the change. A reader must be able to understand exactly what
changed without reading the original specification.

**Rule M-2 — Backward compatible only.**

If the modification breaks an existing consumer, the behaviour belongs in
REMOVED, not MODIFIED. MODIFIED implies the existing consumer contract
is unchanged.

**Rule M-3 — Each item numbered.**

Every modification is individually numbered (M-1, M-2, ...).

**Rule M-4 — Challenge completeness.**

After drafting MODIFIED, apply the following completeness check: for every
item in ADDED, ask "does any existing behaviour need to change to accommodate
this addition?" Every answer that is not already in MODIFIED belongs there.

---

## 5. REMOVED Section Rules

The REMOVED section is the most difficult to produce correctly and the most
important to produce honestly.

### 5.1 Definition

A removed behaviour is a caller-visible guarantee that existed before the
change and does not exist after it.

The guarantee need not have been explicitly documented. An implicit guarantee
— a promise that consumers could reasonably have inferred from the specification
as approved — is as important as an explicit one.

### 5.2 Categories of common removals

Spend extra effort identifying removals in the following categories. These are
the categories where removals are most commonly missed.

**Maximum value assumptions.**

When the change adds a new tier, severity, or classification value, any
implicit guarantee that the previous maximum was the ceiling disappears. A
consumer that built a fixed enumeration against the previous maximum will break
silently unless this removal is stated.

**Three-level (or N-level) classification assumptions.**

If the specification previously defined exactly N values in an enumeration, a
consumer could build a parser, matcher, or switch statement with exactly N
branches. Adding a new value removes the guarantee that N branches is
sufficient.

**Unconditional constraints.**

If a constraint was previously stated without conditions (e.g., "the output
will always contain at most five items"), any conditional relaxation of that
constraint removes the unconditional guarantee.

**Format stability guarantees.**

If an output section previously had a predictable, fixed format, any addition
of conditional content removes the guarantee of format stability. A consumer
performing exact-string matching on that section will break.

**Acceptance criteria ceilings.**

If the change adds a higher-severity acceptance criterion, the guarantee that
the highest AC represents the most severe case no longer exists.

**Consumer assumptions.**

Consider the perspective of a consumer who implemented against the specification
as approved. What could they have assumed? Which of those assumptions are no
longer safe?

### 5.3 Rules

**Rule R-1 — Genuineness.**

Do not fabricate removals. A removal must correspond to a guarantee that
actually existed in the approved specification or could reasonably be inferred
from it. A speculative removal whose basis cannot be cited is not a genuine
removal and must not be included.

**Rule R-2 — Each item numbered.**

Every removal is individually numbered (R-1, R-2, ...).

**Rule R-3 — Caller-visible only.**

Internal implementation guarantees that consumers cannot observe are not
caller-visible removals. If no consumer can write a test that would have
passed before and now fails, it is not a REMOVED item.

**Rule R-4 — Implicit counts.**

The effort invested in the REMOVED section is inversely proportional to the
harm that will result if removals are missed. A REMOVED section with fewer
than two items should be challenged: most meaningful changes to a live
specification remove at least one implicit consumer assumption.

---

## 6. REMOVED Audit Methodology

The REMOVED Audit is a mandatory section of every Brownfield Delta. It is a
self-challenge that verifies the REMOVED section is complete and honest.

### 6.1 The audit question

The REMOVED Audit is structured around a single question, applied repeatedly:

> "What behaviour existed before this change that no longer exists after it?"

The question is applied once per category in Section 5.2, and once per item
in ADDED and MODIFIED.

### 6.2 Audit procedure

1. For each item in ADDED, ask: "Does adding this item remove any previous
   guarantee?" Examples: adding a new enumeration value removes the guarantee
   of a fixed-size enumeration; adding a mandatory block removes the guarantee
   of a maximum block count.

2. For each item in MODIFIED, ask: "Does this modification remove any previous
   guarantee from the original form?" Examples: a conditional relaxation of a
   previously unconditional constraint; a section whose format is no longer
   fixed.

3. For each category in Section 5.2, ask: "Does the REMOVED section contain
   an entry for this category?" If a category is not present, does the change
   genuinely not affect it? State explicitly if a category is not affected
   and why.

4. Consider the consumer perspective: read the approved specification as if
   you are a new engineer implementing a consumer. What would you assume?
   Which assumptions does the change invalidate?

### 6.3 Audit completion statement

The REMOVED Audit section must conclude with one of two statements:

- **Complete:** "REMOVED is complete. [N] genuine removals identified. No
  fabricated removals. Each removal describes a caller-visible guarantee
  that disappears as a direct consequence of this change."

- **Incomplete (with additional items):** "The initial REMOVED section was
  incomplete. [N] additional removals identified during the audit. REMOVED
  now contains [M] items. Each is a genuine caller-visible removal."

A REMOVED Audit that ends without a completion statement is an incomplete
audit.

---

## 7. Risk Note Guidance

The Risk Note section identifies the preserved behaviour that is most at risk
of regression as a result of the change, explains why it is at risk, and
defines a proof test that will demonstrate the risk does not materialise.

### 7.1 Identifying the highest-risk preserved behaviour

The highest-risk preserved behaviour is typically found at one of the following
intersections:

| Intersection | Why it is high-risk |
|---|---|
| Where the new behaviour and the old behaviour share a trigger condition | Implementation errors at shared boundaries often affect both paths |
| Where the change introduces a conditional relaxation of a previously unconditional rule | The condition boundary is an error-prone implementation detail |
| Where the new enumeration value is adjacent to an existing value in the classification order | Off-by-one errors in severity ordering are common |
| Where the change modifies an existing section's format only under specific conditions | Conditional format changes are invisible to consumers that do not encounter the new condition |

### 7.2 Explaining the risk

State specifically which implementation pattern makes this behaviour susceptible
to regression. Vague risk statements ("this behaviour might break") are not
useful. Precise risk statements ("adding a CRITICAL branch before the HIGH
branch in the classifier could short-circuit to CRITICAL on conditions that
the specification assigns to HIGH") enable targeted testing.

### 7.3 Proof test requirements

The proof test must:

- Be executable against the specification alone (no implementation required).
- Target the exact boundary condition where the preserved behaviour and the
  new behaviour share the closest implementation proximity.
- State expected inputs, expected outputs, and the conditions that would
  distinguish a correct result from a regression.
- Be expressible as a Given / When / Then acceptance criterion.

A proof test that covers the boundary between the new behaviour and the
preserved behaviour is always more valuable than a proof test that covers
only the new behaviour.

---

## 8. Engineering Review Expectations

Every Brownfield Delta must include an Engineering Review section that
self-challenges the delta's completeness and correctness before it is
submitted for approval.

### 8.1 Required challenge questions

Every Engineering Review must address the following questions:

| Question | What to check |
|---|---|
| Is ADDED complete? | Can a consumer encounter anything new that is not listed in ADDED? |
| Is MODIFIED complete? | Does every item in ADDED have a corresponding MODIFIED entry for any existing behaviour that must change to accommodate it? |
| Is REMOVED honest? | Does every item in REMOVED correspond to a genuine pre-existing guarantee? Is any genuine removal missing? |
| Are backward compatibility guarantees missing? | Is there any implicit consumer assumption — not explicitly documented in the approved specification — that the change invalidates? |
| Would an implementation engineer understand exactly what changed? | Could an engineer implement the change correctly from the delta alone, without reading the original specification? |

### 8.2 Answering the questions

For each question, the Engineering Review must:

- State the answer directly (yes or no, with rationale).
- Identify any items that were found and added as a result of the challenge.
- Identify any items that were considered and explicitly excluded, with the
  reason for exclusion.

A question answered "yes, complete" without any examination rationale is a
self-deception. State what was checked and why nothing was found.

### 8.3 Rejection of incomplete Engineering Reviews

An Engineering Review section that consists only of "yes, this is complete"
for each question fails this standard. The review must demonstrate effort.

---

## 9. Anti-Patterns

The following practices violate this standard and must be corrected before a
Brownfield Delta is approved.

| Anti-pattern | Description | Correction |
|---|---|---|
| Empty REMOVED section | REMOVED contains no items despite the change modifying a live contract | Apply the REMOVED Audit methodology (Section 6). Every meaningful change removes at least one implicit consumer assumption. |
| REMOVED Audit as rubber stamp | The audit section states "REMOVED is complete" without examining any category or consumer perspective | Re-conduct the audit using the six-step procedure in Section 6.2 |
| Fabricated removals | REMOVED contains items that have no basis in the approved specification | Remove them. Fabricated removals dilute genuine ones and mislead consumers. |
| MODIFIED used for breaking changes | A modification that breaks existing consumers is classified as MODIFIED instead of REMOVED | Reclassify as REMOVED. Breaking changes that are disguised as modifications are the most dangerous category of delta error. |
| Preserved Behaviour stated as structure | Preserved Behaviour describes an architectural pattern rather than a testable output property | Rewrite as a testable assertion about observable output. |
| Proof test that only covers the new path | The proof test demonstrates the new behaviour but does not exercise the boundary between new and preserved behaviours | Rewrite to target the exact boundary condition. |
| Engineering Review with no examination | The review answers "yes" to all questions without explaining what was examined | Describe what was checked, what was found, and what was excluded and why. |
| Delta written after implementation | The Brownfield Delta is produced to document a change that was already implemented | Stop. The delta must precede implementation. A retroactive delta is a documentation artefact, not a change governance artefact. |
| Consumer perspective missing | The REMOVED section considers only documented guarantees, not implicit consumer assumptions | Apply consumer-perspective audit (Section 6.2, step 4). |

---

## 10. Delta Lifecycle

Brownfield Deltas follow the Engineering Asset lifecycle defined in ADR-002.

| State | Trigger | Gate |
|---|---|---|
| Draft | Author begins writing | None |
| In Review | Author submits for review | Reviewer assigned who is independent of the change author |
| Reviewed | Engineering Review complete | All Engineering Review questions answered with examination rationale |
| Approved | Named human approver signs off | ADR-007 L3 governance; approver is not the author |
| Implementation Active | Implementation begins | Approved state required |
| Superseded | A replacement delta is approved | Reference to successor delta required |

A delta in Draft state must not govern implementation.

A delta in Approved state may not be materially changed without re-entering
the review cycle.

---

## 11. Relationship to Specification Standard (STD-004)

The Brownfield Delta Standard extends the Engineering Specification Standard
(STD-004) for the specific context of post-approval changes.

| Concern | STD-004 | STD-006 |
|---|---|---|
| New capability | Governed by STD-004 | Not applicable |
| Change to approved capability | Not addressed | Governed by STD-006 |
| Output contract analysis | Not required | Required (ADDED, MODIFIED, REMOVED) |
| Consumer impact analysis | Not required | Required (REMOVED, Consumer perspective audit) |
| Backward compatibility | Not addressed | Required (MODIFIED rules, anti-patterns) |
| Preserved behaviour statement | Not required | Required (exactly one sentence) |

When a change is so significant that it constitutes a new capability rather
than an amendment to an existing one, author a new specification under STD-004
and supersede the original. Use STD-006 only for amendments to existing
approved specifications.

---

## 12. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.5 kata execution |
