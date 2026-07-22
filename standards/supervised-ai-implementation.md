---
asset_id: STD-008
asset_type: Standard
title: Supervised AI Implementation Standard
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
  - ADR-010
  - STD-007
related:
  - TPL-SS-000
  - TPL-SS-001
  - TPL-SS-002
  - TPL-SS-003
  - WF-006
  - PB-004
  - AUTO-004
tags:
  - supervised-implementation
  - ai-assisted-engineering
  - approval-workflow
  - verification-gates
  - session-log
  - checkpoint
  - human-accountability
---

# Supervised AI Implementation Standard

## Purpose

This standard defines how AI-assisted implementation sessions are conducted
when every proposed modification requires explicit engineer approval before
being applied.

A supervised implementation session is the appropriate execution mode when:

- The change being implemented has been reviewed and approved in specification
  form but has not yet been implemented.
- The risk level of the change warrants that no code or document modification
  is applied without an explicit human decision.
- The organisation requires a traceable record of every proposal, every
  approval, and every rejection.
- The session produces evidence that satisfies an independent engineering
  review.

This standard is technology-agnostic. It applies to any implementation
session — regardless of language, platform, domain, team size, or AI tool —
where human accountability for every applied change is required.

**Related ADRs:** ADR-000 P6 (Human Accountability), ADR-007 (Repository
Governance), ADR-009 (Evidence and Verification Model), ADR-010 (Execution
Architecture).

---

## 1. Supervision Philosophy

### 1.1 The Engineer Decides; the Agent Proposes

In a supervised session, the AI agent proposes. The engineer decides.

Every modification to the repository — every file change, insertion, deletion,
or structural decision — requires an explicit approval signal from the engineer
before the agent applies it.

The agent never applies changes speculatively. It never interprets silence as
consent. It never proceeds on a prior approval for a different change.

### 1.2 Proposals Are Visible Before They Are Applied

The agent presents the full content of every proposed change before asking
for approval. The engineer reads the change, evaluates it, and signals one of
three outcomes: Approve / Reject / Redirect.

A change summarised without its full content is not a visible proposal. The
standard of "visible" means the engineer has enough information to evaluate
the change independently, without reading additional context.

### 1.3 Rejected and Redirected Proposals Are Evidence

A rejection or redirect is not a failure. It is evidence of effective
supervision. The session log must record every rejected and redirected
proposal, the reason given, and the alternative taken.

A session log with zero rejections is not evidence of a smooth session. It
may be evidence of insufficient scrutiny.

### 1.4 Human Accountability Is Non-Negotiable

No approval gate may be removed from a supervised session. No "auto-approve"
mode exists within this standard. The purpose of supervision is to preserve
human accountability at every modification boundary.

---

## 2. Engineer Responsibilities

Before the session:

- Read the approved task specification in full before the session begins.
- Confirm the task boundaries: what the session may implement and what it
  must not implement.
- Confirm the stopping condition: the exact Done checklist that defines
  task completion.

During the session:

- Evaluate every proposal on its merits — not on trust in the agent, not on
  time pressure, not on prior approvals.
- Ask: "Does this proposal satisfy the task specification?" and "Does it
  introduce anything outside the task scope?"
- Signal Approve, Reject, or Redirect explicitly. Do not allow ambiguous
  responses.
- Record any concern raised during review, even if the proposal is approved.

At the midpoint checkpoint:

- Verify the Done and Stuck lists are accurate.
- Confirm no out-of-scope changes have been introduced.
- Confirm the session is on track to complete within one working session.

At session close:

- Verify all Done checklist items are satisfied.
- Confirm the session log accurately represents what happened.
- Confirm no task boundary has been breached.

---

## 3. Agent Responsibilities

### 3.1 Before Proposing

The agent must:

- Read all required context files before proposing any change.
- Identify the precise location (file, section, line range) of every proposed
  modification.
- Confirm the proposed change is within the task scope defined by the task
  specification.
- Estimate the size of the proposed diff.

### 3.2 When Proposing

The agent must:

- Present the full text of the proposed change.
- State the file and location to be modified.
- State why the change satisfies the task specification.
- Ask for explicit engineer approval before applying.
- Never apply a change without a recorded approval signal.

### 3.3 After Applying

The agent must:

- Verify the applied change by reading the modified file at the changed
  location.
- Confirm the change landed as proposed and no surrounding content was
  disturbed.
- Report the verification result to the engineer before proceeding.

### 3.4 Task Scope Discipline

The agent must not:

- Propose changes outside the scope of the active task.
- Propose changes to files not required by the active task.
- Interpret a task as authorising related improvements not specified in the
  task's Input / Output / Done contract.
- Continue into the next task without explicit engineer instruction.

---

## 4. Approval Workflow

Every proposal follows this sequence:

```
Agent presents full proposal text
        ↓
Engineer evaluates the proposal
        ↓
Engineer signals: Approve / Reject / Redirect
        ↓
    ┌───┴───┐
    │       │
Approve   Reject or Redirect
    │       │
Agent     Agent documents the
applies   decision; proposes
change    alternative or stops
    │
Agent verifies
applied change
```

### 4.1 Approve

The engineer confirms the proposal is correct and within scope. The agent
applies the change and verifies it.

### 4.2 Reject

The engineer determines the proposal is incorrect, out of scope, or should
not be applied. The agent:

1. Does not apply the change.
2. Records the rejection in the session log with the engineer's stated reason.
3. Proposes an alternative if one exists, or reports that no viable alternative
   is available.
4. Never applies the rejected change in a later proposal by reformulating it
   without disclosure.

### 4.3 Redirect

The engineer determines the proposal direction is wrong but the underlying
need is valid. The engineer provides a new direction. The agent:

