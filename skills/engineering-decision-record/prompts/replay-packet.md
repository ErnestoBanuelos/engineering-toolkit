# Replay Packet — Prompts

This file contains production-ready prompts for producing a Replay Packet from an
engineering incident or high-risk AI-assisted session.

All prompts are technology-agnostic and domain-agnostic.

Before using any prompt, supply the required inputs listed under each prompt's **Inputs**
section. Replace all `[BRACKETED PLACEHOLDERS]` with the actual values for your context.

---

## Prompt 1 — Evidence Collection and Failure Classification

**Purpose:** Establish the observable record and classify the failure mode before
attempting to reconstruct the incident narrative.

**When to use:** Immediately after an incident is identified, while evidence is most
accessible. Run this prompt before constructing the action log.

**Why this order matters:** Starting with evidence collection prevents the failure
classification from being shaped by the narrative the team already believes. Collecting
what is observable first — and explicitly naming what is not observable — produces a
more honest and useful record.

**Inputs required before running this prompt:**

- Observable evidence: repository state, commit history, timestamps, tool outputs,
  prompt fragments, session notes, or any contemporaneous records available.
- Description of what outcome was expected vs. what actually occurred.

---

```
You are helping produce a Replay Packet for an engineering incident.

A Replay Packet is a structured record of what happened, built from observable evidence.
It is not a reconstruction from memory. It is not an inference about what probably
happened. It is a record of what can be confirmed from the available evidence.

---

## Available Evidence

[DESCRIBE ALL AVAILABLE EVIDENCE: repository state, commit diffs, timestamps, tool
output, prompt fragments, session notes, anything that is directly observable.]

## Expected vs. Actual Outcome

Expected: [WHAT SHOULD HAVE HAPPENED.]
Actual: [WHAT ACTUALLY HAPPENED.]

---

Your job is to produce two outputs:

### Output 1 — Evidence Inventory

Produce a structured list of all available evidence.

For each piece of evidence:
- Name the evidence (e.g., "git commit history", "session transcript fragment",
  "repository file diff").
- State what it confirms — the specific fact it establishes.
- State its limitation — what it does not confirm.

Then list all evidence that is unavailable or unrecoverable. For each gap, state
what information is missing and why it matters.

### Output 2 — Failure Mode Classification

Based only on the available evidence, classify the failure mode using exactly one
of the following categories:

- **Prompt ambiguity** — the prompt was interpreted differently than the engineer
  intended, and both interpretations were plausible from the prompt wording.
- **Artifact persistence gap** — content was generated correctly but not written to
  the repository because the prompt did not include an explicit persistence instruction.
- **Supervision gap** — an AI action was taken without the required human review or
  approval step.
- **Context gap** — the agent lacked information required to produce the correct output,
  and the information was not provided in the prompt or context.
- **Specification gap** — the specification was ambiguous or absent, and the agent
  resolved the ambiguity in a way that diverged from the engineer's intent.
- **Other** — if none of the above apply, describe the failure class precisely in one
  sentence.

Justify your classification using only the evidence from Output 1. Do not infer. If
the evidence is insufficient to classify with confidence, state that explicitly.
```

---

## Prompt 2 — Ordered Action Log

**Purpose:** Produce a chronological record of the observable steps in the incident
sequence.

**When to use:** After the evidence inventory and failure classification from Prompt 1
are complete.

**Inputs required before running this prompt:**

- The evidence inventory from Prompt 1.
- The failure mode classification from Prompt 1.
- Any additional context: the goal of the session, the tool and model used, the
  repository state before and after.

---

```
You are producing the ordered action log for a Replay Packet.

The action log is a chronological sequence of observable steps. Every step must be
supported by evidence. Steps that are not supported by evidence are omitted or
explicitly marked as inferred.

---

## Evidence Inventory

[PASTE THE EVIDENCE INVENTORY FROM PROMPT 1.]

## Failure Mode Classification

[PASTE THE FAILURE MODE CLASSIFICATION FROM PROMPT 1.]

## Session Context

Goal: [WHAT THE ENGINEER OR TEAM WAS TRYING TO ACCOMPLISH.]
Tool / agent: [THE AI TOOL OR ENGINEERING TOOL USED.]
Model: [IF KNOWN.]
Repository: [NAME AND BRANCH.]
Approximate date: [DATE OR DATE RANGE.]

---

Produce the ordered action log.

Format: A table with four columns.

| Step | Action | Evidence | Result |

Requirements:
- Every row describes one observable step — one thing that happened.
- The Action column states what the agent or engineer did. It does not state what
  they intended. It does not state what they were thinking.
- The Evidence column names the specific piece of evidence that confirms the step.
  Do not invent evidence. If a step is inferred rather than confirmed, mark it
  explicitly: "(inferred — not directly confirmed)".
- The Result column states what the step produced — the observable output or state
  change.

After the table, add a one-sentence summary of the point in the sequence where the
failure occurred (by step number) and what the observable signal was.
```

