# Workflows

## Purpose

The Workflows domain contains sequenced engineering execution contracts composed from Skills and Templates.

A Workflow defines what steps are executed and in what order to complete a complex engineering activity.

---

## Responsibilities

- Combine Skills and Templates into deterministic, reusable engineering sequences.
- Define the ordering, inputs, outputs, and decision points of multi-step engineering processes.
- Support Skill composition at the process level.

---

## What Belongs Here

- Feature development workflows.
- Brownfield modernization workflows.
- Architecture review workflows.
- Incident response workflows.
- Any repeatable, multi-step engineering process that can be expressed deterministically.

---

## What Does NOT Belong Here

- Operational guidance for human-led decisions under uncertainty (that belongs to `playbooks/`).
- Individual engineering procedures (those belong to `skills/`).
- Project-specific workflows.
- Automation scripts (those belong to `automation/`).

---

## Workflow vs Playbook

A **Workflow** is a sequenced, deterministic execution contract.

It defines *what steps are executed and in what order*.

It is reusable across contexts.

A **Playbook** is a decision framework for human-led operations.

It defines *how to respond to a situation* based on context and risk.

A Workflow may be referenced by a Playbook.

A Playbook must not be referenced by a Workflow.

---

## Related ADRs

- ADR-001 — Repository Structure (Section 4.6, Rule R7)
- ADR-005 — Skill Authoring Standard (composition)
- ADR-010 — Execution Architecture
