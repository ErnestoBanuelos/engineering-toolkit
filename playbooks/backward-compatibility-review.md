---
asset_id: PB-002
asset_type: Playbook
title: Backward Compatibility Review Playbook
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
  - TPL-BD-001
  - TPL-BD-002
  - WF-004
  - PB-001
tags:
  - brownfield
  - backward-compatibility
  - playbook
  - review
  - delta
---

# Backward Compatibility Review Playbook

## Purpose

This playbook guides an engineer through the process of performing a
Brownfield review: identifying what an approved specification currently
guarantees, discovering what a proposed change removes from those guarantees,
and challenging backward compatibility assumptions before the change is
approved.

The playbook applies to any system in any technology stack. It is
technology-independent. All techniques are applicable to specifications,
output contracts, and API definitions regardless of the programming language,
runtime, or deployment model.

---

## Before You Begin

### Confirm the baseline status

Before any review begins, confirm that:

| Check | Required |
|---|---|
| The specification being changed is in Approved or Active status | Yes — if not, use WF-003 |
| You have the version of the specification that was in effect when consumers built against it | Yes — change analysis against the wrong version produces incorrect removals |
| You understand what "consumer" means in this context | Yes — a consumer is any system, team, or capability that depends on this specification's output contract |

### Understand your role

This playbook applies to three distinct roles. Read only the sections that
apply to your role.

| Role | Sections |
|---|---|
| Delta author | All sections |
| Independent reviewer | Sections 3, 4, 5, 6 |
| Approver | Section 7 |

---

## 1. How to Perform a Brownfield Review

A Brownfield review proceeds in four phases.

### Phase 1 — Baseline catalogue (30–45 minutes)

Read the approved specification from start to finish without analysing the
proposed change. Build a catalogue of every caller-visible behaviour.

Use this structure for each catalogued behaviour:

```
Behaviour: <name>
Location:  <section and description in the specification>
Form:      <explicit (documented) / implicit (consumer assumption)>
Consumer test: <a test a consumer could write to verify this behaviour>
```

If you cannot write a consumer test for a behaviour, it is either not
caller-visible (and does not belong in the catalogue) or the specification
is underspecified (a finding in its own right).

### Phase 2 — Change analysis (30–45 minutes)

Read the change request. For each proposed change, categorise it:

```
Change: <description>
Type:   Addition / Modification / Removal
Impact on catalogue: <list the catalogue behaviours this change touches>
```

For additions, ask: "Does this addition require any catalogue behaviour to
change? Does it remove any catalogue guarantee?"

For modifications, ask: "After this modification, would a consumer whose code
was correct against the previous specification still produce correct results?"
If no, reclassify as Removal.

For removals, ask: "Is this explicit (the specification states it) or implicit
(a reasonable consumer assumption)?" Both require documentation.

### Phase 3 — Hidden removal search (20–30 minutes)

This is the most important phase. Apply each technique in Section 4 to find
removals that are not immediately obvious.

For each removal found:
- Add it to the REMOVED section of the delta.
- Note whether it is explicit or implicit.
- Note the category of removal (from STD-006 Section 5.2).

### Phase 4 — Risk assessment (15–20 minutes)

Identify the highest-risk preserved behaviour: the behaviour in the baseline
catalogue that the change brings closest to a potential regression.

The highest-risk behaviour is typically at the intersection of old and new
behaviour — shared trigger conditions, adjacent classification values, or
conditional relaxations of unconditional rules.

For the identified behaviour, define the proof test that would detect a
regression (see Section 5).

---

## 2. How to Identify Preserved Behaviour

A preserved behaviour is a caller-visible guarantee that exists before the
change and must exist after it.

### Identification technique

For each item in the baseline catalogue, ask:

1. "If this behaviour stopped being guaranteed, would any existing consumer
   break?" If yes, it is a preserved behaviour.

2. "Is this behaviour inside the scope of the proposed change?" If yes, it
   is preserved only if the change explicitly maintains it.

