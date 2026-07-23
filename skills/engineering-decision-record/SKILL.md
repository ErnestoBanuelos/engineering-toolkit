---
id: SKILL-EDR-001
title: "Engineering Decision Record"
type: Skill
status: Approved
version: 1.0.0
created: 2026-07-23
updated: 2026-07-23
owner: ""
maintainer: ""
domain: review
tags:
  - architecture
  - decision
  - adr
  - debate
  - replay
  - traceability
  - post-mortem
  - engineering-practice
depends_on: []
related:
  - skills/adversarial-review
  - skills/pr-provenance
  - verification/independent-test
supersedes: ""
superseded_by: ""
---

# Skill — Engineering Decision Record

---

## Purpose

Produce an engineering record that survives the people who created it.

Engineering teams regularly face architectural forks: two or more technically credible
paths, each with different tradeoffs. The instinct is to make a decision, implement the
winner, and move on. The record of the decision — why the fork existed, what alternatives
were considered, what evidence governed the choice, and under what conditions the choice
should be revisited — is rarely preserved in a form that is useful to a future engineer
who was not present.

This Skill addresses that gap through two complementary artifacts:

**Architecture Debate** — A structured comparison of competing options evaluated against
explicit, pre-agreed criteria. It records not just what was chosen, but why the
alternatives were rejected in enough detail that a future engineer can challenge the
decision with new evidence.

**Replay Packet** — A structured post-incident record of a significant engineering failure
or a high-risk AI-assisted session. It captures the minimal context needed to understand
what happened, why it happened, and what systemic change prevents recurrence.

Together, these two artifacts complete the engineering decision lifecycle. The Architecture
Debate governs what gets built. The Replay Packet governs organizational learning when
something goes wrong or nearly wrong.

Neither artifact is a substitute for an ADR. Both are complementary to it.

---

## Why This Matters

### Rejected alternatives must remain legible

A decision that cannot be re-examined is a liability.

Engineering conditions change: latency requirements tighten, team size grows, a dependency
is deprecated, a constraint is lifted. The implementation that was correct in the original
context may not be correct in the new context.

When the reasoning behind the original decision has not been preserved — when only the
outcome is visible in the code — two things happen:

1. The team cannot distinguish a decision that should be revisited from an implementation
   that should not be changed.
2. Engineers who were not present for the original decision have no way to evaluate whether
   the original constraints still apply.

Recording rejected alternatives with their evaluation rationale transforms a point-in-time
decision into a reusable engineering record.

### Decisions need evidence, not preferences

A preference is a statement about what someone likes. A decision is a statement about what
the evidence supports.

The architecture debate discipline enforces this separation by requiring that decision
criteria be defined and agreed upon before options are evaluated. This prevents the common
failure mode where the criteria are implicitly shaped by the preferred option, which
produces agreement but not analysis.

Criteria defined before evaluation allow future engineers to determine whether the
original evidence still holds, and to apply the same criteria to new options.

### Replay packets accelerate organizational learning

Most engineering teams learn from incidents at the individual level. The engineer who
experienced the failure understands what happened. The team learns only what was captured
in a post-mortem document — which typically records symptoms, timelines, and action items,
but rarely records the systemic conditions that made the failure possible.

A Replay Packet is designed to accelerate learning at the team and organization level by
capturing the minimal context required to reproduce the engineering conditions that led
to the failure. This is not the same as reproducing the failure itself. It is capturing
the context so that:

- A team member who was not present can understand the full failure mode.
- The same class of failure can be recognized before it occurs in a future session.
- The corrective engineering practice can be applied prospectively rather than
  retrospectively.

AI-assisted engineering introduces a specific class of failure not well-served by
conventional post-mortem formats: the case where an AI assistant produced correct content
that was never persisted, where a prompt was ambiguous about what action was expected,
or where a supervision gap allowed an incorrect assumption to propagate. These failures
leave no error log. They leave no stack trace. The only evidence is the gap between what
was expected and what exists. Replay Packets are specifically designed for this class of
failure.

