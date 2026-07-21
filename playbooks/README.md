# Playbooks

## Purpose

The Playbooks domain contains decision frameworks for human-led engineering operations.

A Playbook guides engineering decisions according to context and risk.

---

## Responsibilities

- Provide operational guidance for engineering scenarios that require human judgment.
- Describe how to navigate complex or high-risk engineering situations.
- Reference relevant Skills, Workflows, and Standards that apply in a given scenario.

---

## What Belongs Here

- Greenfield development playbooks.
- Brownfield modernization playbooks.
- Emergency hotfix playbooks.
- Async engineering playbooks.
- Supervised engineering playbooks.
- Any scenario where engineering decisions depend on context and cannot be fully automated.

---

## What Does NOT Belong Here

- Deterministic execution sequences (those belong to `workflows/`).
- Individual engineering procedures (those belong to `skills/`).
- Engineering policy (that belongs to `standards/`).
- Project-specific operational runbooks (those belong to the project's Context Bundle).

---

## Playbook vs Workflow

A **Playbook** is a decision framework for human-led operations.

It defines *how to respond to a situation* based on context and risk.

It is context-dependent and may not be fully deterministic.

A Workflow may be referenced by a Playbook.

A Playbook must not be referenced by a Workflow.

---

## Related ADRs

- ADR-001 — Repository Structure (Section 4.7, Rule R7)
- ADR-005 — Skill Authoring Standard
- ADR-010 — Execution Architecture
