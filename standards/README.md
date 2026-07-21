# Standards

## Purpose

The Standards domain contains engineering policies and conventions that establish consistency across all engineering activities.

---

## Responsibilities

- Define naming conventions for Engineering Assets.
- Establish coding standards that apply across projects consuming the toolkit.
- Define documentation standards.
- Define review standards and criteria.
- Define specification standards.

---

## What Belongs Here

- Naming conventions for Engineering Assets and repository artifacts.
- Coding standards that are language-agnostic or parameterized by technology.
- Documentation standards.
- Review criteria and evaluation standards.
- Specification quality standards.

---

## What Does NOT Belong Here

- Project-specific coding standards (those belong to the project's Context Bundle).
- Procedures for performing work (those belong to `skills/`).
- Operational guidance (that belongs to `playbooks/`).
- Automation that enforces standards (that belongs to `automation/`).

---

## Relationship to Other Domains

Standards define **policy**.

Skills describe **procedures** for applying policy.

Automation **enforces** policy.

A Standard should never contain a procedure. If a procedure is needed to apply a standard, author a Skill that references the standard.

---

## Related ADRs

- ADR-001 — Repository Structure (Section 4.3, Rule R7)
- ADR-002 — Engineering Asset Model
- ADR-003 — Asset Metadata Model
