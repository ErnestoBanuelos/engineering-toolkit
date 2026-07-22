---
asset_id: TPL-BD-000
asset_type: Template — Index
title: Brownfield Delta Template Set
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-006
  - ADR-002
  - ADR-003
related:
  - TPL-BD-001
  - TPL-BD-002
  - WF-004
  - PB-002
tags:
  - brownfield
  - delta
  - template
  - change-management
---

# Brownfield Delta Template Set

## Purpose

This template set provides canonical, reusable document templates for
producing, reviewing, and approving Brownfield Deltas in any engineering
system.

A Brownfield Delta is the formal artefact produced when a previously approved
specification is amended after sign-off. It captures what is preserved, what
is added, what is modified, and what is removed from the existing contract.

These templates implement the requirements defined in STD-006 (Brownfield Delta
Standard).

---

## Template Inventory

| Template | File | Purpose |
|---|---|---|
| TPL-BD-001 | `delta.template.md` | The canonical Brownfield Delta document |
| TPL-BD-002 | `review-checklist.template.md` | The Engineering Review checklist for delta approval |

---

## Usage

### Step 1 — Identify the change

Before using these templates, confirm that the change meets the scope criteria
in STD-006 Section 1. If the change is so significant that it constitutes a
new capability, author a new specification under STD-004 instead.

### Step 2 — Read the approved baseline

Read the approved specification in its entirety before authoring the delta.
You must understand every existing behaviour, constraint, and output contract
before you can reason about what the change preserves, adds, modifies, or
removes.

### Step 3 — Copy the templates to the target repository

Copy `delta.template.md` to the repository location designated for change
artefacts. Copy `review-checklist.template.md` alongside it.

Suggested paths:

```
changes/
  <capability-name>/
    delta.md          ← populated from delta.template.md
    review.md         ← populated from review-checklist.template.md
```

### Step 4 — Fill the delta template

Follow the section guidance embedded in `delta.template.md`. Replace every
`{{PLACEHOLDER}}` with the correct content for the change being analysed.

The REMOVED section and REMOVED Audit are the most effort-intensive. Do not
rush them. Apply the REMOVED Audit methodology from STD-006 Section 6 before
declaring either section complete.

### Step 5 — Apply the Engineering Review checklist

Complete `review-checklist.template.md` before submitting the delta for
approval. The checklist must be completed by the author, then by an
independent reviewer.

### Step 6 — Submit for approval

Follow WF-004 (Brownfield Change Analysis Workflow) for governance and
approval steps.

---

## Placeholder Convention

All placeholders use double curly brace syntax: `{{PLACEHOLDER_NAME}}`.

A delta template that still contains any `{{...}}` tokens has not been
completed. Automation may check for this.

---

## What Does NOT Belong in These Templates

- Project-specific content. The templates are structure; the project supplies
  content.
- Implementation details. The delta describes behaviour changes, not code
  changes.
- Speculation about unrelated changes. Every item in ADDED, MODIFIED, and
  REMOVED must be directly caused by the change being analysed.

---

## Related Assets

| Asset | Relationship |
|---|---|
| STD-006 | The standard these templates implement |
| WF-004 | The workflow that sequences delta authoring and approval |
| PB-002 | The playbook that guides backward compatibility review |
| AUTO-002 | AI-assisted workflow that generates a first-draft delta |
| TPL-SPEC-001 | The specification template the baseline will have been authored from |
