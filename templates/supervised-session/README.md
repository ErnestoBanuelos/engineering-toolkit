---
asset_id: TPL-SS-000
asset_type: Template — Index
title: Supervised Session Template Set README
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-008
  - ADR-002
  - ADR-003
related:
  - TPL-SS-001
  - TPL-SS-002
  - TPL-SS-003
  - WF-006
  - PB-004
  - AUTO-004
tags:
  - supervised-implementation
  - template
  - session-log
  - checkpoint
  - actions
---

# Supervised Session Template Set

## Purpose

This template set provides the reusable document structures for every
supervised AI-assisted implementation session.

Every supervised session governed by STD-008 produces artefacts from these
templates. The templates are technology-agnostic and apply regardless of
language, platform, domain, or AI tool.

---

## Templates in This Set

| File | Asset ID | Purpose |
|---|---|---|
| `session-log.template.md` | TPL-SS-001 | Complete session record: task spec, context loaded, action log, rejections, verification gates, outcome |
| `checkpoint.template.md` | TPL-SS-002 | Mandatory midpoint checkpoint: Done / Stuck / Discovered / Rejected |
| `actions.template.jsonl` | TPL-SS-003 | Machine-readable action log for tooling integration |

---

## Usage

### When to use these templates

Use the session log template (TPL-SS-001) for every supervised implementation
session, regardless of size. A session that produces no changes still produces
a session log recording why no changes were made.

Use the checkpoint template (TPL-SS-002) at the mandatory midpoint of every
session. The checkpoint is generated even when the session is proceeding
without issues (see STD-008 Section 5).

Use the actions template (TPL-SS-003) when the consuming project uses tooling
that ingests session action logs for reporting, compliance, or tracing.

### Naming convention

Session artefacts are stored in the consuming project at:

```
sessions/<task-id>/session-log.md
sessions/<task-id>/checkpoint.md
sessions/<task-id>/actions.jsonl
```

The `<task-id>` matches the task identifier from the task decomposition
(e.g., `T1`, `T2`).

### Placeholder conventions

All placeholders appear in double angle brackets: `<<placeholder>>`.

Required placeholders must be replaced before the document is used as evidence.

Optional placeholders are marked `[optional]` in the template guidance.

---

## Relationship to Other Assets

| Asset | Relationship |
|---|---|
| STD-008 | This template set implements the session log, checkpoint, and action log requirements of STD-008 |
| WF-006 | The workflow references these templates as the deliverables for each stage |
| PB-004 | The playbook references these templates as the evidence the supervisor reads |
| AUTO-004 | The bootstrap automation populates these templates from task specification inputs |