### Relationship to adjacent practices

| Practice | Relationship to this Skill |
|---|---|
| Architecture Decision Record (ADR) | An ADR records a decision. This Skill produces the debate and evidence that precede the ADR, and the replay record that follows an incident. Use both together. |
| PR Provenance | PR Provenance records the engineering process behind a change. Architecture Debate is an input to the PR Provenance evidence set when a decision was made during the change. |
| Independent Verification | Independent Verification validates that the implementation matches the specification. Architecture Debate validates that the specification reflects the best available decision. |
| Adversarial Review | Adversarial Review challenges the implementation. Architecture Debate challenges the design decision before implementation begins. Both are adversarial in posture; both are constructive in goal. |

---

## Scope

### When to use the Architecture Debate

Apply this Skill when:

- Two or more technically credible implementation paths exist and the choice has
  consequences that will not be easily reversed.
- A significant existing decision is being challenged and the team needs a structured
  evaluation of whether to change it.
- A proposal exists that has not been tested against its own failure modes.
- A decision must be made by a team that includes members with conflicting prior
  assumptions.

Do not use this Skill when:

- There is only one credible implementation path.
- The decision is easily reversible without significant cost or risk.
- The scope is limited to formatting, naming, or other stylistic choices.
- The decision is already governed by an in-force standard or policy.

### When to use the Replay Packet

Apply this Skill when:

- An engineering session produced incorrect, missing, or misplaced artifacts.
- An AI-assisted session diverged significantly from the expected outcome without
  a clear error signal.
- A prompt ambiguity caused the AI to perform a different action than intended.
- An incident occurred that would benefit from structured organizational learning
  beyond a timeline and action items.
- A near-miss occurred — a failure that was caught before it caused harm but that
  revealed a systemic weakness.

Do not use this Skill when:

- The failure was a routine bug caught by automated tests with no systemic implications.
- The full context of the session is already captured in existing engineering artefacts
  and no additional organizational learning is available.

---

## The Engineering Decision Lifecycle

This Skill covers the full lifecycle of a significant engineering decision:

```
1. IDENTIFY       — Recognize a real architectural fork with material tradeoffs
2. DEFINE         — Establish decision criteria before evaluating options
3. DEBATE         — Apply a structured defender/attacker evaluation
4. DECIDE         — Record the decision with full rationale and reversibility conditions
5. MONITOR        — Define measurable evidence that would trigger reversal
6. IMPLEMENT      — Execute the decision with evidence-backed engineering practices
7. CAPTURE        — Record significant failures or high-risk sessions in Replay Packets
8. INTEGRATE      — Feed lessons learned back into future decision criteria
```

Each step produces or consumes at least one traceable artefact.

---

## Inputs

### Architecture Debate

| Input | Required | Description |
|---|---|---|
| Problem statement | Yes | A specific technical question with a defined decision scope. Not a general exploration. |
| Option set | Yes | Two or more candidate solutions, each described at the level of detail needed to evaluate tradeoffs. |
| Decision criteria | Yes | An explicit, pre-agreed list of criteria with relative priority. Defined before evaluation begins. |
| Context bundle or relevant documentation | Recommended | Technical constraints, existing architecture documentation, operational requirements, performance data. |
| Stability requirements | Recommended | How long the decision is expected to hold; acceptable cost of reversal. |

### Replay Packet

| Input | Required | Description |
|---|---|---|
| Observable evidence | Yes | What can be confirmed from repository state, logs, or artifacts. No reconstructed or fabricated evidence. |
| Failure mode description | Yes | The class of failure: ambiguous prompt, missing artifact, supervision gap, incorrect assumption, etc. |
| Corrective action taken | Yes | The specific action that resolved the immediate failure. |
| Engineering context at time of incident | Recommended | Repository state, tool versions, prompt structure, supervision mode. |

---

## Preconditions

