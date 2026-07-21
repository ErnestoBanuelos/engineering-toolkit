# ADR-004 — Context Bundle Specification

**Status:** Approved

**Date:** 2026-07-21

**Version:** 1.0.0

**Supersedes:** None

**Related ADRs:**

* ADR-000 — Engineering Toolkit Foundation
* ADR-001 — Repository Structure
* ADR-002 — Engineering Asset Model
* ADR-003 — Asset Metadata Model
* ADR-011 — Context Bundle Contract

---

# 1. Context

The Engineering Toolkit is intentionally repository-agnostic.

Reusable engineering assets must never contain project-specific knowledge.

However, every engineering activity requires context.

This creates an architectural requirement:

> Reusable capabilities must consume context without owning it.

The Context Bundle satisfies this requirement.

It defines the contract through which projects provide engineering knowledge to the toolkit.

---

# 2. Problem Statement

Traditional AI workflows embed project knowledge inside:

* prompts;
* conversations;
* agent memory;
* reusable templates;
* engineering assets.

This causes:

* poor portability;
* knowledge leakage;
* duplicated information;
* vendor lock-in;
* confidentiality risks;
* maintenance overhead.

The Engineering Toolkit requires a formal mechanism for separating reusable engineering capabilities from project-specific knowledge.

---

# 3. Decision

Every project shall provide its engineering context through one or more **Context Bundles**.

The Engineering Toolkit consumes Context Bundles.

It never owns them.

Context Bundles are external inputs.

They are not reusable toolkit assets.

---

# 4. Definition

A Context Bundle is:

> **A structured, versioned collection of project-specific engineering knowledge supplied to reusable Engineering Assets at execution time.**

A Context Bundle describes a project.

It does not define reusable engineering practices.

---

# 5. Design Principles

## P1 — Separation of Concerns

Engineering capabilities remain inside the toolkit.

Project knowledge remains outside.

---

## P2 — Replaceable

Changing projects should require changing only the Context Bundle.

The toolkit itself should remain unchanged.

---

## P3 — Confidentiality

Context Bundles may contain confidential information.

Engineering Toolkit assets must assume Context Bundles require appropriate protection.

---

## P4 — Explicitness

Context should be documented.

Hidden assumptions should be avoided.

---

## P5 — Evolvability

Context Bundles evolve independently from the toolkit.

---

# 6. Scope

Typical Context Bundle contents are organized into the following sections.

These sections represent the **expected structure** of a Context Bundle.

The minimum required subset for a Context Bundle to be considered valid is defined in **ADR-011 — Context Bundle Contract**.

## Project Overview

* project purpose
* business objectives
* stakeholders

---

## Technology

* languages
* frameworks
* platforms
* infrastructure
* deployment model

---

## Architecture

* high-level architecture
* bounded contexts
* integrations
* dependencies

---

## Engineering Standards

* coding conventions
* branching strategy
* review requirements
* testing expectations

---

## Domain Knowledge

* glossary
* business terminology
* domain rules
* invariants

---

## Repository Conventions

* folder structure
* naming conventions
* build process
* tooling

---

## Operational Knowledge

* environments
* deployment flow
* monitoring
* incident procedures

---

## References

* ADRs
* external documentation
* architecture diagrams
* runbooks

---

# 7. Out of Scope

Context Bundles should not contain:

* reusable Skills;
* reusable Templates;
* reusable Standards;
* toolkit governance;
* generic engineering guidance.

Those belong to the Engineering Toolkit.

---

# 8. Confidentiality Requirements

Context Bundles may include confidential engineering information.

Examples include:

* internal architecture;
* proprietary terminology;
* deployment topology;
* customer workflows.

Context Bundles shall never be assumed to be publicly distributable.

Engineering Assets must avoid copying Context Bundle content into reusable assets.

This reinforces the confidentiality principles established by ADR-000.

---

# 9. Relationship to Engineering Assets

Context Bundles are inputs.

Engineering Assets are reusable capabilities.

Their relationship is intentionally asymmetric.

```text
Engineering Toolkit
        │
        ▼
Engineering Asset
        │
Consumes
        ▼
Context Bundle
        │
Describes
        ▼
Project
```

Engineering Assets remain portable.

Context Bundles remain project-specific.

---

# 10. Versioning

Context Bundles evolve independently.

Toolkit releases must not require Context Bundle changes unless explicitly documented.

Likewise, projects may update Context Bundles without affecting toolkit architecture.

---

# 11. Lifecycle

Typical Context Bundle lifecycle:

```text
Create
    ↓
Review
    ↓
Approve
    ↓
Use
    ↓
Update
    ↓
Retire
```

The lifecycle is intentionally lightweight.

Projects may extend it according to organizational governance.

---

# 12. Validation

Context Bundles should support validation.

Validation may include:

* completeness;
* required sections;
* broken references;
* outdated links;
* missing architecture;
* missing standards.

Validation improves engineering quality but remains independent from toolkit governance.

---

# 13. Extensibility

Projects may extend Context Bundles.

Extensions should preserve compatibility with the base specification.

Unknown sections should be ignored rather than rejected.

This allows organizational customization without fragmenting the standard.

---

# 14. Consequences

Positive consequences:

* strict separation between reusable and project-specific knowledge;
* improved confidentiality;
* better portability;
* simplified onboarding;
* reusable engineering capabilities;
* reduced duplication.

Trade-offs:

* projects must maintain their own Context Bundles;
* context becomes an explicit engineering artifact;
* onboarding requires Context Bundle quality.

These trade-offs are intentional.

---

# 15. Future Work

Future ADRs may define:

* serialization formats;
* automated generation;
* synchronization with documentation repositories.

The minimum required schema and validation rules are defined in ADR-011 — Context Bundle Contract.

Implementation details beyond the minimum contract are intentionally deferred.

---

# 16. Summary

The Context Bundle Specification establishes the architectural boundary between reusable engineering capabilities and project-specific knowledge.

By externalizing context, the Engineering Toolkit remains:

* vendor agnostic;
* repository agnostic;
* reusable;
* secure;
* maintainable.

The Context Bundle is therefore considered the primary integration interface between projects and the Engineering Toolkit.
