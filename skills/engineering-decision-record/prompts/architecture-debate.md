# Architecture Debate — Prompts

This file contains production-ready prompts for each phase of the Architecture Debate
process.

All prompts are technology-agnostic and domain-agnostic.

Before using any prompt, supply the required inputs listed under each prompt's **Inputs**
section. Replace all `[BRACKETED PLACEHOLDERS]` with the actual values for your context.

---

## Prompt 1 — Problem Statement and Criteria Definition

**Purpose:** Establish a well-scoped problem statement and define objective decision
criteria before any option is evaluated.

**When to use:** At the start of a debate, before any option descriptions or evaluations
are written.

**Why this step matters:** Criteria defined after evaluation are almost always
unconsciously shaped by the preferred option. This prompt forces the criteria to be
explicit and agreed upon first, which gives the debate its analytical value.

**Inputs required before running this prompt:**

- A description of the engineering situation requiring a decision.
- The constraints and requirements the decision must satisfy (performance, reliability,
  team capability, reversibility, operational complexity).
- The consequence of choosing incorrectly.

---

```
You are helping establish the foundation for a structured architecture debate.

This is not an evaluation session. You are producing inputs that will be used to
evaluate options fairly — before any option is evaluated.

---

## Engineering Situation

[DESCRIBE THE TECHNICAL SITUATION: what is being built or changed, what problem the
decision is trying to solve, and what constraints exist.]

## Consequence of a Wrong Decision

[DESCRIBE WHAT FAILURE LOOKS LIKE: what breaks, what the cost is, and how quickly
the failure would be visible.]

---

Your job is to produce two outputs:

### Output 1 — Problem Statement

Write a single problem statement that names:
1. The specific technical decision that must be made (one sentence).
2. The scope boundary — what the decision governs and what it does not.
3. The primary risk the decision is trying to mitigate.

The problem statement must not imply a preferred option.

### Output 2 — Decision Criteria

Produce a list of 4–6 criteria against which all options will be evaluated.

Requirements:
- Each criterion must be independently observable or measurable from evidence.
- Each criterion must be ranked as High, Medium, or Low priority.
- Criteria must cover the primary engineering concerns of this decision domain.
- Do not include criteria that are obviously satisfied by all options — include only
  criteria where options are likely to differ.

For each criterion, provide:
- A short name (2–4 words).
- A one-sentence description of what is being evaluated.
- The priority.

Do not evaluate any option yet. Output only the problem statement and criteria list.
```

---

## Prompt 2 — Option Characterization

**Purpose:** Produce a balanced characterization of each candidate option, including its
strongest case and its most credible failure modes.

**When to use:** After the problem statement and criteria have been agreed. Run this
prompt once for each option.

**Inputs required before running this prompt:**

- The agreed problem statement from Prompt 1.
- The agreed criteria list from Prompt 1.
- A description of the option being characterized.

---

```
You are characterizing a candidate option for a structured architecture debate.

The decision criteria have already been agreed. Your job is to characterize this option
honestly against those criteria — not to advocate for it or dismiss it.

---

## Problem Statement

[PASTE THE AGREED PROBLEM STATEMENT.]

## Decision Criteria

[PASTE THE AGREED CRITERIA LIST WITH PRIORITIES.]

## Option Being Characterized

Name: [OPTION NAME]

Description: [DESCRIBE THE TECHNICAL APPROACH IN ENOUGH DETAIL TO EVALUATE TRADEOFFS.]

---

Your job is to produce three outputs for this option:

### Output 1 — Strongest Case (Defender Position)

Write the most compelling argument in favor of this option.

Requirements:
- Ground the argument in evidence, not preference.
- State what this option solves better than any alternative.
- Be specific: name the mechanism, the property, or the measurable outcome that makes
  this option superior on its strongest criterion.

### Output 2 — Most Credible Failure Modes (Attacker Position)

Identify the most credible ways this option could fail in production.

Requirements:
- Name the specific assumption embedded in the defender position that would have to
  be wrong for the failure to occur.
- Describe the failure mechanism — not just the symptom, but the cause.
- State what evidence would be visible before the failure reaches users.
- Be at least as specific as the defender position.

### Output 3 — Criteria Evaluation

Score this option against each criterion on a scale of 1 (poor) to 5 (excellent).

For each criterion:
- Provide the score.
- Provide a one-sentence rationale that explains the score in terms of this option's
  specific properties.

Do not compare to other options at this stage. Evaluate this option on its own merits.
```

