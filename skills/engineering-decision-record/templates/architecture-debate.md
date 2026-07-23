# Architecture Debate — Template

**Decision ID:** `DEBATE-[NNN]`
**Date:** YYYY-MM-DD
**Status:** `Draft` | `Under Review` | `Decided` | `Superseded`
**Decision owner:** [Name or role of the person who owns this decision]
**Review date:** YYYY-MM-DD _(when to re-evaluate regardless of reversal trigger)_

---

## Problem Statement

> Write one paragraph. Name the specific technical decision that must be made, the scope
> boundary, and the consequence of choosing incorrectly.
>
> Delete this instruction before publishing.

---

## Decision Criteria

Criteria must be defined before any option is evaluated.

| # | Criterion | Description | Priority |
|---|---|---|---|
| C1 | [Criterion name] | [What is being evaluated and why it matters] | High / Medium / Low |
| C2 | | | |
| C3 | | | |
| C4 | | | |
| C5 | | | |

_Add rows as needed. Remove unused rows._

---

## Options

### Option A — [Name]

**Description:**
> Describe the approach at the level of detail needed to evaluate tradeoffs.

**Strongest case (Defender):**
> What problem does this option solve better than any alternative? What evidence supports
> this claim? Be specific.

**Most credible failure modes (Attacker):**
> If this option fails in production, what is the most likely mechanism? What would the
> blast radius be? What evidence would we have before the failure is visible to users?
> Be specific.

**Criteria evaluation:**

| Criterion | Score (1–5) | Rationale |
|---|---|---|
| C1 | | |
| C2 | | |
| C3 | | |
| C4 | | |
| C5 | | |

---

### Option B — [Name]

**Description:**
> Describe the approach.

**Strongest case (Defender):**
> What problem does this option solve better than any alternative? What evidence supports
> this claim?

**Most credible failure modes (Attacker):**
> Most credible failure mode with specific mechanism and evidence signals.

**Criteria evaluation:**

| Criterion | Score (1–5) | Rationale |
|---|---|---|
| C1 | | |
| C2 | | |
| C3 | | |
| C4 | | |
| C5 | | |

---

_Add Option C, Option D, etc., using the same structure. Remove unused option sections._

---

## Structured Debate

### Option A — Defender/Attacker Exchange

**Defender:** [Summarize the strongest case in 3–5 sentences. Ground in evidence, not
preference.]

**Attacker:** [Identify the single most critical assumption embedded in the defender
position. Describe the failure mode that follows if the assumption is wrong.]

**Defender response:** [Is the attacker's concern addressable within the option's scope,
or is it a fundamental limitation? If addressable, describe the specific mitigation.
If fundamental, acknowledge it.]

---

### Option B — Defender/Attacker Exchange

**Defender:**

**Attacker:**

**Defender response:**

---

_Add exchanges for additional options._

---

## Comparison Summary

| Criterion | Option A | Option B | Winner |
|---|---|---|---|
| C1 | [score] | [score] | |
| C2 | [score] | [score] | |
| C3 | [score] | [score] | |
| C4 | [score] | [score] | |
| C5 | [score] | [score] | |
| **Total** | | | |

_If scores are equal on all criteria, document the additional criterion used to break the
tie and why it was added._

---

## Decision

**Chosen option:** Option [A/B/C/...]

**Rationale:**
> Explain why the chosen option was selected in terms of the defined criteria. Reference
> specific criterion scores where relevant.

**Why Option [B] was not chosen:**
> State the specific reason in terms of the criteria. This must be specific enough that a
> future engineer can evaluate whether the reason still applies.

**Why Option [C] was not chosen:**
> [Repeat for each rejected option.]

---

## Reversal Conditions

**Reversal trigger:**
> Describe a specific observable condition that would justify reopening this decision.
> Not a vague "if circumstances change" — a concrete signal: a metric threshold, a
> dependency event, a team-size threshold, a failure mode being observed in production.

**Review date:**
> Date: YYYY-MM-DD — or event: [e.g., "at the point the team exceeds 10 engineers" or
> "when the upstream dependency reaches end-of-support"].

**Who must approve reversal:**
> [Named role or individual]

---

## Related Artefacts

| Artefact | Path | Relationship |
|---|---|---|
| [Specification] | [path] | Governs the implementation domain affected by this decision |
| [ADR] | [path] | Records the formal decision downstream of this debate |
| [Replay Packet] | [path] | Incident record if this decision was later involved in a failure |

---

## Change Log

| Date | Author | Change |
|---|---|---|
| YYYY-MM-DD | [Name or role] | Initial draft |