### Architecture Debate

1. A real decision must exist. The debate is not a retrospective justification for a
   decision already made.
2. Decision criteria must be defined before any option is evaluated. Criteria defined
   after evaluation are presumed to favor the preferred option.
3. At least one person on the debate must be willing to defend the strongest case for
   each option. The debate produces no value if every participant privately agrees from
   the start.

### Replay Packet

1. The failure or near-miss must be recent enough that the observable evidence is still
   accessible.
2. The packet documents what is observable. Where evidence is unavailable, the limitation
   is stated explicitly. No reconstruction or inference is substituted for evidence.
3. The packet is not a blame assignment. It is a systemic analysis.

---

## Procedure

### Phase 1 — Architecture Debate

#### Step 1 — Define the problem

Write a single problem statement that names:
- The specific technical decision that must be made.
- The scope boundary (what the decision governs; what it does not).
- The consequence of choosing incorrectly (what failure mode the decision is trying to
  prevent or what opportunity it is trying to capture).

A problem statement that is too broad produces a debate that is too abstract to resolve.
A problem statement that names the preferred solution is not a problem statement — it is
a recommendation seeking validation.

#### Step 2 — Establish decision criteria

List the criteria against which all options will be evaluated.

Requirements:
- Criteria must be defined before any option is evaluated.
- Each criterion must be independently observable — either measurable or demonstrable
  from evidence.
- Criteria must be ranked or weighted so that a tradeoff between criteria can be resolved
  deterministically.

Typical criterion categories include: correctness guarantees, operational complexity,
reversibility, latency characteristics, failure modes and blast radius, maintainability,
team capability alignment, and cost of change over time.

#### Step 3 — Characterize each option

For each candidate option, produce:
- A concise description of the approach.
- The strongest case in its favor (the defender position).
- The most credible failure modes (the attacker position).
- Evaluation against each criterion from Step 2.

The defender and attacker positions must be argued at the same level of specificity. A
strong defender position paired with a vague attacker position is not a debate — it is
advocacy.

#### Step 4 — Apply the structured debate

For each option, run the following sequence:

1. **Defender presents the strongest case.** What problem does this option solve better
   than any alternative? What evidence supports this claim?
2. **Attacker challenges the most critical assumption.** If this option fails in
   production, what is the most likely mechanism? What evidence would we have before the
   failure is visible to users?
3. **Defender responds to the challenge.** Is the attacker's concern addressable within
   the scope of this option, or does it represent a fundamental limitation?
4. **Record the exchange.** The exchange itself — not just the conclusion — is preserved
   in the debate record.

#### Step 5 — Apply criteria and reach a decision

Score each option against the defined criteria.

Document the resulting ranking and the rationale for the ranking.

If two options score equally on all criteria, this is evidence that the criteria are
incomplete or that the options are genuinely equivalent. Document this finding and the
additional criterion used to break the tie.

#### Step 6 — Record the decision and reversal conditions

Produce the Architecture Debate record using the template in
`templates/architecture-debate.md`.

Required elements:
- The chosen option and the rationale for the choice.
- The specific reason each rejected option was not chosen, stated in terms of the criteria.
- The reversal trigger: the specific observable evidence that would justify reopening
  the decision.
- The review date or event: when the decision should be explicitly re-evaluated regardless
  of whether the reversal trigger has been observed.

---

### Phase 2 — Replay Packet

#### Step 1 — Establish the observable record

Collect everything that is directly observable: repository state, commit history,
timestamps, tool outputs, prompt fragments if available, and any contemporaneous notes.

State explicitly what is observable and what is unavailable.

Do not reconstruct. Do not infer. If the original prompt is unavailable, state that
explicitly. If the session transcript was not preserved, state that explicitly.

The Replay Packet is more valuable when it is honestly incomplete than when it is
completely fabricated.

#### Step 2 — Classify the failure mode

Name the class of failure using specific vocabulary:

