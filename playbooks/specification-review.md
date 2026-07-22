---
asset_id: PB-001
asset_type: Playbook
title: Specification Review Playbook
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-004
  - STD-005
  - ADR-007
  - ADR-009
related:
  - TPL-SPEC-002
  - WF-003
tags:
  - specification
  - review
  - playbook
  - audit
---

# Specification Review Playbook

## Purpose

This playbook guides a reviewer through the process of auditing an engineering feature
specification. It applies at Isolation Tier A (STD-004 Section 8.1): the reviewer has
not participated in authoring the specification.

The playbook is technology-agnostic. It applies regardless of the language, deployment
model, domain, or organisational context of the specification under review.

---

## Before You Begin

### Confirm your independence

Answer these questions before accepting the review assignment:

| Question | If yes |
|---|---|
| Did you author any section of this specification? | Declare this to the requester. This is Tier C (self-review), not Tier A. |
| Did you review a prior draft? | Declare this. This is Tier B, not Tier A. Tier A is preferred. |
| Do you have a strong opinion about how this capability should be implemented? | Acknowledge the bias. Set implementation opinions aside. Review only what is written. |
| Are you the approver for this specification? | Separate roles: reviewer and approver should be different people where possible. |

### Read the standard first

Before reading the specification, review:

- STD-004 Section 1 (Required Sections) — know what must be present.
- STD-004 Section 2 (Acceptance Criteria Rules) — know what correct ACs look like.
- STD-005 Section 1 (Measurement Rules) — know what measurable NFRs look like.

Do not rely on memory. The audit is only as rigorous as the standard it applies.

---

## 1. How to Review a Specification

### Phase 1 — First read (15–20 minutes)

Read the specification from start to finish without making notes. Your goal is to
understand the intended capability and form a first impression of completeness.

Ask yourself:
- Could I describe this capability to another engineer from what I just read?
- Is the purpose clear?
- Do the sections connect to each other logically?

Do not start making findings yet.

### Phase 2 — Structured review (section by section)

Go through each section with the question set in Section 2 of this playbook. For each
section, record every ambiguity, omission, and unimplementable statement.

An omission is a finding even if the omitted content is "obvious". Obvious content that
is not written cannot be verified. If an engineer must assume something in order to
implement the capability, that assumption must be made explicit in the specification.

### Phase 3 — Finding formulation

For each observation, formulate a precise finding. A finding must contain:

1. **What the specification says** (or does not say). Quote the text.
2. **Why it is a finding**. State what cannot be done, what is ambiguous, or what
   is missing.
3. **The impact**. What would happen if an engineer implemented the specification as
   written?

Then assign a severity:

| Severity | Definition |
|---|---|
| **High** | An engineer cannot implement a correct behaviour from the specification as written. They would make an incorrect assumption. |
| **Medium** | An engineer could implement a plausible behaviour, but different engineers would implement different behaviours. |
| **Low** | The specification is mostly clear but a minor detail is absent that would likely be noticed and corrected during implementation. |

### Phase 4 — Resolution assignment

For each finding, choose one of three resolutions:

| Resolution | When to use |
|---|---|
| **INCORPORATE** | The finding is valid. The specification must be updated before proceeding. |
| **REJECT** | The finding is invalid. The text is unambiguous, the concern does not apply, or the observation misread the specification. Document the rejection rationale. |
| **DEFER** | The finding is valid but requires a dependency, a decision, or an external input that is outside the scope of this specification. Record a gap entry. |

Do not reject a finding because fixing it would be difficult. Do not defer a finding
because it is inconvenient. The purpose of the audit is to surface problems, not to
minimise them.

### Phase 5 — Write the audit report

Complete the `audit.template.md` file. Complete the Verification Summary checklist.
Write the Audit Completion Statement.

---

## 2. Questions to Ask

Use these questions as a structured review guide. They are not exhaustive. Apply
professional engineering judgement throughout.

### Purpose

- Is the purpose stated in terms of observable behaviour, not implementation?
- Could an engineer use the purpose statement to determine whether a proposed
  implementation is correct or incorrect?
- Is the problem being solved clearly identified?

### Section 1 — Behaviour

