# Automation

## Purpose

The Automation domain contains engineering automation assets that enforce, validate, and support repeatable engineering work.

---

## Responsibilities

- Provide CI policies and quality gates.
- Automate metadata validation across the repository.
- Support local automation for engineering workflows.
- Implement governance enforcement through automated checks.

---

## What Belongs Here

- CI/CD policy definitions.
- Repository linting scripts.
- Metadata validation automation.
- Relationship integrity checks.
- Quality gate definitions.
- Bootstrap scripts that implement ADR-008.
- Local engineering automation utilities.

---

## What Does NOT Belong Here

- Engineering policy definitions (those belong to `standards/`).
- Engineering procedures (those belong to `skills/`).
- Vendor-specific CI configurations used exclusively by one project.
- Project-specific automation (that belongs to the consuming project).

---

## Critical Constraint

Automation implements capabilities.

It never defines them.

If automation enforces a standard, the standard must exist in `standards/`.

Automation without a corresponding Engineering Asset is an anti-pattern.

---

## Adapters vs Automation

**Automation** — general-purpose engineering automation not tied to a specific external system.

**Adapters** — connect engineering capabilities to a specific external system (GitHub, Azure DevOps, etc.).

If the automation requires a specific external system to function, it belongs in `adapters/`.

---

## Related ADRs

- ADR-001 — Repository Structure (Section 4.13)
- ADR-007 — Repository Governance (automation supports governance)
- ADR-008 — Bootstrap Architecture
