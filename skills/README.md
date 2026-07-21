# Skills

## Purpose

The Skills domain is the primary repository of reusable engineering capabilities.

A Skill encodes how to perform a repeatable engineering activity in a documented, reviewable, and technology-agnostic way.

---

## Responsibilities

- Capture repeatable engineering expertise as governed assets.
- Provide the procedures that Workflows and Playbooks orchestrate.
- Define explicit inputs, outputs, preconditions, and validation strategies.
- Support Skill composition for complex engineering processes.

---

## What Belongs Here

- Reusable engineering procedures across all domains of practice.
- Skills for specification, review, verification, documentation, analysis, migration, and any other repeatable capability.

---

## What Does NOT Belong Here

- Project-specific procedures.
- Skills that embed customer names, repository paths, or proprietary terminology.
- Prompts disguised as Skills (a Skill is more than a prompt).
- Multi-purpose Skills (each Skill has one primary responsibility).
- Automation scripts (those belong to `automation/`).

---

## Skill Authoring Requirements

Every Skill must conform to ADR-005 — Skill Authoring Standard.

Required sections:

- Purpose
- Scope
- Inputs
- Preconditions
- Procedure
- Outputs
- Validation (must reference evidence type from ADR-009)
- Limitations
- Human Decisions

Every Skill must include YAML front matter metadata (ADR-003) including `context_requires` if the Skill consumes a Context Bundle.

---

## Composition

Skills may invoke other Skills.

Allowed patterns: Sequential, Parallel, Conditional.

Composition dependencies must be declared in the `depends_on` metadata field.

Cyclic composition is prohibited.

---

## Related ADRs

- ADR-005 — Skill Authoring Standard
- ADR-002 — Engineering Asset Model
- ADR-003 — Asset Metadata Model
- ADR-009 — Evidence & Verification Model
- ADR-010 — Execution Architecture
- ADR-011 — Context Bundle Contract