- Is every accepted input type listed?
- Is the processing logic stated as ordered steps?
- Are steps unambiguous? Could two engineers independently arrive at the same
  implementation from each step?
- Is the output structure defined completely? Does it list every section and its content?
- Is there a clear indicator for when a section has no content?

### Acceptance Criteria

- Does each AC follow Given / When / Then exactly?
- Does each AC test exactly one behaviour?
- Are the ACs independent? Does evaluating AC-3 require the output of AC-1?
- Is the AC set complete? Does it cover:
  - The primary success case?
  - At least one boundary case?
  - At least one failure or error case?
  - At least one safety or constraint case?
- Is every "Then" clause observable? Can it be verified from the output alone, without
  inspecting internal state?
- Are there ACs that appear to test the same behaviour under different phrasings?

### Section 2 — Concurrency

- Is the stateful / stateless nature of the capability stated?
- Is the synchronous / asynchronous model stated?
- Are parallel invocation semantics stated?
- Is the maximum number of parallel inputs stated?
- Is race condition safety addressed?
- Is idempotency stated? Is the claim supported?

### Section 3 — Errors

- Is there an error catalogue?
- Does every required input have a missing-input or invalid-input error?
- Does every processing step have an error for its failure mode?
- Is the error format defined?
- Is degraded-mode behaviour described?
- Is degraded-mode output distinguishable from complete output?

### Section 4 — Boundaries

- Are inherited constraints listed with source citations?
- Is there an in-scope list?
- Is there an out-of-scope list?
- Is the out-of-scope list non-trivial? (An empty out-of-scope list is a warning sign.)
- Is every boundary condition implementable? Can an engineer write a test for each one?
- Are ownership boundaries stated for multi-team capabilities?

### Section 5 — Integrations

- Is every external system listed?
- Is the direction of each integration stated (incoming, outgoing, bidirectional)?
- Is the contract defined (fields, types, constraints)?
- Is the ordering stated (precedes, follows, concurrent)?
- Is the failure mode described for each integration?
- Are any integrations assumed to be bidirectional when they should be unidirectional?
- Are there circular integration dependencies with no defined ordering?

### Section 6 — NFR Budget

- Is the reference input size defined?
- Is every NFR target numeric?
- Does every metric have a named measurement method?
- Are any targets relative without a declared baseline?
- Is the error rate target specified for a defined time window?
- Are latency targets stated with a percentile (p50, p95, p99)?
- Are throughput targets sustained over a stated duration?
- Are cost targets above 120% of baseline for the hard cap?
- Are alert thresholds at or below 75% of the hard cap?
- Are resource consumption targets given for both steady-state and peak?
- Are deferred NFR items accompanied by an interim proxy?

---

## 3. Common Omissions

These omissions appear frequently in specifications. Check for each one explicitly.

| Omission | Where it hides | What to look for |
|---|---|---|
| Missing error catalogue | Section 3 | Errors described in prose but no table of codes |
| Empty out-of-scope list | Section 4 | Boundary section lists only in-scope items |
| Unevidenced inherited constraint | Section 4 | Constraint stated without a source citation |
| Unobservable Then clause | ACs | "The system processes the input correctly" |
| Missing concurrency answers | Section 2 | Questions answered with "N/A" without rationale |
| NFR targets without measurement methods | Section 6 | Numbers present but no procedure described |
| Implicit ordering in integrations | Section 5 | Two integrations with no stated ordering relationship |
| Missing degraded-mode description | Section 3 | No statement of what happens with partial input |
| Missing failure mode in an integration | Section 5 | Integration described without its failure behaviour |
| Duplicate ACs | ACs | Two ACs testing the same behaviour with different phrasing |

---

## 4. How to Challenge Assumptions

Specifications often contain hidden assumptions. Challenging them is the core activity
of a Tier A audit.

### Technique 1 — Implementation thought experiment

For each processing step, ask: "If I were implementing this step, what would I need to
know that is not written here?" Any answer that is not in the specification is a
potential finding.

### Technique 2 — Error path enumeration

For each processing step, ask: "What can go wrong here?" If the failure mode is not
in the error catalogue, that is a finding.