---

## Prompt 3 — Structured Debate Exchange

**Purpose:** Run the structured defender/attacker exchange for each option.

**When to use:** After all options have been characterized. Run this prompt once for
each option, with all characterizations available as context.

**Inputs required before running this prompt:**

- The agreed problem statement and criteria.
- The characterizations for all options (from Prompt 2).

---

```
You are facilitating a structured engineering debate. All options have been characterized.
Your job is to run the defender/attacker exchange for each option and produce a comparison
summary.

This is not a recommendation session. Do not produce a recommendation. Produce only the
exchange record and the comparison summary.

---

## Problem Statement

[PASTE THE AGREED PROBLEM STATEMENT.]

## Decision Criteria

[PASTE THE AGREED CRITERIA LIST.]

## All Option Characterizations

[PASTE ALL OPTION CHARACTERIZATIONS FROM PROMPT 2.]

---

For each option, produce the structured debate exchange:

### [Option Name] — Defender/Attacker Exchange

**Defender:** Summarize the strongest case for this option in 3–5 sentences. Ground in
evidence from the characterization. Do not repeat the full characterization — synthesize
the strongest argument.

**Attacker:** Identify the single most critical assumption in the defender's argument.
State the failure mode that follows if the assumption is wrong. State what evidence would
confirm or deny the assumption before deployment.

**Defender response:** Is the attacker's concern addressable within this option's scope?
If yes: describe the specific mitigation. If no: acknowledge the limitation explicitly.

---

After all exchanges are complete, produce:

### Comparison Summary Table

A table with one row per criterion and one column per option.
Enter each option's score from the characterization.
Identify the winner for each criterion.
Add a total row.

If two options have equal total scores, identify the criterion that should serve as
the tiebreaker and explain why.

Do not produce a recommendation. The comparison summary ends the analytical phase.
The decision belongs to the engineering team.
```

---

## Prompt 4 — Decision Record

**Purpose:** Produce the complete decision record after the debate has concluded and
the engineering team has made its choice.

**When to use:** After the engineering team has reviewed the debate exchange and reached
a decision. The human decision-maker supplies the chosen option; this prompt produces
the formal record.

**Inputs required before running this prompt:**

- The complete debate exchange and comparison summary from Prompt 3.
- The engineering team's chosen option (human-supplied).
- The rationale provided by the decision-maker.
- Any additional constraints or context the decision-maker wants reflected.

---

```
The engineering team has completed the architecture debate and made a decision.
Your job is to produce the formal decision record.

Do not second-guess the decision. Do not re-evaluate the options. Record the decision
with the rationale and evidence provided.

---

## Debate Exchange and Comparison Summary

[PASTE THE FULL DEBATE EXCHANGE AND COMPARISON SUMMARY FROM PROMPT 3.]

## Decision

Chosen option: [OPTION NAME — HUMAN-SUPPLIED]

Decision-maker's rationale: [PASTE THE RATIONALE PROVIDED BY THE DECISION-MAKER.]

---

Produce the following decision record sections:

### Decision

State the chosen option and summarize the rationale in 3–5 sentences, referencing
the specific criteria scores and debate exchange content that support the choice.

### Why Each Rejected Option Was Not Chosen

For each option that was not chosen, state the specific reason in terms of the defined
criteria. The rejection rationale must be specific enough that a future engineer can
determine whether the reason still applies under changed conditions.

### Reversal Conditions

Produce two reversal conditions:

1. A reversal trigger: a specific observable condition that would justify reopening
   this decision. Name a metric, a dependency event, a team-size threshold, or a failure
   mode being observed in production. Not a vague "if circumstances change."

2. A review date or event: a specific date or an observable event that should prompt
   explicit re-evaluation of this decision, regardless of whether the trigger has fired.

### Related Artifacts

List the files, specifications, ADRs, and other artefacts that should be referenced
alongside this decision record.
```
