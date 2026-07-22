---
id: TPL-CB-000
title: "Context Bundle Template Set — README"
type: Template
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: templates
tags: [context-bundle, hot-context, warm-context, cold-context, onboarding]
depends_on: [ADR-004, ADR-011, STD-001, STD-002]
related: [TPL-CB-001, TPL-CB-002, TPL-CB-003, TPL-CB-004]
supersedes: ""
superseded_by: ""
---

# Context Bundle Template Set

## Purpose

This template set provides the structural scaffolding for bootstrapping a layered
Context Bundle in any project consuming the Engineering Toolkit.

A Context Bundle is the interface between a project and the Engineering Toolkit.
It supplies project-specific knowledge to reusable assets at execution time without
contaminating those assets with project content.

These templates implement the three-layer Context Bundle model:

| Layer | Template | Description |
|---|---|---|
| Hot Context | `CLAUDE.template.md` | Permanent behavioural rules for AI sessions |
| Warm Context | `stack.template.md` | Verified technical stack and architectural reference |
| Cold Context index | `cold-readme.template.md` | Index of what belongs in Cold Context |
| Cold Context gaps | `gap-log.template.md` | Record of identified knowledge gaps |

---

## Usage

1. Copy all four content templates into your project at the paths below.
2. Rename each template by removing `.template` from the filename.
3. Replace all `{{PLACEHOLDER}}` values with project-specific content.
4. Verify all factual claims in `stack.md` against source files (see STD-002).
5. Record genuine knowledge gaps in `gap-log.md`.
6. Do not fabricate history or invent gaps.

---

## Target File Locations

After instantiation, the files should live at these paths in the consuming project:

```
project-root/
├── CLAUDE.md                    ← Hot Context (from CLAUDE.template.md)
├── docs/
│   └── context/
│       └── stack.md             ← Warm Context (from stack.template.md)
└── context/
    └── cold/
        ├── README.md            ← Cold Context index (from cold-readme.template.md)
        └── gap-log.md           ← Gap log (from gap-log.template.md)
```

Projects may use different directory paths. What matters is that each layer is
logically distinct and that Hot Context is loaded by the AI assistant automatically.

---

## Constraints

- Do **not** commit populated templates to the Engineering Toolkit.
  Completed instances belong to the consuming project. (ADR-004 Section 7, ADR-011
  Section 11)
- Do **not** include project-specific content in this template directory.
- Templates are educational. Completed instances are not normative.

---

## Related Standards

- STD-001 — Context Layer Decision Standard (placement decisions)
- STD-002 — Verification Evidence Standard (how to record verified claims)

---

## Related ADRs

- ADR-004 — Context Bundle Specification
- ADR-011 — Context Bundle Contract (minimum required sections: CB-01 through CB-06)