### Technique 3 — Boundary test

For each boundary condition, ask: "Can I write a test that would pass this condition?"
If the test cannot be written from the specification text alone, that is a finding.

### Technique 4 — Ownership test

For any component or data touched by the capability, ask: "Who owns this?" If the
answer is not in the specification, that is a potential finding.

### Technique 5 — NFR measurement test

For each NFR metric, ask: "Could I run the measurement right now and get a number?"
If the answer is no (because the tool is unspecified, the sample size is undefined, or
the input size is not stated), that is a finding.

### Technique 6 — The new engineer test

Imagine you are an engineer joining the team tomorrow. You have only this specification.
Could you implement the capability correctly? If you would ask a question before starting,
that question corresponds to a finding.

---

## 5. When to Reject a Finding

A finding is rejected when:

- The specification text is unambiguous and the finding misread it. Quote the text.
- The concern raised does not apply to this capability. Explain why.
- The finding describes implementation details that are outside the specification's scope.
  A specification defines behaviour, not implementation.

A finding is **not** rejected because:

- Fixing it would require rewriting a section.
- The answer is "obvious" to someone familiar with the domain.
- The author did not intend the ambiguity.

When rejecting a finding, document the rejection rationale in the audit report. A finding
with no rejection rationale is not rejected; it is ignored.

---

## 6. When to Defer a Finding

A finding is deferred when:

- The finding is valid but its resolution requires a decision that is outside the scope
  of this specification (e.g., choosing a tokeniser, selecting a measurement tool,
  deciding a resource limit).
- The finding requires a dependency or an external input that is not available at
  specification time.
- The finding is at the boundary of this capability and another capability that has
  not yet been specified.

A deferred finding **must** have:

- A gap entry added to the specification.
- The gap entry must describe what is needed to resolve the deferral.
- An interim proxy where one exists (something the team can measure with today).
- A named role responsible for resolution.

A finding is **not** deferred because:

- It is difficult to resolve.
- It would delay the specification.
- The author does not agree with it.

If the author disagrees with the finding, the options are REJECT (with documented rationale)
or INCORPORATE. DEFER is not a mechanism for avoiding a dispute.

---

## 7. When to Request Clarification

Request clarification from the author when:

- The specification contains a term or reference that is not defined within the
  specification and is not standard in the domain.
- The specification references an artefact or document that you do not have access to.
- You are unable to determine whether a section is complete or incomplete without
  context that is not in the specification.

Clarification is a one-way request: you ask, the author answers. If the clarification
reveals that the specification needs updating, the update goes into the specification,
not into informal communication. If it is in the specification, it can be reviewed.
If it is not in the specification, it cannot.

---

## 8. Engineering Review Questions

Use these questions to conduct a final self-challenge before submitting the audit report.

| Question | What you are checking |
|---|---|
| Is concurrency sufficiently specified? | Every concurrency question answered; idempotency claim supported; parallel limits stated |
| Are integration assumptions explicit? | Direction, contract, ordering, and failure mode stated for each integration |
| Can boundary conditions be implemented? | Every boundary condition is testable from the spec text alone |
| Is the NFR measurable? | Every metric has a numeric target, a named measurement method, and a reference input size |
| Would another engineer implement this without asking questions? | The new engineer test (Section 4, Technique 6) |
| Are there hidden implementation decisions? | Any design choice embedded in the spec that should be left to the implementer |
| Are any constraints asserted without evidence? | Every inherited constraint has a source citation |

---

## 9. Audit Report Completion Checklist

Before submitting the audit report, verify:

- [ ] Isolation tier declared.
- [ ] Every spec section examined (checked in Audit Scope).
- [ ] Minimum one finding produced.
- [ ] Every finding has an ID, section, severity, observation, resolution, and rationale.
- [ ] Every INCORPORATE finding includes a before/after spec update description.
- [ ] Every DEFER finding includes a gap entry description.
- [ ] Every REJECT finding includes a rejection rationale.
- [ ] Verification Summary checklist complete (all rows PASS or FAIL — no blanks).
- [ ] Audit Completion Statement written.

A checklist row left blank is the same as FAIL for the purpose of this audit.
