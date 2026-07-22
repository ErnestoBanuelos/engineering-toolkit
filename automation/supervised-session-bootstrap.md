---
id: AUTO-004
title: "Supervised Session Bootstrap — AI Workflow"
type: Automation
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: automation
tags: [supervised-implementation, ai-workflow, bootstrap, automation, approval-workflow]
depends_on: [STD-008, WF-006, TPL-SS-000, TPL-SS-001, TPL-SS-002, TPL-SS-003, PB-004]
related: [STD-007, WF-005, KR-K5D7]
supersedes: ""
superseded_by: ""
---

# AUTO-004 — Supervised Session Bootstrap

## 1. Purpose

This document describes a reusable AI-assisted workflow that starts a
supervised implementation session for a single approved task from a task
decomposition.

The workflow is designed for execution by an AI engineering assistant
operating with a project Context Bundle loaded. It prepares the session
environment, initiates the supervision protocol, and produces a first-draft
session log populated from the task specification — ready for the engineer
to supervise.

This automation does not replace the engineer's judgment. It accelerates
the session setup steps so that engineer effort is concentrated on proposal
evaluation, rejection documentation, and verification — the activities most
likely to produce value under time pressure.

**This automation never generates repository-specific content in the toolkit.**
All project-specific content lives in the consuming project and its Context
Bundle.

---

## 2. Scope

This automation applies to any project that:

- Contains a task decomposition (tasks.md or equivalent) at an approved or
  reviewed status.
- Has a project Context Bundle.
- Is implementing exactly one task under engineer supervision.

It produces session setup conforming to WF-006 (Stages 1–2) and populates
the session log template (TPL-SS-001) and checkpoint template (TPL-SS-002).

---

## 3. Prerequisites

Before invoking this automation, the engineer must provide:

| Input | Required | How to obtain |
|---|---|---|
| Task decomposition | Yes | The tasks.md or equivalent at its current version |
| Task ID to execute | Yes | Selected by the engineer before invocation |
| Project Context Bundle | Yes | The project's context documents |
| Session output path | Yes | Where the session artefacts will be stored |

**Human pre-read required:** The engineer must have read the task specification
in full before invoking this automation. The automation can process the task
specification, but the engineer's prior understanding is required to evaluate
proposals correctly.

**Prerequisite check:** Before proceeding, the engineer must confirm that all
tasks the selected task depends on are complete and accepted.

---

## 4. Engineering Assets Referenced

| Asset ID | Asset | Role |
|---|---|---|
| STD-008 | Supervised AI Implementation Standard | Governs the supervision protocol, approval workflow, and all session requirements |
| WF-006 | Supervised AI Implementation Session Workflow | Defines the stage-by-stage execution sequence this automation follows |
| TPL-SS-001 | Session Log Template | Output produced by this automation (populated from task input) |
| TPL-SS-002 | Checkpoint Template | Midpoint checkpoint structure this automation generates |
| TPL-SS-003 | Actions Template | Machine-readable action log (optional output) |
| PB-004 | Supervised AI Review Playbook | Reference for the engineer supervising the session |

---

## 5. Phases

The automation executes in four phases. Each phase produces output that the
engineer can inspect before the next phase begins.

### Phase 0 — Session Initialisation

**Agent prompt pattern:**

```
You are an AI engineering assistant operating in supervised mode.

Read the following files and confirm your understanding of the session scope
before making any proposal:

1. <<path to task decomposition>>
2. <<all files listed in the selected task's Input section>>
3. <<project Context Bundle or equivalent>>

After reading, produce:

A. A Context Loaded table: file | purpose | status (read / missing)
B. A one-paragraph statement of session scope:
   - Task ID and title
   - Files this session may modify
   - Files this session must not modify
   - Done checklist items (listed)
   - Session mode: SUPERVISED — every proposed modification requires
     explicit engineer approval before application

Do NOT propose any changes yet. Wait for engineer confirmation of scope.
```

**Engineer action:** Review the scope statement. Confirm or correct before
proceeding to Phase 1.

**Phase 0 outputs:**
- Context Loaded table
- Session scope statement

---

### Phase 1 — Task Specification Extraction

**Agent prompt pattern:**

```
The engineer has confirmed the session scope.

Now extract the task specification into the session log template at
<<session output path>>/session-log.md.

Populate the following sections from the task specification:
- Task Specification (Task ID, Title, Input, Output, Done checklist as
  unchecked items)
- Context Loaded (table from Phase 0)

Leave all other sections empty — use the placeholder text from the template.

Do NOT populate the Ordered Action Log, Rejected Alternatives, Verification
Gates, or Outcome sections yet.

After writing the file, read it back and confirm all placeholders that should
remain empty are still empty.
```

**Engineer action:** Review the populated session log. Confirm the task
specification is correctly extracted before proceeding.

**Phase 1 outputs:**
- `sessions/<<task-id>>/session-log.md` (partially populated: Task Spec
  and Context Loaded sections)

---

### Phase 2 — Supervised Implementation (iterative)

Phase 2 is the main implementation loop. It repeats until the task is
complete or the session reaches its stopping boundary.

**Iteration structure:**

