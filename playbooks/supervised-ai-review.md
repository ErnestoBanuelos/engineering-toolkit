---
asset_id: PB-004
asset_type: Playbook
title: Supervised AI Implementation Review Playbook
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-008
  - ADR-007
  - ADR-009
related:
  - TPL-SS-001
  - TPL-SS-002
  - TPL-SS-003
  - WF-006
  - AUTO-004
  - STD-007
tags:
  - supervised-implementation
  - playbook
  - review
  - approval
  - rejection-documentation
  - human-accountability
---

# Supervised AI Implementation Review Playbook

## Purpose

This playbook guides an engineer through supervising an AI-assisted
implementation session. It covers how to evaluate proposals, approve changes,
reject and redirect proposals, identify hidden assumptions, stop a session
safely, and recognise common mistakes.

The playbook is technology-agnostic. It applies to any supervised
implementation session regardless of language, deployment model, domain, or
AI tool.

---

## Before You Begin

Answer these questions before the session starts:

| Question | If no |
|---|---|
| Have you read the task specification in full? | Read it now. Supervising a task you have not read produces approvals without understanding. |
| Do you know which files the task may modify? | Find the task's Input section and confirm the file scope. |
| Do you have the Done checklist in front of you? | Print or open it. You will evaluate every item at the end of the session. |
| Have you confirmed all prerequisite tasks are complete? | Check the dependency graph in the task decomposition. Do not supervise a task whose dependencies are unresolved. |
| Have you read STD-008 Sections 1–4? | Read them. The supervision philosophy, engineer responsibilities, and approval workflow are the foundation of this playbook. |

---

## 1. How to Supervise an AI Implementation Session

### Mindset

You are the decision-maker. The agent is the executor.

Every proposal the agent makes is a request for your permission to modify the
repository. You are not obligated to approve any proposal. You are obligated
to evaluate every one.

Your job is not to check that the agent followed instructions. Your job is to
verify that the change is correct, within scope, and safe to apply.

### Step 1 — Confirm scope before the first proposal

Before the agent makes its first proposal, confirm the session scope with it:

- Which task is active?
- Which files may be modified?
- What is the Done checklist?
- What is out of scope?

If the agent cannot state the scope accurately from its context load, do not
proceed. Ask the agent to read the missing context first.

### Step 2 — Read every proposal before signalling

Read the full text of every proposal before signalling. Do not skim.

Ask yourself:

- Does this change satisfy the task's Output specification?
- Is this change within the task scope?
- Does this change introduce anything not specified in the task?
- Does this change break any existing behaviour?

Take the time you need. The agent waits for your signal.

### Step 3 — Signal explicitly

Signal Approve, Reject, or Redirect explicitly. Do not use ambiguous language.

Examples of explicit signals:

| Signal | Example phrasing |
|---|---|
| Approve | "Approve — apply as proposed." |
| Reject | "Reject. [Reason]." |
| Redirect | "Redirect. [New direction]." |
| Approve with modification | "Approve with the following change: [modification]. Show me the modified version before applying." |

Avoid: "Looks good." (ambiguous), "Sure." (ambiguous), "I guess so." (not a
professional approval signal).

### Step 4 — Verify the applied change yourself

After the agent reports that a change has been applied and verified, read the
modified section yourself. Do not rely solely on the agent's report.

This is not a sign of distrust. It is the practice of independent verification.

---

## 2. How to Approve Changes

### Conditions for approval

Approve a proposal when all of the following are true:

1. The change satisfies the task Output specification.
2. The change is within the task's declared file scope.
3. The change does not introduce logic, structure, or content not required by
   the task.
4. The change does not break or alter existing content outside the task scope.
5. The proposed text matches what you would write if you were implementing it
   yourself (or is a correct equivalent).

### What approval is not

Approval is not:

- Agreement that the change is optimal. It means the change is correct and safe.
- A signal that subsequent changes are pre-approved.
- Transferable to a different change with similar intent.

Every proposal receives its own approval signal.

---

## 3. How to Reject Proposals

### When to reject

Reject a proposal when:

- The change is incorrect in content or logic.
- The change is outside the task scope (even if it would be an improvement).
- The change introduces a dependency, pattern, or structure not specified in
  the task.
- The change breaks or alters existing content outside the task scope.
- The proposed text does not match the task's Output specification.

### How to reject

State the rejection explicitly and give a specific reason:

```
Reject. [Reason]
```

The reason must be specific enough for the agent to understand why the
proposal is wrong and to formulate a correct alternative.

Examples of specific rejection reasons:

- "Reject. The proposed text modifies the existing table format. The task
  specifies an insertion after the table, not a modification to it."
- "Reject. The proposed section heading is at the wrong nesting level. It
  should be #### not ###."
- "Reject. This change is outside the task scope. The task only permits
  changes to Section 1.2."

### After rejection

After you reject a proposal:

1. Confirm the agent has recorded the rejection.
2. If the agent proposes an alternative, evaluate it as a fresh proposal.
3. If the agent cannot produce a satisfactory alternative, stop the session
   and record it as BLOCKED.

Never accept a reformulated rejection without reviewing it as carefully as
the original.

---

## 4. How to Redirect Proposals

### When to redirect

Redirect a proposal when the direction is wrong but the underlying need is
valid. A redirect acknowledges that the agent understood the task requirement
but chose the wrong approach.

### How to redirect

State the redirect and provide the new direction:

```
Redirect. [What was wrong with the current direction.] Instead: [New direction].
```

Example:

```
Redirect. Inserting this as a standalone section is too heavy. Instead,
add it as a subsection of the existing Section 1.2 using a #### heading.
```

### After redirect

