---
asset_id: TPL-SS-001
asset_type: Template — Session Log
title: Supervised Implementation Session Log
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-008
  - ADR-009
related:
  - TPL-SS-000
  - TPL-SS-002
  - TPL-SS-003
  - WF-006
  - PB-004
tags:
  - supervised-implementation
  - session-log
  - evidence
  - verification
---

# Session Log — <<Task Title>>

**Session ID:** <<task-id>>
**Kata / Change reference:** <<kata-or-change-id>>
**Date:** <<YYYY-MM-DD>>
**Engineer:** <<engineer-role or "Supervised mode — all proposals require explicit approval">>
**Status:** <<IN PROGRESS | COMPLETE | PARTIAL>>

---

## Task Specification

<!--
  Copy the complete task specification here.
  Include: Task ID, Title, Input references, Output description, Done checklist.
  Do not paraphrase. The session log must be self-contained.
-->

**Task ID:** <<task-id>>
**Title:** <<task-title>>

**Input:**

<<List the input documents, versions, and sections this task depends on.>>

**Output:**

<<Describe what this task must produce. Quote the Output section from the task
specification verbatim.>>

**Done checklist:**

- [ ] <<checklist item 1>>
- [ ] <<checklist item 2>>
- [ ] <<checklist item N>>

---

## Context Loaded

<!--
  List every file read before any proposal was made.
  Include: file path, purpose, and whether it was successfully read.
  Mark any file that could not be read as MISSING with impact noted.
-->

| File | Purpose | Status |
|---|---|---|
| <<path/to/file>> | <<why this file was needed>> | Read / MISSING |

**Key discoveries during context load:**

<<Describe any finding during context loading that was not present in the task
specification and that influenced the implementation approach. If none, write
"None.">>

---

## Ordered Action Log

<!--
  Record every action taken, in order.
  Each action that represents a proposal must reference its approval decision.
  Use "PROPOSAL N" labels so the Rejected Alternatives section can cross-reference.
-->

| # | Action | Outcome |
|---|---|---|
| 1 | <<description of action>> | <<outcome — approved / rejected / applied / verified>> |
| 2 | <<description of action>> | <<outcome>> |

---

## Rejected Alternatives

<!--
  Record every proposal that was rejected or redirected.
  A session with zero entries here should be reviewed for whether proposals
  were scrutinised sufficiently (see STD-008 Section 6).
  
  If no proposals were rejected, write:
  "No proposals were rejected in this session."
  and note the reason why (e.g., "Engineer approved the first and only proposal
  without modification").
-->

| # | Proposal | Decision | Reason | Outcome |
|---|---|---|---|---|
| <<N>> | <<summary of original proposal>> | <<Reject / Redirect>> | <<engineer's stated reason>> | <<what happened instead>> |

---

## Verification Gates Run

<!--
  For every item on the Done checklist, record:
  - The claim being verified
  - The evidence cited (file, section, line, or content excerpt)
  - The pass/fail result
  
  An item marked PASS without evidence is not verified — it is assumed.
  See STD-008 Section 7.2.
-->

### Gate <<N>> — <<checklist item title>>

**Claim:** <<what must be true for this item to pass>>
**Evidence:** <<file and line or content excerpt that confirms the claim>>
**Result:** PASS / FAIL

---

## Outcome

<!--
  State the final outcome of the session.
  
  COMPLETE: All Done checklist items passed. Task is finished.
  PARTIAL: Session reached its stopping boundary before all items passed.
           Describe exactly what was completed and what remains.
  BLOCKED: A dependency or missing input prevented progress.
           Describe the blocker and the owner needed.
-->

**Status:** <<COMPLETE | PARTIAL | BLOCKED>>

<<One to three sentences summarising what the session produced, what was not
completed (if PARTIAL), and what the next step is.>>

---

## Next Step

<!--
  For COMPLETE sessions: identify the next task in the dependency graph.
  For PARTIAL sessions: describe the exact boundary at which to resume.
  For BLOCKED sessions: name the owner needed to unblock.
-->

<<Next step description.>>
