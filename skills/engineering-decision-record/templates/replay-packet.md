# Replay Packet — Template

**Packet ID:** `REPLAY-[NNN]`
**Date:** YYYY-MM-DD
**Sensitivity:** `Internal` | `Restricted` | `Public`
**Status:** `Draft` | `Complete` | `Archived`

---

## Redactions Applied

> State explicitly whether any redactions were applied.
>
> If no redactions were required, write:
> "No redactions applied. No sensitive content was identified."
>
> If redactions were applied, describe each redaction:
> "Redacted: [description of what was removed and why]. Replacement: [REDACTED]."
>
> Delete these instructions before publishing.

---

## Task / Prompt

### Engineering Objective

> Describe the original engineering goal in 2–4 sentences. What was the engineer or team
> trying to accomplish?

### Prompt Intent

> Describe what the prompt was intended to instruct the agent to do. Focus on the
> engineer's intent, not the agent's behavior.
>
> If the exact prompt wording is available, quote it.
>
> If the exact prompt wording is unavailable, state that explicitly:
> "Exact prompt wording is not available. The following is a description of the observed
> intent based on [source of inference, e.g., commit message, session log]."
>
> Do not fabricate or reconstruct prompt wording.

---

## Context Snapshot

### Repository

**Name:** [Repository name]
**Branch:** [Branch name]
**Approximate state at time of incident:** [Describe what was present in the repository
at the time the incident occurred — relevant files, version, recent changes.]

### Relevant Engineering Artifacts

| Artifact | Path | Status at time of incident |
|---|---|---|
| [Specification] | [path] | Present / Absent / Unknown |
| [Session log] | [path] | Present / Absent / Unknown |
| [Other] | [path] | Present / Absent / Unknown |

### Limitations

> If any context was unavailable to the agent or is unavailable to the packet author,
> state each limitation explicitly:
> "The [artifact name] was not available to the agent during the incident session."
> "The [artifact name] was not preserved and cannot be recovered."
>
> Do not substitute inference for unavailable evidence.

---

## Tool and Agent Metadata

> Document only information that is actually known. Do not infer or estimate.

| Field | Value |
|---|---|
| Agent / tool | [Name of the AI assistant or engineering tool] |
| Model identifier | [Specific model name or version, if known] |
| Approximate execution date | [Date or date range] |
| Supervised mode | Yes / No / Unknown |
| Human-in-the-loop | Yes / No / Unknown |

_If a field is unknown, state "Unknown" rather than omitting the row._

---

## Ordered Action Log

> Produce a concise chronological sequence of observable steps.
>
> For each step:
> - State what the agent or engineer did (observable, not inferred).
> - State what evidence supports the observation.
> - State what result was produced.
>
> Do not include inferred reasoning. Do not include speculated chain of thought.
> If a step is not supported by observable evidence, omit it or mark it explicitly
> as inferred.

| Step | Action | Evidence | Result |
|---|---|---|---|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

_Add rows as needed._

---

## Output

### What Was Produced

> Describe the artifact or result that the session generated. Be specific about format,
> location, and completeness.

### Persistence Status

> State explicitly whether the output was persisted to the repository or existed only in
> the session.
>
> If the artifact was not persisted, state when the gap was detected and how.

---

## Triage Note

### Failure Mode

**Classification:** [Choose from: Prompt ambiguity / Artifact persistence gap /
Supervision gap / Context gap / Specification gap / Other — describe]

**Description:**
> One paragraph describing the specific failure mechanism. Not what went wrong in general
> — the specific condition that caused the specific failure.

### Trigger

> Describe the specific input, prompt structure, or context condition that initiated
> the failure.

### Detection

> How was the failure identified?
> - Human review
> - Automated check
> - Downstream impact
> - Other: [describe]

### Correction

> The specific action taken to resolve the immediate failure.

### Mitigation

> The systemic change adopted to prevent recurrence. State as a specific engineering
> practice, not a general intention.
>
> Good: "All prompts that expect file creation must include an explicit output path and
> a persistence instruction."
>
> Not useful: "Be more careful about prompts in the future."

### Packet Sufficient for Triage

`Yes` / `No` / `Partial — see limitations above`

> If Partial or No, describe what additional information would be needed to complete
> the triage.

---

## Lessons Learned

> For each lesson, state the engineering practice that changes as a result of this
> incident.
>
> Each lesson is a behavior change, not a problem description.
>
> Format:
> ### [Short lesson title]
> **Before this incident:** [What the team did or assumed before.]
> **After this incident:** [What the team does differently now.]
> **Applies to:** [Scope — individual / team / organization / specific workflow]

### Lesson 1 — [Title]

**Before this incident:**

**After this incident:**

**Applies to:**

---

### Lesson 2 — [Title]

**Before this incident:**

**After this incident:**

**Applies to:**

---

_Add lessons as needed. Remove unused sections._

---

## Related Artefacts

| Artefact | Path | Relationship |
|---|---|---|
| [ADR] | [path] | Architectural decision affected by or motivating this incident |
| [Architecture Debate] | [path] | Design decision debate related to the failure domain |
| [Specification] | [path] | Specification that was ambiguous or absent |
| [PR / Commit] | [path] | The corrective change |

---

## Summary

**Files created by the corrective action:**

| File | Path |
|---|---|
| [file name] | [relative path] |

**Directories created by the corrective action:**

| Directory | Path |
|---|---|
| [directory name] | [relative path] |

**Engineering practices updated because of this incident:**

1. [Practice 1]
2. [Practice 2]
3. [Practice 3]
