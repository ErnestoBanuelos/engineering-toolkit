# ADR-008 — Bootstrap Architecture

**Status:** Approved

**Date:** 2026-07-21

**Version:** 1.0.0

**Supersedes:** None

**Related ADRs**

* ADR-000 — Engineering Toolkit Foundation
* ADR-001 — Repository Structure
* ADR-002 — Engineering Asset Model
* ADR-003 — Asset Metadata Model
* ADR-004 — Context Bundle Specification
* ADR-005 — Skill Authoring Standard
* ADR-006 — Asset Relationship Model
* ADR-007 — Repository Governance
* ADR-010 — Execution Architecture
* ADR-011 — Context Bundle Contract

---

# 1. Context

The Engineering Toolkit is intended to be reusable across organizations, technologies, repositories and AI platforms.

Creating a new toolkit instance manually would be:

* repetitive;
* error-prone;
* inconsistent.

A standardized bootstrap process is therefore required.

Bootstraping is considered an engineering capability.

It is not considered a prompt.

---

# 2. Problem Statement

Engineering repositories often begin with:

* copied folders;
* outdated templates;
* inconsistent documentation;
* missing governance;
* incomplete architecture.

These approaches create technical debt before development even begins.

The Engineering Toolkit requires a reproducible initialization process.

---

# 3. Decision

The Engineering Toolkit shall define a **Bootstrap Architecture**.

Bootstrap is the engineering process responsible for transforming repository architecture into an initialized repository instance.

Bootstrap is implementation-independent.

Prompts, scripts, generators and AI agents are possible implementations.

They are not the architecture.

**Bootstrap operates in two distinct modes:**

## Mode 1 — Toolkit Bootstrap

Initializes a new instance of the Engineering Toolkit itself.

A Context Bundle does not yet exist at this point.

The output is a repository governed by ADR-000 through ADR-011 and ready to receive a Context Bundle.

---

## Mode 2 — Project Bootstrap

Initializes a project repository that will consume an existing Engineering Toolkit instance.

**A Context Bundle is required** for project bootstrap.

The minimum required Context Bundle structure is defined in ADR-011 — Context Bundle Contract.

The output is a project repository with governance, standards, and initial project documentation in place.

---

# 4. Bootstrap Objectives

Bootstrap shall:

* initialize repository structure;
* establish governance;
* create foundational documentation;
* configure engineering assets;
* preserve architectural consistency;
* minimize manual work.

Bootstrap shall never bypass governance.

---

# 5. Bootstrap Principles

## B1 — Architecture First

Bootstrap implements architecture.

It never defines architecture.

---

## B2 — Repeatability

Multiple bootstrap executions should produce equivalent repository structures.

---

## B3 — Idempotence

Running bootstrap repeatedly should not corrupt existing engineering assets.

---

## B4 — Vendor Neutrality

Bootstrap must remain independent from:

* AI vendors;
* repository providers;
* IDEs;
* operating systems.

---

## B5 — Extensibility

Organizations may extend bootstrap.

Extensions should preserve architectural compatibility.

---

# 6. Bootstrap Inputs

Inputs vary by bootstrap mode.

**Toolkit Bootstrap inputs:**

* Engineering Toolkit version;
* organizational preferences;
* selected engineering capabilities.

**Project Bootstrap inputs:**

* Engineering Toolkit version;
* Context Bundle (required — see ADR-011 for minimum contract);
* repository name;
* repository description;
* organizational preferences.

Bootstrap should require explicit inputs.

Implicit assumptions should be minimized.

---

# 7. Bootstrap Outputs

Bootstrap produces an initialized repository.

Typical outputs include:

* repository structure;
* foundational ADRs;
* engineering standards;
* templates;
* governance assets;
* documentation;
* automation skeletons.

Bootstrap should not generate project-specific implementation.

---

# 8. Bootstrap Phases

Bootstrap proceeds through ordered phases.

```text
Initialize
        ↓
Configure
        ↓
Generate
        ↓
Validate
        ↓
Review
        ↓
Publish
```

Each phase should complete successfully before the next begins.

---

# 9. Validation

Bootstrap should validate:

* repository integrity;
* required assets;
* metadata consistency;
* relationship integrity;
* architectural completeness.

Validation should occur before publication.

---

# 10. Human Responsibilities

Bootstrap may be executed by automation.

Human responsibilities remain:

* selecting architecture;
* approving repository creation;
* reviewing generated assets;
* approving publication.

Bootstrap never transfers architectural ownership to automation.

---

# 11. Bootstrap Implementations

Possible implementations include:

* AI agents;
* repository generators;
* CLI applications;
* templates;
* scaffolding tools;
* scripts.

All implementations should preserve the same architectural behavior.

No implementation is considered normative.

---

# 12. Evolution

Bootstrap evolves together with the Engineering Toolkit.

Bootstrap versions should remain compatible with toolkit versions whenever practical.

Breaking bootstrap behavior requires architectural review.

---

# 13. Repository Initialization

A newly initialized repository should contain:

* repository governance;
* engineering standards;
* reusable assets;
* documentation;
* version information;
* architectural history.

Implementation artifacts should be introduced after bootstrap.

---

# 14. Anti-Patterns

The following practices violate bootstrap architecture.

## Prompt-Centric Bootstrap

Treating one prompt as the architecture.

---

## Copy-and-Paste Initialization

Duplicating repositories manually.

---

## Missing Governance

Generating repositories without foundational governance.

---

## Tool-Locked Bootstrap

Bootstrap tied to one AI platform.

---

## Incomplete Initialization

Repositories missing foundational engineering assets.

---

# 15. Consequences

Positive consequences:

* repeatable repository creation;
* consistent architecture;
* improved onboarding;
* lower setup effort;
* reduced architectural drift;
* vendor independence.

Trade-offs:

* initial bootstrap design effort;
* maintenance of bootstrap implementations;
* architectural discipline during evolution.

These trade-offs are intentional.

---

# 16. Future Work

Future ADRs may define:

* CLI bootstrap implementation;
* AI bootstrap implementation;
* bootstrap validation tooling;
* repository health assessment;
* upgrade paths between toolkit versions;
* bootstrap extensibility model.

Implementation remains intentionally outside the scope of this ADR.

---

# 17. Summary

The Bootstrap Architecture transforms the Engineering Toolkit from a conceptual framework into a reproducible engineering product.

Bootstrap is an architectural capability rather than a prompt, script or tool.

By separating architecture from implementation, the Engineering Toolkit remains portable across AI platforms while preserving governance, repeatability and long-term maintainability.

Repository initialization therefore becomes a governed engineering process instead of an ad hoc setup activity.
