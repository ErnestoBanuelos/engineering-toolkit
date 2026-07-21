# Contributing to the Engineering Toolkit

Thank you for contributing to the Engineering Toolkit.

This document describes the contribution process.

---

## Foundational Requirement

Before contributing, read:

- `foundation/adr/ADR-000 — Engineering Toolkit Foundation.md` — the constitutional philosophy.
- `foundation/adr/ADR-007 — Repository Governance.md` — the governance process.
- `foundation/adr/ADR-002 — Engineering Asset Model.md` — what every asset must be.

All contributions must be consistent with these ADRs.

---

## Governance Process

Every contribution follows the lifecycle defined in ADR-002 and ADR-007.

```
Idea
    ↓
Draft
    ↓
Engineering Review
    ↓
Revision
    ↓
Independent Review
    ↓
Human Approval
    ↓
Publication
```

The governance level required depends on the type of change (ADR-007 Section 8).

---

## Decision Levels

| Level | Examples | Requirements |
|---|---|---|
| 1 — Editorial | Broken links, formatting | Review |
| 2 — Content | Clarifications, examples | Engineering review |
| 3 — Engineering | New Skills, Templates, Workflows | Engineering review + independent review + human approval |
| 4 — Architectural | New ADRs, structural changes, lifecycle changes | Comprehensive review + independent review + explicit human approval |

---

## Asset Authoring

Every new Engineering Asset must:

- Follow the Engineering Asset Model defined in ADR-002.
- Include the canonical YAML front matter metadata defined in ADR-003.
- Belong to exactly one primary domain (ADR-001).
- Declare its context requirements if it consumes a Context Bundle (ADR-011).
- Have a named human Owner before publication (ADR-007).
- Pass independent review before reaching Approved status (ADR-009).

---

## What Does NOT Belong Here

- Project-specific content.
- Customer information.
- Confidential data.
- Context Bundles.
- Conversations or session logs.
- Vendor-specific implementations as normative assets.

These belong to the consuming project, not the toolkit.

---

## Architectural Changes

Changes to the constitutional architecture (ADR-000 through ADR-011) require:

- A written rationale.
- An independent review.
- Explicit human approval.
- A new or amended ADR if the change affects the architecture.

Architectural history must always be preserved.

---

## Questions

For architectural questions, open a discussion referencing the relevant ADR.

For governance questions, reference ADR-007.