3. "Is this the most important preserved behaviour?" The preserved behaviour
   section of the delta contains exactly one sentence. Choose the behaviour
   whose regression would be most costly.

### Common mistakes when identifying preserved behaviour

| Mistake | Why it matters |
|---|---|
| Choosing a structural property rather than a testable output property | Structural properties can survive while observable behaviour changes; only testable output properties are verifiable |
| Choosing a behaviour that is obviously safe | The preserved behaviour statement should identify the highest-risk invariant, not the most comfortable one |
| Listing multiple preserved behaviours | Multiple preserved behaviours dilute responsibility; one sentence forces prioritisation |
| Identifying internal state as a preserved behaviour | Internal state is not caller-visible; consumers cannot test it |

---

## 3. How to Discover Hidden Removals

Hidden removals are the most dangerous category of delta error. A removal
that is not documented cannot be mitigated.

### Technique 1 — Enumeration ceiling test

For every enumeration in the approved specification (a fixed set of values:
status codes, classification levels, error codes, output types), ask:

"Does the change add a new value to this enumeration?"

If yes, the guarantee that "this enumeration contains exactly N values" no
longer exists. This is a removal.

Every consumer who implemented a switch/case, if/else chain, or parser with
exactly N branches will be affected.

### Technique 2 — Unconditional constraint relaxation test

For every constraint in the approved specification that is stated without
conditions (e.g., "always", "never", "at most", "exactly"), ask:

"Does the change make this constraint conditional?"

If yes, the unconditional guarantee no longer exists. This is a removal.

Example: "A report will always contain at most five items" → becomes
"A report will contain at most six items under condition X; at most five items
otherwise." The unconditional guarantee of five disappears.

### Technique 3 — Format stability test

For every output section or block in the approved specification, ask:

"Does the change add content to this section under any condition?"

If yes, the guarantee that "this section has this exact format" may no longer
hold. Any consumer performing exact-string matching on the section will break.

This technique is particularly important for output sections where consumers
parse the content programmatically.

### Technique 4 — Maximum value test

For every classification scheme (severity levels, priority ratings, risk
tiers), ask:

"Does the change add a value above the current maximum?"