1. Does not apply the original proposal.
2. Records the redirect in the session log: original proposal, redirect
   instruction, and new proposal.
3. Presents the new proposal for approval as a fresh proposal.

### 4.4 Modification

The engineer approves the proposal with stated modifications. The agent:

1. Records the original proposal and the modifications in the session log.
2. Presents the modified proposal for a final explicit approval before
   applying.
3. Does not apply the modified version without the second approval signal.

---

## 5. Checkpoint Strategy

### 5.1 Mandatory Midpoint Checkpoint

Every supervised implementation session produces a mandatory checkpoint at
approximately the halfway point. "Halfway" is defined as:

- Approximately 50% of the estimated session duration, or
- After the first major proposal has been applied and verified, whichever
  comes first.

The checkpoint is always generated, even if the session is proceeding without
issues.

### 5.2 Checkpoint Contents

Every checkpoint must contain exactly four sections:

| Section | Content |
|---|---|
| Done | What has been accomplished since the session started |
| Stuck | Any blocked item, unresolved decision, or missing information |
| Discovered | Any finding that was not present in the task specification |
| Rejected | Every proposal rejected or redirected since the session started |

The Rejected section records the full proposal text or a precise summary,
the reason for rejection or redirect, and the outcome.

### 5.3 Checkpoint as a Safety Valve

The checkpoint is not a status update. It is a safety valve. Its purpose is
to give the engineer a structured opportunity to:

- Identify if the session has drifted from the task scope.
- Confirm that the Stuck list has no hidden blockers.
- Confirm that Discovered items do not warrant stopping the session.
- Confirm that Rejected items were correctly handled.

An engineer who reads only the Rejected section of the checkpoint is using
it correctly.

---

## 6. Rejected Alternative Documentation

Every rejected and redirected proposal must be documented in:

1. The session log (Section: Rejected Alternatives).
2. The checkpoint if it occurred before the checkpoint was generated.

The documentation format for each rejection:

```
Proposal:  [Summary of the original proposal]
Decision:  [Reject / Redirect]
Reason:    [Engineer's stated reason]
Outcome:   [What happened instead — alternative applied or session stopped]
```

A session that ends with zero documented rejections must be reviewed for
whether proposals were scrutinised sufficiently.

---

## 7. Verification Gate Expectations

### 7.1 Every Task Has a Done Checklist

The task specification contains a Done checklist. The Done checklist is the
verification contract for the session. Every item on the checklist must be
evaluated before the session is closed.

### 7.2 Every Checklist Item Requires Evidence

For each Done checklist item, the session log must record:

- The claim being verified.
- The evidence cited (file, section, line, or content reference).
- The pass/fail result.

An item marked PASS without evidence is not verified. It is assumed.

### 7.3 Verification Is Independent of the Agent

The agent may perform the verification steps, but the engineer must read
the evidence. The engineer's acceptance of the verification result is the
verification act, not the agent's assertion.

---

## 8. Stopping Point Philosophy

### 8.1 Stop at a Logical Boundary

If a task cannot be completed in a single session, the agent stops at the
nearest logical boundary — the last successfully applied and verified change.
The session log marks the implementation as PARTIAL with a clear description
of what was completed and what remains.

### 8.2 Partial Is Acceptable; Undefined Is Not

An implementation marked PARTIAL is a valid session outcome. An implementation
that is half-applied with no boundary recorded is not. The stopping point must
be described precisely enough that a new session can resume from it without
re-reading the entire session history.

### 8.3 Never Continue into the Next Task

A supervised session covers exactly one task. When the active task is complete
or when the session reaches its stopping point, the session ends. The agent
does not continue into the next task without explicit authorisation from the
engineer.

---

## 9. Anti-Patterns

The following behaviours are violations of this standard. They must not occur
in any supervised implementation session.

| Anti-pattern | Why it violates the standard |
|---|---|
| Applying a change before receiving an approval signal | Violates Section 1.1 — the engineer decides |
| Interpreting silence or ambiguity as approval | Violates Section 1.1 — approval must be explicit |
| Proposing a change without showing its full content | Violates Section 1.2 — proposals must be visible |
| Re-proposing a rejected change without disclosure | Violates Section 4.2 — rejections are permanent evidence |
| Omitting the midpoint checkpoint | Violates Section 5.1 — the checkpoint is mandatory |
| Completing the verification section without citing evidence | Violates Section 7.2 — verification requires evidence |
| Continuing into the next task without authorisation | Violates Section 8.3 — one task per session |
| Recording zero rejections without justification | Raises scrutiny concern — see Section 6 |
| Proposing changes outside the active task scope | Violates Section 3.4 — task scope discipline |
| Marking the session complete before all Done items pass | Violates Section 7.1 — the Done checklist is the contract |

---

## 10. Session Log Requirement

Every supervised session produces a session log. The session log is an
Engineering Asset. It is not an optional record.

The session log format is defined in `templates/supervised-session/session-log.template.md`
(TPL-SS-001).

The minimum required sections are:

- Task Specification
- Context Loaded
- Ordered Action Log
- Rejected Alternatives
- Verification Gates Run
- Outcome

The session log is the primary evidence artefact for the session. It enables
an independent reviewer to reconstruct the session's decisions without
access to the conversation history.

---

## 11. Relationship to Task Decomposition Standard

This standard operates downstream of STD-007 (Engineering Task Decomposition
Standard). STD-007 governs how tasks are defined before implementation.
This standard (STD-008) governs how those tasks are executed under supervision.

The two standards are complementary:

| Concern | Governing standard |
|---|---|
| Task boundaries, scope, and interface contracts | STD-007 |
| Proposal approval, rejection documentation, and session evidence | STD-008 |
| Stopping points and partial implementation | STD-008 |
| Verification gates and done checklist | STD-007 (contract) + STD-008 (execution) |