---

## Prompt 3 — Triage Note and Mitigation

**Purpose:** Produce the triage note: trigger, detection, correction, and mitigation.

**When to use:** After the action log is complete. The triage note is the most
actionable section of the packet — it is what prevents recurrence.

**Inputs required before running this prompt:**

- The ordered action log from Prompt 2.
- The failure mode classification from Prompt 1.
- Description of what was done to correct the immediate failure.

---

```
You are producing the triage note and mitigation for a Replay Packet.

The triage note names the specific conditions that caused the failure and the systemic
change that prevents recurrence.

---

## Ordered Action Log

[PASTE THE ACTION LOG FROM PROMPT 2.]

## Failure Mode Classification

[PASTE THE FAILURE MODE CLASSIFICATION FROM PROMPT 1.]

## Correction Applied

[DESCRIBE THE SPECIFIC ACTION TAKEN TO RESOLVE THE IMMEDIATE FAILURE.]

---

Produce the triage note with the following sections:

### Trigger

The specific input, prompt structure, or context condition that initiated the failure.
One to three sentences. Be precise — not "the prompt was unclear" but "the prompt
instructed the agent to [action] but did not include [specific missing element], which
caused the agent to interpret the request as [different action]."

### Detection

How the failure was identified:
- Human review
- Automated check
- Downstream impact
- Other (describe)

State what specifically triggered the detection — not just the method.

### Correction

The specific action taken to resolve the immediate failure. One to two sentences.
State the action concretely: what was done, by whom, and what the result was.

### Mitigation

The systemic change that prevents recurrence.

Requirements:
- State the mitigation as a specific engineering practice, not a general intention.
- The mitigation must describe a behavior change — something that is different in
  future sessions as a result of this incident.
- Avoid vague mitigations like "be more careful" or "review prompts more thoroughly."

### Packet Sufficient for Triage

State one of:
- "Yes — the available evidence is sufficient to confirm the failure mode, trigger,
  detection, correction, and mitigation."
- "Partial — [describe what is confirmed] but [describe what limitation prevents full
  triage]."
- "No — [describe the evidence gap that prevents triage]."
```

---

## Prompt 4 — Lessons Learned

**Purpose:** Extract engineering practice changes from the incident.

**When to use:** After the triage note is complete.

**Why a separate prompt:** Lessons learned require a shift in analytical posture. The
triage note answers "what happened." The lessons answer "what does this mean for how
we work." Keeping them separate prevents the triage note from being polluted with
recommendations, and prevents the lessons from being constrained by the specifics
of the incident narrative.

**Inputs required before running this prompt:**

- The complete incident record: evidence inventory, action log, triage note.
- Any related incidents or near-misses that share the same failure class.

---

```
You are extracting engineering lessons from a completed incident triage.

A lesson is a practice change — not a problem description.

"The agent did not write the file to disk" is a problem description.
"All prompts that expect file creation must include an explicit output path and a
persistence instruction" is a lesson.

---

## Incident Record

[PASTE THE EVIDENCE INVENTORY, ACTION LOG, AND TRIAGE NOTE.]

---

Produce 2–4 engineering lessons from this incident.

For each lesson:

### Lesson [N] — [Short title]

**Before this incident:**
[Describe the practice or assumption that existed before the incident. Be specific
about what the team did or relied on.]

**After this incident:**
[Describe the specific behavior change. State what engineers will do differently
in future sessions. Be concrete enough that a new team member could follow the
practice without asking for clarification.]

**Applies to:**
[State the scope: individual, team, organization, or a specific workflow or tool.]

---

Requirements:
- Do not produce lessons that are obvious restatements of the failure description.
- Do not produce lessons that require heroic effort to implement — prefer small,
  specific behavior changes that are immediately adoptable.
- If the incident exposes a gap in a related practice (e.g., a checklist that lacks
  a step), name the specific gap rather than recommending a general improvement.
- If this failure class has occurred before, note the pattern and produce a lesson
  that addresses the class, not just this instance.
```