If yes, the guarantee that "the current maximum is the ceiling" no longer
exists. Any consumer with a maximum-severity branch (e.g., "if severity ==
HIGH, escalate") may no longer receive the escalation it expects.

### Technique 5 — Consumer implementation thought experiment

Imagine you are an engineer who implemented a consumer of this capability
six months ago. You read the approved specification, built your implementation,
and shipped it.

Now you read the change request. Ask:

- "Which assumptions did I make when I built my implementation?"
- "Which of those assumptions is the change invalidating?"
- "Is each invalidated assumption documented in REMOVED?"

This technique reliably finds implicit removals that the specification never
stated explicitly but that any reasonable engineer would have assumed.

### Technique 6 — Acceptance criteria ceiling audit

For every acceptance criterion in the approved specification, ask:

"Does the change add a new acceptance criterion at a higher severity or in
a higher-stakes category than the existing ceiling?"

If yes, the guarantee that "the highest AC represents the most severe case"
no longer exists. Testing practices, risk assessments, and escalation
protocols built against the existing AC ceiling may be incomplete.

### Technique 7 — Integration contract audit

For every integration defined in the approved specification, ask:

"Does the change add any new required annotation, block, or field to the
output that an integrated system would need to process?"

If yes, the guarantee that "the output format of this integration is stable"
may no longer hold for integrated consumers.

---

## 4. How to Challenge Backward Compatibility Assumptions

Backward compatibility is often asserted rather than demonstrated. The
following challenges turn assertions into evidence.

### Challenge 1 — The parser test

Claim: "Existing consumers remain compatible."

Challenge: "Could an existing consumer implement a parser or matcher with
exactly the values defined in the approved specification? If so, does the
change add any value that the parser would not recognise?"

If the parser would reject or misclassify any new value, the change is not
backward compatible for parser-based consumers.

### Challenge 2 — The fixed-enumeration test

Claim: "The classification scheme is backward compatible."

Challenge: "How many values did the enumeration contain before? How many
does it contain after? Did any consumer reasonably build against exactly
the previous count?"

If consumers could have built against the previous count, the change removes
the fixed-count guarantee, which is a removal.

### Challenge 3 — The null annotation test

Claim: "The output format is backward compatible."

Challenge: "Was it previously guaranteed that a specific output section would
not contain any annotation? Does the change add an annotation to that section?"

If yes, the guarantee of annotation-free output no longer holds. Consumers
that match on format may break.

### Challenge 4 — The conditional cap test

Claim: "The escalation cap is backward compatible."

Challenge: "Was the cap previously stated as unconditional? Does the change
make it conditional?"

If yes, the unconditional guarantee disappears even if the conditional limit
is higher than the original cap.

### Challenge 5 — The severity inversion test

Claim: "Existing severity mappings are preserved."

Challenge: "Does any existing trigger condition now map to a different severity
value than it did before?"

This challenge applies specifically to changes that add trigger conditions near
existing ones, creating boundary conditions that can accidentally reassign an
existing case to the new severity.

---

## 5. How to Write Meaningful Risk Notes

A Risk Note that states "this behaviour might break" is not useful. A Risk Note
that identifies the specific implementation pattern that makes regression likely
is actionable.

### Structure of a meaningful Risk Note

**1. Name the preserved behaviour precisely.**

Use the exact output field, classification value, or constraint from the
approved specification. Do not describe structure or architecture.

**2. Explain the implementation proximity.**

Describe specifically why the change places implementation logic close to the
preserved behaviour. Common patterns:

- Shared trigger condition: "Both the new CRITICAL path and the existing HIGH
  path share the same [field] evaluation. An off-by-one or an incorrect
  ordering between the two branches could silently reclassify a HIGH case
  as CRITICAL."

- Conditional relaxation: "The new conditional cap shares the evaluation of
  [condition] with the existing unconditional logic. Incorrect evaluation of
  [condition] could cause the unconditional cap to be silently bypassed."

- Adjacent enumeration value: "The new value is immediately above [existing
  value] in the severity ordering. An incorrect sort order or comparison
  operator could cause [existing value] cases to be evaluated as [new value]."

**3. Define the specific failure mode.**

Not: "the behaviour might change."

Yes: "an implementation that evaluates the new branch before the preserved
branch in the classification logic could reclassify a [preserved case] as
[new case], making it invisible to consumers that do not handle [new case]."

**4. Write a boundary-targeted proof test.**

The proof test must exercise the boundary condition, not just demonstrate
the new behaviour's happy path.

The boundary condition is the input state where:
- A consumer of the preserved behaviour would expect the preserved output.
- A consumer of the new behaviour would not be affected.
- An incorrect implementation would produce the new output instead of
  the preserved output.

---

## 6. Common Engineering Mistakes

These mistakes appear frequently in Brownfield Deltas and backward
compatibility reviews. Check for each one explicitly.

### Mistake 1 — Incomplete REMOVED from "obvious" backward compatibility

Assumption: "Adding a new classification value can't break existing consumers;
they just ignore values they don't know about."

Reality: Consumers built against a fixed enumeration do not "ignore" new
values; they produce undefined behaviour (rejection, miscategorisation,
exception). The assumption of graceful ignorance is only valid if the consumer
was explicitly built with extensibility in mind. Most are not.

**Correction:** Document the enumeration-ceiling removal explicitly. Let the
consumer decide whether they are affected; do not decide for them.

---

### Mistake 2 — Treating implicit removals as non-removals

Assumption: "If the specification never explicitly guaranteed X, removing X
is not a removal."

Reality: A consumer can reasonably infer guarantees from the specification
as approved. If the specification's structure, examples, and constraints
consistently implied X, consumers may have built against X. The implied
guarantee is as real as the explicit one.

**Correction:** Apply the consumer implementation thought experiment (Section
3, Technique 5). If a reasonable engineer would have assumed X, document it.

---

### Mistake 3 — REMOVED Audit as a rubber stamp