1. The agent records the redirect in the session log.
2. The agent presents a new proposal based on your direction.
3. Evaluate the new proposal as a fresh proposal — not as an automatic
   improvement over the original.

---

## 5. How to Identify Hidden Assumptions

Hidden assumptions are implicit decisions the agent makes that are not
authorised by the task specification. They are the most common source of
scope creep in supervised sessions.

### Warning signs

Watch for proposals that:

- Add "helpful" structure not mentioned in the task Output specification.
- Use a format or convention not established in the target file.
- Change existing content "while we're here."
- Reference a prior conversation or context that is not part of the task input.
- Add explanatory commentary that was not requested.

### How to surface hidden assumptions

When you suspect a hidden assumption, ask:

- "Where in the task specification does it say to do this?"
- "What in the task Output requires this format?"
- "Is this change required for the Done checklist to pass, or is it optional?"

If the agent cannot answer by citing the task specification, the assumption
is hidden. Reject or redirect the proposal.

### The "already done" assumption

Be alert to the agent proposing that something is "already covered" or "already
handled." This may be true, but it must be verified. Ask the agent to cite the
specific file and line where the claim is satisfied before accepting it.

---

## 6. How to Stop an Implementation Session Safely

### When to stop

Stop the session when:

- The active task cannot be completed before the available time or effort
  is exhausted.
- A BLOCKED condition arises that requires information or approval from a
  named owner.
- The session has drifted from the task scope and the drift cannot be corrected
  by a redirect.
- An applied change has been discovered to be incorrect after verification and
  cannot be reversed without risk.

### How to stop

1. Instruct the agent to stop proposing further changes.
2. Identify the last successfully applied and verified change. This is the
   stopping boundary.
3. Ask the agent to record the stopping boundary in the session log Outcome
   section.
4. Mark the session as PARTIAL or BLOCKED as appropriate.
5. Do not start the next task in the same session.

### Reversing an incorrect applied change

If an applied change is discovered to be incorrect:

1. Stop the session.
2. Document the incorrect change in the session log.
3. Determine whether the change can be safely reversed without affecting other
   changes in the session.
4. If reversible: apply the reversal as a new proposal under supervision.
5. If not reversible without risk: stop, record as BLOCKED, and escalate to
   the appropriate owner.

---

## 7. Common Mistakes

### Mistake 1 — Approving without reading the full proposal

**Symptom:** Engineer scans the proposal, notices the first part looks
correct, and approves.

**Consequence:** The second half of the proposal contains an out-of-scope
change that is applied without review.

**Prevention:** Read every proposal in full before signalling.

---

### Mistake 2 — Treating the checkpoint as a status report

**Symptom:** Engineer reads the Done section and skips the Stuck, Discovered,
and Rejected sections.

**Consequence:** A blocker, a scope discovery, or an undocumented rejection
is missed. The session continues with an unresolved problem.

**Prevention:** Read all four checkpoint sections. Pay particular attention
to Rejected. An empty Rejected section deserves scrutiny.

---

### Mistake 3 — Accepting "already handled" without evidence

**Symptom:** Agent states a requirement is satisfied by existing content.
Engineer accepts the statement without verifying.

**Consequence:** A Done checklist item is marked as passing based on an
agent assertion, not on evidence.

**Prevention:** Ask the agent to cite the specific file and line for every
"already handled" claim. Read it yourself.

---

### Mistake 4 — Allowing the session to drift into the next task

**Symptom:** Active task is complete. Agent notices that the next task is
small and begins proposing changes that "naturally follow."

**Consequence:** The session includes changes from two tasks. The session log
does not accurately represent what was implemented. The next task has no
session log.

**Prevention:** When the active task is complete, stop. The next task is a
separate session.

---

### Mistake 5 — Conflating scope with quality

**Symptom:** Engineer approves an out-of-scope change because it is a genuine
improvement.

**Consequence:** The change is applied without being in any task's Done
checklist. It has no verification gate. It may break the interface contract
for a downstream task.

**Prevention:** Out-of-scope improvements belong in a new task. Create the
task, add it to the decomposition, and implement it in its own session.

---

### Mistake 6 — Recording zero rejections without scrutiny

**Symptom:** Session ends with zero entries in the Rejected Alternatives
section.

**Consequence:** No evidence that proposals were challenged. May indicate
that the first proposal for every change was accepted without adequate review.

**Prevention:** If the session genuinely produced zero rejections, note why:
e.g., "The first and only proposal for each change was correct as presented
because the task specification was unambiguous." A stated reason is evidence
of scrutiny; an empty section is not.

---

## 8. Reading the Session Log as a Reviewer

When reviewing a session log produced by another engineer:

| Section | What to verify |
|---|---|
| Task Specification | Is the Done checklist present? Is it complete? |
| Context Loaded | Were all required input files read before any proposal was made? |
| Ordered Action Log | Does the sequence of actions match the approval signals? Is there any applied change with no recorded approval? |
| Rejected Alternatives | Are rejections specific? Is the reason given? Is the outcome documented? |
| Verification Gates | Does every PASS cite evidence? Is any PASS unsupported by a citation? |
| Outcome | Does the outcome accurately reflect the verification gate results? |

A session log that passes this review can be accepted as evidence of a
correctly supervised implementation session.

---

## 9. Completion Checklist

Before closing a supervised session:

- [ ] All Done checklist items are marked PASS with evidence cited.
- [ ] No out-of-scope changes are present in the session.
- [ ] Every rejected or redirected proposal is documented.
- [ ] The checkpoint was generated at the midpoint.
- [ ] The session log is complete: all six required sections present.
- [ ] The Outcome section accurately reflects the session result.
- [ ] The Next Step section is populated.
- [ ] The session has not continued into the next task.