```
For each change required by the task:

  STEP 1 — FORMULATE
  Agent: "I need to make the following change to satisfy [Done checklist item N]:
         File: <<file>>
         Location: <<section / line range>>
         Proposed change:

         <<full text of proposed change>>

         This satisfies [Done checklist item N] because: <<rationale>>

         Do you approve?"

  STEP 2 — WAIT
  Agent waits. Does not apply. Does not proceed.

  STEP 3 — ENGINEER SIGNALS
  [Approve / Reject / Redirect / Approve with modifications]

  STEP 4 (if Approved) — APPLY AND VERIFY
  Agent applies the change.
  Agent reads back the modified location.
  Agent: "Applied and verified. The change is at <<file:line>>.
          Surrounding content is undisturbed."

  STEP 4 (if Rejected or Redirected) — DOCUMENT AND REVISE
  Agent records: original proposal | decision | reason | outcome
  Agent proposes alternative or reports no viable alternative.
```

**Midpoint checkpoint trigger:**

When the session is approximately halfway complete (first major change
applied, or approximately half the estimated duration elapsed), the agent
generates the checkpoint automatically:

```
Agent: "Midpoint checkpoint:

  Done: <<list of applied changes>>
  Stuck: <<blockers or "Nothing blocking">>
  Discovered: <<unexpected findings or "No unexpected findings">>
  Rejected: <<all rejections/redirects since session start>>

Storing at <<session output path>>/checkpoint.md."
```

**Phase 2 outputs:**
- Applied changes (in the repository)
- Updated session log: Ordered Action Log section
- Checkpoint document: `sessions/<<task-id>>/checkpoint.md`

---

### Phase 3 — Verification and Closure

After all changes are applied (or the session reaches its stopping boundary):

**Agent prompt pattern:**

```
The implementation phase is complete (or has reached its stopping boundary).

Now run the verification gates against the Done checklist.

For each checklist item:
1. State the claim.
2. Read the relevant file location.
3. Cite the specific evidence.
4. Record: PASS or FAIL.

After all gates are run, produce the final session summary:

Summary
-------
Files Modified: <<list>>
Engineering Review: <<scope compliance, verification completeness, regression check>>
Verification Report: <<table of all Done checklist items with evidence>>
Final Assessment: <<COMPLETE / PARTIAL / BLOCKED — one paragraph>>

Then complete the remaining session log sections:
- Verification Gates Run (evidence for each item)
- Outcome (COMPLETE / PARTIAL / BLOCKED)
- Next Step
```

**Engineer action:** Review the verification report. Accept or request
corrections. Accept the session.

**Phase 3 outputs:**
- Completed verification gates in session log
- Completed Outcome section
- Final summary output

---

## 6. Action Log Format (TPL-SS-003)

If the consuming project uses the machine-readable action log, the agent
appends one JSONL record per action using the schema defined in TPL-SS-003.

Action types:

| Type | When emitted |
|---|---|
| `context_load` | Each file read during Phase 0 |
| `proposal` | Each proposed change presented to the engineer |
| `apply` | Each change applied after approval |
| `verify` | Each verification step performed |
| `checkpoint` | When the midpoint checkpoint is generated |
| `rejection` | Each rejected or redirected proposal |
| `gate` | Each Done checklist item evaluated |

---

## 7. Supervision Protocol Summary

The following rules are enforced throughout this automation. Any deviation
requires the engineer to stop the session and record the deviation.

| Rule | Source |
|---|---|
| No change is applied without an explicit engineer approval signal | STD-008 Section 1.1 |
| Every proposal shows full content before signalling | STD-008 Section 1.2 |
| Every rejection is documented: proposal / decision / reason / outcome | STD-008 Section 6 |
| Midpoint checkpoint is mandatory | STD-008 Section 5.1 |
| Verification requires evidence, not assertion | STD-008 Section 7.2 |
| Session covers exactly one task | STD-008 Section 8.3 |

---

## 8. Known Limitations

| Limitation | Impact | Mitigation |
|---|---|---|
| Agent cannot independently verify that a task's prerequisites are complete | Session may begin on a task whose dependencies are unresolved | Engineer confirms prerequisites in Phase 0 scope review |
| Agent cannot detect if a proposal would break downstream tasks not in the current session | Downstream regression may not be visible until the next session | Engineer applies the regression check in the engineering review (Phase 3) |
| Midpoint checkpoint timing is approximate | Checkpoint may be generated slightly before or after the true midpoint | Acceptable; the checkpoint's value is in its content, not its exact timing |
| Action log timestamps are null when the AI assistant does not expose a real-time clock | Tooling that requires timestamps must inject them post-session | Use the sequence field for ordering; treat timestamps as optional |

---

## 9. Variant — Fully Manual Mode

When no AI assistant is available, this automation can be executed manually:

1. The engineer reads all task inputs (Phase 0).
2. The engineer writes the change directly (Phase 1 and 2).
3. The engineer generates the checkpoint at the midpoint (Phase 2).
4. The engineer populates the session log and verification gates (Phase 3).

The session log format (TPL-SS-001) and checkpoint format (TPL-SS-002) are
unchanged. The supervision protocol (STD-008) applies identically.

The only difference is that the "agent proposes / engineer approves" loop
is replaced by "engineer proposes and approves." In this mode, the Rejected
Alternatives section documents alternatives the engineer considered and
discarded, not proposals from an AI agent.
