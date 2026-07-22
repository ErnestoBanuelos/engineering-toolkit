---
asset_id: WF-006
asset_type: Workflow
title: Supervised AI Implementation Session Workflow
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-008
  - STD-007
  - ADR-002
  - ADR-007
  - ADR-009
  - ADR-010
related:
  - TPL-SS-000
  - TPL-SS-001
  - TPL-SS-002
  - TPL-SS-003
  - PB-004
  - AUTO-004
  - WF-005
tags:
  - supervised-implementation
  - workflow
  - approval-workflow
  - session-log
  - verification-gates
---

# Supervised AI Implementation Session Workflow

## Purpose

This workflow defines the canonical sequence of stages for a supervised
AI-assisted implementation session. It takes a single approved task from an
approved task decomposition and delivers a verified, evidence-backed
implementation with a complete session log.

The workflow enforces the governance requirements of ADR-007 and the
supervision requirements of STD-008.

It is technology-agnostic. It applies to any implementation session —
regardless of language, deployment model, domain, team size, or AI tool —
where human accountability for every applied change is required.

---

## Workflow Overview

```
Approved Task (from task decomposition)
              ↓
    Stage 1 — Task Selection
              ↓
    Stage 2 — Context Loading
              ↓
    Stage 3 — Supervised Implementation
              ↓
    Stage 4 — 15-Minute Checkpoint
              ↓
    Stage 5 — Verification Gates
              ↓
    Stage 6 — Session Log
              ↓
    Stage 7 — Engineering Review
              ↓
    Stage 8 — Next Slice (or Session Close)
```

Each stage has defined inputs, outputs, quality gates, and deliverables.
A stage must not begin until all entry criteria for that stage are met.

---

## Stage 1 — Task Selection

### Purpose

Confirm which task is in scope for this session and establish the session
boundaries before any implementation activity begins.

### Entry criteria

- A task decomposition (tasks.md or equivalent) exists and has been reviewed.
- Exactly one task is selected for this session.
- The task is the FIRST SLICE or the next incomplete task in the dependency
  graph (all prerequisite tasks are complete).

### Inputs

| Input | Required | Source |
|---|---|---|
| Task decomposition | Yes | Project repository — tasks.md or equivalent |
| Task ID and title | Yes | Selected from task decomposition |
| Done checklist | Yes | Selected task's Done section |
| Interface contracts from prerequisite tasks | When applicable | tasks.md Seams section |

### Activities

1. Identify the FIRST SLICE or the next task whose dependencies are all
   satisfied.
2. Read the task's Input, Output, and Done sections in full.
3. Confirm the task's interface contract dependencies are frozen (prerequisite
   tasks are complete and accepted).
4. Confirm the task scope: what files and sections may be modified.
5. Confirm the stopping condition: the exact Done checklist items.

### Outputs

- A confirmed task selection: Task ID, Title, Done checklist, file scope.

### Quality gates

- [ ] Exactly one task is selected.
- [ ] All prerequisite tasks in the dependency graph are complete.
- [ ] The engineer has read the task specification in full.

---

## Stage 2 — Context Loading

### Purpose

Load all context required to implement the task before any proposal is made.
An agent that proposes without having read the required context is operating
on assumptions.

### Entry criteria

- Stage 1 complete: task selection confirmed.

### Inputs

| Input | Required | How to obtain |
|---|---|---|
| All files listed in the task's Input section | Yes | Read from repository |
| Specification sections referenced by the task | Yes | Read from repository |
| Interface contracts from upstream tasks | When applicable | Read from tasks.md seams |

### Activities

1. Read every file and section listed in the task's Input.
2. Identify the precise location (file, section, line range) of the proposed
   modification.
3. Confirm the modification location exists and is in the expected state.
4. Record all context-loading discoveries.

### Outputs

- Context Loaded table (for session log): file, purpose, status.
- Any key discoveries noted for the session log.

### Quality gates

- [ ] Every file in the task's Input section has been read.
- [ ] The modification target location has been confirmed to exist.
- [ ] Any missing context file is recorded as MISSING with impact noted.

---

## Stage 3 — Supervised Implementation

### Purpose

Apply the task's changes under supervision. Every proposed change is presented
to the engineer before being applied. No change is applied without an explicit
approval signal.

### Entry criteria

- Stage 2 complete: all context loaded.
- Engineer is available to evaluate proposals.

### Inputs

- Context loaded in Stage 2.
- Task Output specification.

### Activities

For each proposed change:

1. **Formulate** — determine the exact change required.
2. **Present** — show the engineer the full content of the proposed change,
   its file, its location, and the rationale.
3. **Wait** — do not apply the change. Wait for an explicit signal.
4. **Signal received:**
   - **Approve:** Apply the change, then verify (Step 5).
   - **Reject:** Record in session log. Propose an alternative or stop.
   - **Redirect:** Record in session log. Present revised proposal from Step 2.
   - **Approve with modifications:** Record both versions. Present modified
     version for a second explicit approval before applying.
5. **Verify** — read the modified file at the changed location. Confirm the
   change landed as proposed and no surrounding content was disturbed.
6. **Report** — confirm the verification result to the engineer before
   proceeding to the next change.

### Outputs

- Applied changes (in the repository).
- Ordered action log entries (for session log).
- Rejected alternative entries (for session log).

### Quality gates

- [ ] No change was applied without a recorded approval signal.
- [ ] Every applied change was verified by reading back the modified location.
- [ ] Every rejected or redirected proposal was recorded.
- [ ] No change was made outside the task scope.

