# Templates

## Purpose

The Templates domain contains reusable document templates that reduce variability while preserving engineering quality.

---

## Responsibilities

- Provide canonical templates for recurring engineering documents.
- Define the structure of engineering artifacts produced by Skills and Workflows.
- Reduce authoring effort without sacrificing consistency.

---

## What Belongs Here

- Feature Specification templates.
- Delta Specification templates.
- ADR templates.
- Replay Packet templates.
- Session Summary templates.
- Runbook templates.
- Review Report templates.
- Verification Report templates.
- Context Bundle templates (structure only — never with project content).

---

## What Does NOT Belong Here

- Completed or populated template instances (those are project artifacts).
- Procedures for using templates (those belong to `skills/`).
- Project-specific content.
- Context Bundles.

---

## Template Authoring

Every template is an Engineering Asset.

Templates must:

- Include YAML front matter metadata (ADR-003).
- Define all placeholders explicitly.
- Include usage guidance.
- Remain technology-agnostic unless the template is explicitly scoped to a technology.

Templates are educational.

Completed instances are not normative.

---

## Related ADRs

- ADR-001 — Repository Structure (Section 4.4)
- ADR-002 — Engineering Asset Model
- ADR-003 — Asset Metadata Model
- ADR-005 — Skill Authoring Standard (Outputs section references templates)
