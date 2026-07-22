---
asset_id: TPL-TD-000
asset_type: Template — Index
title: Task Decomposition Template Set README
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-007
  - ADR-002
  - ADR-003
related:
  - TPL-TD-001
  - TPL-TD-002
  - WF-005
  - PB-003
tags:
  - task-decomposition
  - template
  - planning
---

# Task Decomposition Template Set

## Purpose

This directory contains the canonical templates for Engineering Task
Decomposition. Every task decomposition produced in a consuming project
starts from these templates.

These templates implement STD-007 (Engineering Task Decomposition Standard).
They do not define the standard; they apply it.

---

## Templates in This Set

| File | Asset ID | Purpose |
|---|---|---|
| `plan.template.md` | TPL-TD-001 | Implementation Plan — one component per logical section of the specification or delta |
| `tasks.template.md` | TPL-TD-002 | Task List — 4–8 tasks with Input / Output / Done, interface contracts, and engineering review |

---

## When to Use These Templates

Use this template set when:

- A specification in Approved or Active status is ready for implementation.
- A Brownfield Delta in Approved status is ready for implementation.
- A refactoring, migration, or platform change requires a planned sequence
  of independently reviewable changes.

Do not use this template set when:

- The change is a single-line editorial fix. Single-file editorial changes
  do not require a decomposition.
- The specification has not reached Approved status. Decomposition requires
  an approved specification.
- No Brownfield Delta exists for a post-approval amendment. Produce the
  delta first (STD-006, WF-004), then decompose.

---

## Usage Instructions

### Step 1 — Copy the templates

Copy both `plan.template.md` and `tasks.template.md` into the consuming
project's change directory alongside the approved specification or delta.

Suggested target paths:

```
changes/<change-name>/plan.md
changes/<change-name>/tasks.md
```

### Step 2 — Read the standard first

Before filling any placeholder, read STD-007 (Engineering Task Decomposition
Standard) in full. The templates implement the standard but do not substitute
for it. Common decomposition mistakes arise from filling templates without
understanding the underlying principles.

### Step 3 — Fill plan.md before tasks.md

The plan identifies implementation components. The tasks decompose those
components. The plan is the input to the task list. Filling tasks.md before
plan.md produces tasks without a coherent architecture.

### Step 4 — Replace all placeholders

Every `{{PLACEHOLDER}}` in both templates must be replaced with real content
before the decomposition is submitted for review. A template that still
contains `{{...}}` tokens is not ready for review.

### Step 5 — Verify the Engineering Review checklist

Before submitting, complete the Engineering Review section in `tasks.md`.
All seven challenges must be answered with rationale.

---

## Template Conventions

Both templates use the following conventions:

- `{{PLACEHOLDER}}` — required content that must be replaced.
- `<!-- comment -->` — usage guidance; remove before publishing.
- Section ordering is fixed. Do not reorder, rename, or remove sections.

---

## Related Assets

| Asset | Relationship |
|---|---|
| STD-007 | The standard these templates implement |
| WF-005 | The workflow that governs when and how to use these templates |
| PB-003 | The playbook that guides decomposition decisions and review |
| AUTO-003 | The AI workflow that populates these templates from a specification or delta |