---

## Stage 4 — 15-Minute Checkpoint

### Purpose

Provide a structured midpoint safety valve that allows the engineer to verify
session scope, confirm blockers are visible, and review all rejections so far.

### Entry criteria

- Stage 3 is approximately 50% complete (first major proposal applied and
  verified), or approximately half the estimated session time has elapsed.

### Inputs

- Action log accumulated to this point.
- Done checklist status.

### Activities

1. Generate the checkpoint using TPL-SS-002.
2. Populate all four sections: Done / Stuck / Discovered / Rejected.
3. Present the checkpoint to the engineer.
4. If the engineer identifies a scope problem, blocker, or unhandled rejection,
   pause Stage 3 until it is resolved.

### Outputs

- Checkpoint document (TPL-SS-002 populated): `sessions/<task-id>/checkpoint.md`

### Quality gates

- [ ] Checkpoint generated before Stage 3 is more than 75% complete.
- [ ] All four sections are populated (none omitted).
- [ ] Rejected section accurately reflects all rejections since session start.

---

## Stage 5 — Verification Gates

### Purpose

Verify every item on the Done checklist before declaring the session complete.
Verification is evidence-based, not assertion-based.

### Entry criteria

- Stage 3 complete (all proposed changes applied) or session has reached its
  stopping boundary.

### Inputs

- Done checklist from the task specification.
- Modified repository state.

### Activities

For each Done checklist item:

1. State the claim: what must be true for this item to pass.
2. Identify the evidence: the file, section, line, or content excerpt that
   confirms the claim.
3. Read the evidence.
4. Record: Claim / Evidence / Result (PASS or FAIL).

### Outputs

- Verification Gates section of the session log (TPL-SS-001).

### Quality gates

- [ ] Every Done checklist item has been evaluated.
- [ ] Every PASS result cites specific evidence.
- [ ] Any FAIL result is recorded with the gap described.

---

## Stage 6 — Session Log

### Purpose

Produce the complete session log that serves as the primary evidence artefact
for the session.

### Entry criteria

- Stages 1–5 complete.
- All verification gate results recorded.

### Inputs

- Context Loaded table (Stage 2).
- Ordered action log (Stage 3).
- Rejected alternatives (Stage 3).
- Verification gate results (Stage 5).
- Checkpoint (Stage 4).

### Activities

1. Populate the session log template (TPL-SS-001) with all accumulated content.
2. Complete the Outcome section: COMPLETE / PARTIAL / BLOCKED.
3. Complete the Next Step section.
4. Store at `sessions/<task-id>/session-log.md`.

### Outputs

- Session log: `sessions/<task-id>/session-log.md`
- Actions log (if used): `sessions/<task-id>/actions.jsonl`

### Quality gates

- [ ] All six required sections present: Task Specification, Context Loaded,
      Ordered Action Log, Rejected Alternatives, Verification Gates, Outcome.
- [ ] Outcome accurately reflects session result: COMPLETE / PARTIAL / BLOCKED.
- [ ] Next Step is populated.

---

## Stage 7 — Engineering Review

### Purpose

Provide a structured engineering review of the session's output before the
session is closed. This is the engineer's final opportunity to verify scope,
confirm no regressions, and confirm session evidence is complete.

### Entry criteria

- Stage 6 complete: session log produced.

### Inputs

- Session log.
- Original task specification (Done checklist and Output section).
- Repository state after all changes.

### Activities

The engineer evaluates:

1. **Scope compliance:** Do the applied changes stay within the task's
   defined scope? Were any out-of-scope changes applied?
2. **Verification completeness:** Does every Done checklist item have a PASS
   result with cited evidence?
3. **Rejection documentation:** Are all rejections and redirects documented
   accurately?
4. **Regression check:** Do the changes preserve all existing behaviour
   outside the task scope?
5. **Session log accuracy:** Does the session log accurately represent the
   sequence of events?

### Outputs

- Engineering review verdict: Accepted / Accepted with notes / Rejected
- Any required corrections to the session log.

### Quality gates

- [ ] All five review questions answered.
- [ ] Verdict is one of three named values: Accepted / Accepted with notes /
      Rejected.

---

## Stage 8 — Next Slice (or Session Close)

### Purpose

Transition from the completed session to the next unit of work, or close the
session cleanly if the task was the last in the decomposition.

### Entry criteria

- Stage 7 complete: engineering review accepted.

### Activities

**If more tasks remain:**
1. Identify the next task in the dependency graph whose prerequisites are
   now satisfied.
2. Confirm the interface contract from the completed task is frozen.
3. Note the next task's ID and title for the subsequent session.
4. Do not begin the next task in this session.

**If this was the last task:**
1. Confirm all tasks in the decomposition are complete.
2. Confirm the terminal assembly task (if present) has received its required
   human approval signal.
3. Close the session.

### Outputs

- Next task identified (if applicable).
- Session closure confirmation.

### Quality gates

- [ ] Next task is not started in this session without explicit engineer
      authorisation.
- [ ] If terminal task: approval gate is confirmed cleared before it begins.

---

## Partial Session Handling

If a session cannot complete the active task within the available time:

1. Identify the last successfully applied and verified change.
2. Record the stopping boundary precisely in the session log Outcome section.
3. Mark the session as PARTIAL.
4. The next session resumes from the stopping boundary, not from the beginning
   of the task.

A PARTIAL session is a valid outcome. An undefined stopping point is not.
