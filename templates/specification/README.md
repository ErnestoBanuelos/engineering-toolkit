---
asset_id: TPL-SPEC-000
asset_type: Template Index
title: Feature Specification Template Set
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-004
  - STD-005
  - ADR-002
  - ADR-003
  - ADR-007
  - ADR-009
related:
  - TPL-SPEC-001
  - TPL-SPEC-002
  - WF-003
  - PB-001
tags:
  - specification
  - template
  - feature
---

# Feature Specification Template Set

## Purpose

This template set provides the canonical starting point for every new engineering feature
specification. Use these templates in conjunction with STD-004 (Engineering Specification
Standard) and STD-005 (NFR Budget Standard).

The templates are intentionally generic. They contain no project-specific language, no
technology references, and no organisational assumptions. All project-specific content is
supplied by the author when the template is instantiated.

---

## Templates in This Set

| File | Asset ID | Purpose |
|---|---|---|
| `spec.template.md` | TPL-SPEC-001 | Feature specification body |
| `audit.template.md` | TPL-SPEC-002 | Independent specification audit report |

---

## Usage

### Step 1 — Copy the templates

Copy `spec.template.md` and `audit.template.md` into the target repository under a
path appropriate to the project's specification convention. Suggested path:

```
specs/<capability-name>/spec.md
specs/<capability-name>/audit.md
```

### Step 2 — Fill the specification

Replace every `{{PLACEHOLDER}}` in `spec.template.md` with project-specific content.
Follow STD-004 for each section. Follow STD-005 for the NFR Budget section.

### Step 3 — Submit for audit

Assign a reviewer who has not participated in authoring the specification (Isolation
Tier A per STD-004 Section 8.1). Provide the reviewer with `audit.template.md`.

### Step 4 — Resolve findings

Apply all INCORPORATE resolutions to `spec.md`. Document all REJECT rationales. Add
gap entries for all DEFER resolutions. Update the spec version header.

### Step 5 — Seek human approval

Submit for human approval per ADR-007 Level 3 governance. Implementation may not begin
until the specification reaches Approved status.

---

## Placeholder Reference

| Placeholder | Where used | Content |
|---|---|---|
| `{{CAPABILITY_NAME}}` | spec header | Short name of the capability |
| `{{SPEC_VERSION}}` | spec header | Semantic version, starting at 1.0.0 |
| `{{DATE}}` | spec and audit headers | ISO 8601 date |
| `{{AUTHOR_ROLE}}` | spec header | Role of the specification author |
| `{{PURPOSE_STATEMENT}}` | Purpose section | One-paragraph capability purpose |
| `{{INPUT_TYPE_N}}` | Behaviour section | Name of each accepted input type |
| `{{OUTPUT_STRUCTURE}}` | Behaviour section | Description of the output format |
| `{{ERROR_CODE_N}}` | Errors section | Symbolic error constant |
| `{{NFR_METRIC_N}}` | NFR Budget | Name of each measurable NFR metric |
| `{{FINDING_N_ID}}` | Audit template | Symbolic audit finding identifier |
| `{{REVIEWER_ROLE}}` | Audit template | Role of the auditor |

---

## Constraints

- Do not modify this template set to include project-specific content.
- Do not use these templates as live specification documents. Copy them first.
- The audit template must be used by a reviewer who has not authored the specification.
- These templates are governed by STD-004 and must be updated when STD-004 changes.