- **Prompt ambiguity** — the prompt was interpreted differently than the engineer intended
- **Artifact persistence gap** — content was generated but not written to disk
- **Supervision gap** — an AI action was taken without the required human approval
- **Context gap** — the agent lacked information required to produce the correct output
- **Specification gap** — the specification was ambiguous and the agent resolved the
  ambiguity incorrectly
- **Other** — if none of the above, describe the class precisely

#### Step 3 — Produce the ordered action log

Reconstruct the sequence of observable actions in chronological order.

For each step:
- State what happened (observable, not inferred).
- State what evidence supports the observation.
- State what result was produced.

Do not include inferred reasoning. Do not include inferred chain of thought. If a step
is not supported by observable evidence, it does not belong in the action log.

#### Step 4 — Triage the failure

Document:
- The trigger condition — the specific input or context that initiated the failure.
- How the failure was detected — human review, automated check, or downstream impact.
- The correction applied — the specific action that resolved the immediate failure.
- The mitigation adopted — the systemic change that prevents recurrence.

#### Step 5 — Extract engineering lessons

Identify the engineering practice change that this incident motivates.

A lesson learned is not a statement about what went wrong. It is a statement about what
engineering practice will be different as a result.

**Not a lesson learned:** "The agent did not write the file to disk."

**A lesson learned:** "All prompts that expect file creation must include an explicit
persistence instruction with an exact output path. Prompts that omit persistence
instructions are generation-only requests."

Produce the Replay Packet using the template in `templates/replay-packet.md`.

---

## Outputs

### Architecture Debate

| Output | Type | Description |
|---|---|---|
| Problem statement | Decision record | The scoped technical question the debate answers. |
| Decision criteria | Decision record | Pre-agreed evaluation criteria with relative priority. |
| Option evaluations | Decision record | Each option evaluated against all criteria with defender and attacker positions. |
| Structured debate exchange | Decision record | The defender/attacker exchange for each option. |
| Decision record | Decision record (ADR-009) | Chosen option, rationale, rejected alternative rationale, reversal conditions. |

### Replay Packet

| Output | Type | Description |
|---|---|---|
| Observable evidence record | Incident record | What happened, from observable evidence only. |
| Failure mode classification | Incident record | Named class of failure with specific trigger. |
| Ordered action log | Incident record | Chronological sequence of observable actions. |
| Triage note | Incident record | Trigger, detection, correction, and mitigation. |
| Engineering lessons | Engineering practice update | Specific practice changes motivated by the incident. |

---

## Validation

### Architecture Debate checklist

- [ ] Problem statement names a specific decision, not a general exploration.
- [ ] Decision criteria were defined before any option was evaluated.
- [ ] Every criterion is independently observable or measurable.
- [ ] Defender and attacker positions are argued at the same level of specificity.
- [ ] Every rejected option has a specific rejection rationale tied to the defined criteria.
- [ ] The chosen option has a stated reversal trigger — a specific observable condition,
      not a vague reassessment prompt.
- [ ] The debate record is committed to the repository before implementation begins.

### Replay Packet checklist

- [ ] Every claim in the action log is supported by observable evidence.
- [ ] Where evidence is unavailable, the limitation is explicitly stated.
- [ ] The failure mode is named using the vocabulary defined in Phase 2, Step 2.
- [ ] The triage note names a specific trigger, detection method, correction, and mitigation.
- [ ] At least one engineering lesson is stated as a practice change, not a problem
      description.
- [ ] Sensitivity classification is declared. If no redactions were required, that is
      stated explicitly.
- [ ] The packet is committed to the repository and referenced from the relevant ADR, PR,
      or session log.

---

## Limitations

- **This Skill does not make decisions.** It structures the process by which humans make
  decisions. The decision itself and the acceptance of its tradeoffs always belong to a
  named human.

- **Architecture Debate requires genuine alternatives.** If the team has already decided
  before the debate begins, the artifact produced is advocacy, not analysis. Future
  engineers reading the record will not be able to distinguish a genuine debate from a
  post-hoc justification unless the process was conducted honestly.