Anti-pattern: The REMOVED Audit section states "REMOVED is complete" after
examining only the items already in REMOVED.

The REMOVED Audit is designed to find items that are not yet in REMOVED.
Auditing what is already there produces no new information.

**Correction:** Apply the audit to every item in ADDED and MODIFIED, and to
every category in STD-006 Section 5.2. Record findings for each.

---

### Mistake 4 — Preserved behaviour stated as structural invariance

Anti-pattern: "The existing three-tier classification model is preserved."

This is a structural assertion. It can survive while the observable output
changes. It cannot be tested by a consumer.

**Correction:** Restate as a testable output property. "All inputs that
previously produced LOW, MEDIUM, or HIGH risk level values continue to produce
the same risk level value after this change" is testable.

---

### Mistake 5 — Proof test covers only the new happy path

Anti-pattern: The proof test demonstrates that the new CRITICAL classification
is produced correctly.

This only tests ADDED. It does not test whether the preserved HIGH
classification still works correctly after the change.

**Correction:** The proof test must target the boundary: an input that the
specification assigns to the preserved behaviour (e.g., HIGH) but that an
incorrect implementation might assign to the new behaviour (e.g., CRITICAL).

---

### Mistake 6 — Conditional relaxation treated as a modification

Anti-pattern: "The escalation cap was five; it is now five or six depending on
condition X. This is a MODIFIED item."

This is partially correct. The conditional cap is MODIFIED. But the
unconditional guarantee of five is REMOVED. Both entries are required.
The MODIFIED entry covers the conditional behaviour. The REMOVED entry covers
the loss of the unconditional guarantee.

**Correction:** When a constraint changes from unconditional to conditional,
create one MODIFIED entry (describing the new conditional behaviour) and one
REMOVED entry (describing the loss of the unconditional guarantee).

---

### Mistake 7 — Delta written with implementation in mind

Anti-pattern: The author of the delta has already decided on an implementation
approach before writing the delta. The REMOVED section is influenced by which
removals the implementation handles gracefully.

A delta must describe what the specification removes from the consumer
contract, independent of how it will be implemented. Removals that the
implementation handles gracefully still exist as removals and must be
documented.

**Correction:** Write the delta before any implementation design. Derive the
delta entirely from the approved specification and the change request.

---

## 7. Approver Guidance

The approver is the final human gate before implementation begins. The
approver's responsibility is not to re-review the delta in detail (the
independent reviewer has done that), but to confirm that the governance
process was followed and that the delta is safe to implement.

### Approval checklist

| Check | Rationale |
|---|---|
| Independent reviewer is not the author | Delta self-review is not independent review |
| At least one reviewer finding was produced | A zero-finding review is evidence of insufficient rigour |
| REMOVED section contains at least two items, or their absence is explicitly justified | Most meaningful changes remove at least two implicit consumer assumptions |
| REMOVED Audit completion statement is present | The audit was performed, not just declared |
| Preserved Behaviour is one sentence stating a testable output property | The most important invariant is identified |
| Proof test targets the boundary between new and preserved behaviour | The highest-risk boundary is covered |
| Delta is in a state where an implementation engineer could begin work | No ambiguities, no missing sections |

### When to return for revision

Return the delta to the author when:

- REMOVED is empty or contains fewer items than expected for the scope of
  the change.
- The REMOVED Audit section is present but lacks examination evidence.
- The Preserved Behaviour is a structural assertion rather than a testable
  output property.
- The proof test does not target the boundary condition.
- Any reviewer finding was resolved with DEFER without a documented gap entry.

### When to reject a change request

The approver has authority to reject the change request itself (not just the
delta) when:

- The change is so significant that it constitutes a new capability. In this
  case, supersede the existing specification under WF-003 rather than amending
  it under WF-004.
- The change removes more existing guarantees than it adds new value. This is
  a judgment call requiring human authority; AI cannot make it.
- The change request is post-approval but reveals that the original
  specification contained a material error. Consider whether the specification
  should be re-reviewed rather than amended.
