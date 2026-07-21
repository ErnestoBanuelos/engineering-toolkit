# Context

## Purpose

The Context domain defines the interface between the Engineering Toolkit and the projects that consume it.

It contains specifications, schemas, and validation assets that describe how Context Bundles are structured and used.

---

## Responsibilities

- Define and maintain the Context Bundle specification.
- Provide validation schemas for Context Bundles.
- Document the integration interface between projects and the toolkit.
- Describe how assets declare their context requirements.

---

## What Belongs Here

- Context Bundle specification documents.
- Validation schemas for Context Bundles.
- Context requirement declarations.
- Interface documentation explaining how projects integrate with the toolkit.

---

## What Does NOT Belong Here

- Actual Context Bundles (those belong to consuming projects, never to the toolkit).
- Project-specific content of any kind.
- Reusable Skills, Templates, or Standards.
- Customer information.

---

## Critical Boundary

The toolkit defines the **contract**.

Projects supply the **content**.

A Context Bundle must never be committed to this repository.

---

## Related ADRs

- ADR-004 — Context Bundle Specification
- ADR-011 — Context Bundle Contract
- ADR-000 — Engineering Toolkit Foundation (Principle P1: Context Is Injectable)
- ADR-010 — Execution Architecture (context binding at execution time)
