# ADR-005 — Skill Authoring Standard

**Status:** Approved

**Date:** 2026-07-21

**Version:** 1.0.0

**Supersedes:** None

**Related ADRs:**

* ADR-000 — Engineering Toolkit Foundation
* ADR-001 — Repository Structure
* ADR-002 — Engineering Asset Model
* ADR-003 — Asset Metadata Model
* ADR-004 — Context Bundle Specification
* ADR-009 — Evidence & Verification Model
* ADR-010 — Execution Architecture

---

# 1. Context

The Engineering Toolkit captures reusable engineering knowledge through Engineering Assets.

Among all asset types, **Skills** are the primary mechanism for encoding repeatable engineering capabilities.

Without a common authoring standard, Skills become inconsistent, difficult to review, and tightly coupled to specific repositories or technologies.

This ADR establishes the engineering standard for creating, reviewing, evolving, and maintaining Skills.

---

# 2. Problem Statement

Engineering teams often confuse:

* prompts;
* procedures;
* documentation;
* automation;
* workflows.

As a result:

* reusable knowledge is lost;
* prompts become brittle;
* engineering practices drift;
* repository-specific assumptions leak into reusable assets.

The toolkit requires a formal definition of what constitutes a Skill.

---

# 3. Decision

A Skill is defined as:

> **A reusable engineering capability that transforms a repeatable engineering activity into a documented, reviewable, and technology-agnostic procedure.**

Skills describe *how* to perform engineering work.

They do not describe projects.

They do not describe customers.

They do not describe technologies.

---

# 4. Design Principles

Every Skill shall satisfy the following principles.

## P1 — Reusable

A Skill should be reusable across projects.

---

## P2 — Technology Agnostic

Skills should describe engineering behavior.

Technology-specific knowledge belongs to Context Bundles.

---

## P3 — Single Responsibility

Every Skill solves one engineering problem.

Large Skills should be decomposed.

---

## P4 — Explicit Inputs

Required information must be clearly identified.

No hidden assumptions.

---

## P5 — Explicit Outputs

Expected deliverables must be defined.

Success should be observable.

---

## P6 — Verifiable

A Skill should define how its results are validated.

---

## P7 — Human Accountable

A Skill may recommend.

It never grants approval.

---

# 5. Skill Structure

Every Skill should define the following conceptual sections.

## Purpose

Why does this Skill exist?

---

## Scope

When should this Skill be used?

When should it not be used?

---

## Inputs

Required engineering information.

Examples:

* specification
* architecture
* context
* requirements

---

## Preconditions

Assumptions that must already be true.

---

## Procedure

Ordered engineering activities.

The procedure should be deterministic whenever practical.

---

## Outputs

Artifacts produced by the Skill.

Examples:

* Specification
* Review
* Checklist
* Report
* Migration Plan

---

## Validation

How is correctness evaluated?

Validation should be independent whenever possible.

Validation produces **Verification Assets** as defined in ADR-009 — Evidence & Verification Model.

A Skill must declare which evidence types it produces as part of its Outputs section.

---

## Limitations

Known boundaries of applicability.

---

## Human Decisions

Points requiring explicit human approval.

---

# 6. Skill Lifecycle

Skills follow the Engineering Asset lifecycle defined by ADR-002.

Typical evolution:

```text
Idea
    ↓
Draft
    ↓
Engineering Review
    ↓
Approved
    ↓
Published
    ↓
Improved
    ↓
Deprecated
```

Skill evolution should preserve backward compatibility whenever practical.

---

# 7. Context Integration

Skills consume Context Bundles.

Skills must never embed project-specific knowledge.

Examples of prohibited content:

* customer names;
* repository paths;
* internal architecture;
* production endpoints;
* proprietary terminology.

This separation preserves portability.

---

# 8. Composition

Skills may invoke other Skills.

**Allowed composition patterns:**

* **Sequential** — Skills execute in a defined order where the output of one is the input of the next.
* **Parallel** — Skills execute independently and their outputs are combined.
* **Conditional** — A Skill is invoked only when a specified precondition is satisfied.

Complex engineering processes should emerge from Skill composition rather than monolithic procedures.

Composition dependencies must be declared explicitly in the Skill's metadata `depends_on` field as defined in ADR-003.

A Skill must not declare a cyclic composition dependency.

The execution mechanics of composition are defined in ADR-010 — Execution Architecture.

Examples:

Reverse Engineering Skill

↓

Delta Specification Skill

↓

Review Skill

↓

Verification Skill

---

# 9. Anti-Patterns

The following are considered invalid Skill designs.

## Prompt Disguised as Skill

A Skill is more than a prompt.

---

## Repository-Coupled Skill

Repository-specific assumptions reduce portability.

---

## Multi-Purpose Skill

Skills should have one primary capability.

---

## Hidden Inputs

Every required dependency should be documented.

---

## Missing Validation

Outputs without verification reduce engineering quality.

---

## Human Approval Omitted

Approval points must be explicit.

---

# 10. Review Requirements

Engineering review should evaluate:

* correctness;
* completeness;
* portability;
* clarity;
* maintainability;
* validation strategy;
* dependency quality;
* alignment with ADR-000.

Reviewers should evaluate engineering quality rather than writing style.

---

# 11. Quality Characteristics

A high-quality Skill should be:

* reusable;
* understandable;
* deterministic;
* composable;
* verifiable;
* portable;
* maintainable;
* minimally coupled.

These characteristics should guide future Skill evolution.

---

# 12. Evolution Rules

Skills should evolve through:

* engineering experience;
* completed katas;
* production lessons;
* peer review;
* retrospective improvements.

A completed kata should improve an existing Skill or introduce a new one whenever possible.

This reinforces the long-term capability growth of the toolkit.

---

# 13. Future Automation

The standard enables future capabilities including:

* Skill catalogs;
* dependency visualization;
* automated validation;
* Skill composition;
* engineering recommendations;
* repository linting.

Automation is expected to support Skills.

It must never replace engineering judgment.

---

# 14. Consequences

Positive consequences:

* consistent engineering procedures;
* reusable knowledge;
* reduced prompt dependency;
* easier onboarding;
* improved review quality;
* portable engineering practices.

Trade-offs:

* higher authoring discipline;
* explicit maintenance;
* engineering governance overhead.

These trade-offs are intentional.

---

# 15. Summary

Skills are the primary reusable capability within the Engineering Toolkit.

By standardizing their structure, lifecycle, validation, and governance, the toolkit transforms engineering experience into reusable engineering knowledge.

Skills encode engineering practice.

They do not encode projects, customers, or tools.

They remain portable, composable, and independently evolvable throughout the lifetime of the Engineering Toolkit.
