---
asset_id: TPL-SS-002
asset_type: Template — Checkpoint
title: Supervised Implementation Session — 15-Minute Checkpoint
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-008
related:
  - TPL-SS-000
  - TPL-SS-001
  - WF-006
  - PB-004
tags:
  - supervised-implementation
  - checkpoint
  - session-safety
---

# 15-Minute Checkpoint — <<Task Title>>

**Session ID:** <<task-id>>
**Checkpoint generated at:** <<approximate elapsed time or stage>>
**Date:** <<YYYY-MM-DD>>

---

<!--
  This checkpoint is mandatory at approximately the halfway point of every
  supervised implementation session. See STD-008 Section 5.
  
  It is generated even when the session is proceeding without issues.
  Its purpose is to give the engineer a structured opportunity to verify
  scope, identify blockers, and confirm all rejections were handled correctly.
  
  An engineer who reads only the Rejected section is using this checkpoint
  correctly.
-->

## Done

<!--
  List everything that has been accomplished since the session started.
  Be specific: name the files changed, the proposals applied, the
  verification steps completed.
-->

- <<accomplished item 1>>
- <<accomplished item 2>>

---

## Stuck

<!--
  List any blocked item, unresolved decision, or missing information that
  is preventing progress.
  
  If nothing is blocking the session, write: "Nothing blocking."
  Do not omit this section.
-->

- <<blocked item or "Nothing blocking.">>

---

## Discovered

<!--
  List any finding that was not present in the task specification.
  This includes: unexpected file states, ambiguities in the task scope,
  missing context files, or implementation constraints not visible from
  the specification alone.
  
  If nothing was discovered, write: "No unexpected findings."
  Do not omit this section.
-->

- <<discovery or "No unexpected findings.">>

---

## Rejected

<!--
  List every proposal rejected or redirected since the session started.
  If this section is empty, the engineer should ask: were proposals
  scrutinised sufficiently, or were they approved without adequate review?
  
  If no proposals were rejected, write:
  "No proposals rejected. [Brief reason — e.g., 'First proposal was
  approved as presented.']"
-->

| Proposal | Decision | Reason | Outcome |
|---|---|---|---|
| <<summary>> | <<Reject / Redirect>> | <<reason>> | <<outcome>> |