- **Replay Packets are bounded by observable evidence.** The packet documents what can be
  confirmed. It does not reconstruct sessions from memory or inference. A packet with
  honest gaps is more useful than a complete packet built from speculation.

- **Neither artifact is self-enforcing.** The Architecture Debate record prevents future
  decisions from ignoring prior context only if future engineers read it. The Replay Packet
  produces organizational learning only if the lessons are applied to future engineering
  practice changes. Publishing these artifacts is necessary but not sufficient.

---

## Human Decisions

The following decisions are outside the scope of this Skill and require explicit human
ownership:

| Decision | Why human ownership is required |
|---|---|
| Choosing between options at the conclusion of the debate | The Skill structures the evaluation. The choice belongs to a named engineering decision-maker. |
| Accepting the tradeoffs of the chosen option | Tradeoff acceptance is a risk decision. It cannot be delegated to a process. |
| Determining reversal conditions | The team decides what evidence level is sufficient to justify reopening a decision. |
| Classifying sensitivity of a Replay Packet | Whether information in the packet is sensitive requires human judgment. |
| Deciding whether a lesson learned requires a policy change | Elevating a lesson to a team or organization-level practice change requires engineering leadership review. |

---

## Best Practices

**Write the reversal trigger before you need it.**
The hardest part of an architecture decision is knowing when to reverse it. Teams that do
not define reversal conditions at decision time typically either hold on to a decision too
long (because there is no explicit signal to reconsider) or reverse it too quickly (because
the original rationale is not accessible). A reversal trigger written at decision time is
written by the people with the most context. Write it then.

**Ground every debate position in production-realistic evidence.**
An attacker position that says "this might be slow" is not a debate position. An attacker
position that says "this approach requires a full table scan on every request; at 10,000
requests per minute, the database CPU will saturate within the first hour of peak traffic"
is a debate position. The same standard of specificity applies to the defender position.

**Do not use Replay Packets to assign blame.**
The value of a Replay Packet is in the systemic lesson, not in identifying who made a
mistake. A packet that focuses on individual error produces defensiveness and prevents
honest disclosure. A packet that focuses on the systemic condition that made the error
possible produces engineering practice changes that benefit everyone.

**Commit both artifacts to the repository before moving on.**
An Architecture Debate record that exists only in someone's notes is not an engineering
record. A Replay Packet that was drafted but never published provides no organizational
learning. Commit the artifacts. Reference them from the relevant PR, ADR, or session log.
The five minutes this takes will compound in value over every future decision that the
record informs.

**Use the debate to discover assumptions, not to confirm them.**
The most valuable outcome of a structured debate is not the decision. It is the
uncovering of an assumption that everyone held but no one had examined. An assumption
that survives the debate is a confidence-building result. An assumption that the debate
disproves is an incident that was prevented.

---

## Common Mistakes

| Mistake | Consequence | Correction |
|---|---|---|
| Defining criteria after evaluating options | Criteria will reflect the preferred option; the debate is advocacy disguised as analysis | Criteria must be defined and agreed before any option is evaluated |
| Attacker position weaker than defender position | The rejected options appear weaker than they are; future engineers cannot evaluate whether the decision should be revisited | Argue both positions with the same level of specificity and evidence |
| No reversal trigger defined | The decision persists indefinitely; the team cannot tell when conditions have changed enough to justify reconsideration | Every decision record must name at least one observable reversal condition |
| Replay Packet reconstructs rather than observes | The packet contains inferences presented as facts; future engineers cannot distinguish evidence from speculation | State all gaps explicitly; document only what is directly observable |
| Lessons stated as problem descriptions | The lesson produces no practice change | Every lesson must name a specific engineering behavior that changes as a result |
| Debate conducted after implementation begins | The debate becomes justification; options that would require significant rework are implicitly discarded | Conduct the debate before design work begins |
