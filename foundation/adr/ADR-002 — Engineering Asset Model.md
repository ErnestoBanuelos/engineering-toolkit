# ADR-002 — Engineering Asset Model

**Status:** Approved

**Date:** 2026-07-21

**Version:** 1.0.0

**Supersedes:** None

**Related ADRs:**

* ADR-000 — Engineering Toolkit Foundation
* ADR-001 — Repository Structure

---

# 1. Context

ADR-000 establishes the Engineering Toolkit as a reusable AI Engineering framework.

ADR-001 defines how engineering knowledge is organized into architectural domains.

However, the toolkit still lacks a common abstraction that explains what every reusable artifact actually is.

Currently, Skills, Templates, Standards, Playbooks, ADRs, Checklists, Examples, Context specifications and other reusable components are treated as independent concepts.

This creates unnecessary duplication and prevents consistent governance.

A common engineering asset model is therefore required.

---

# 2. Problem Statement

Without a shared asset model:

* every artifact defines its own metadata;
* lifecycle management becomes inconsistent;
* automation becomes difficult;
* dependency tracking becomes fragmented;
* governance becomes inconsistent;
* versioning rules diverge;
* repository evolution becomes increasingly complex.

The Engineering Toolkit requires a common conceptual model before defining individual artifact types.

---

# 3. Decision

The Engineering Toolkit shall define a single root abstraction:

> **Engineering Asset**

Every reusable component inside the toolkit shall be considered an Engineering Asset.

Individual artifact types extend this common model without redefining its fundamental behavior.

The Engineering Asset is the fundamental unit of architecture, governance, versioning, traceability and evolution.

---

# 4. Engineering Asset Definition

An Engineering Asset is:

> **A reusable, versioned, reviewable and governable unit of engineering knowledge that contributes a permanent capability to the Engineering Toolkit.**

Engineering Assets are independent from:

* programming language;
* repository;
* customer;
* AI model;
* IDE;
* vendor.

Engineering Assets represent knowledge.

They never represent project state.

---

# 5. Universal Characteristics

Every Engineering Asset shall possess the following characteristics.

## Identity

Every asset has a stable identity independent of its filename.

Identity must remain stable across refactoring and repository reorganization.

---

## Purpose

Every asset exists to solve one engineering problem.

An asset must have one primary responsibility.

---

## Version

Every asset evolves independently.

Version history must be preserved.

---

## Reviewability

Every asset can be independently reviewed.

Reviews are separate from approval.

---

## Traceability

Relationships between assets are explicit.

Dependencies must be discoverable.

---

## Reusability

Assets are intended for reuse across projects.

Project-specific knowledge is prohibited.

---

## Governability

Assets participate in governance.

Their lifecycle is managed explicitly.

---

# 6. Asset Identity

Identity is a conceptual property.

It is intentionally independent from file names or storage format.

Each asset shall expose a unique identifier.

Examples include:

* ADR-000
* SKILL-001
* TPL-004
* WF-002
* PB-003

Identifier syntax is intentionally left to future implementation decisions.

---

# 7. Asset Lifecycle

Every Engineering Asset follows the same lifecycle.

```text
Idea
    ↓
Draft
    ↓
In Review
    ↓
Reviewed
    ↓
Approved
    ↓
Published
    ↓
Deprecated
    ↓
Archived
```

This lifecycle is the **canonical status vocabulary** for all Engineering Assets, including ADRs.

No other status values are permitted.

Definitions:

**Idea**

The capability has been identified but no formal asset exists.

---

**Draft**

Initial implementation.

Incomplete.

Not reusable.

---

**In Review**

Under engineering review.

Feedback is expected.

---

**Reviewed**

No blocking engineering issues remain.

Human approval is still pending.

---

**Approved**

Human authority has accepted the asset.

Governance requirements have been satisfied.

---

**Published**

Available for reuse.

Considered part of the Engineering Toolkit.

---

**Deprecated**

Replacement exists.

Backward compatibility is maintained where appropriate.

---

**Archived**

Historical reference only.

No further evolution is expected.

---

# 8. Separation of Responsibilities

Engineering Asset lifecycle responsibilities are intentionally separated.

| Responsibility     | Actor                            |
| ------------------ | -------------------------------- |
| Authoring          | Human or AI                      |
| Engineering Review | Human or independent AI reviewer |
| Approval           | Human                            |
| Publication        | Repository Maintainer            |
| Evolution          | Community / Maintainers          |
| Deprecation        | Human Maintainer                 |

AI may assist every stage.

AI never owns governance.

---

# 9. Asset Relationships

Engineering Assets form a directed knowledge graph.

Relationships are explicit.

Examples include:

* depends on
* references
* extends
* supersedes
* replaces
* generates
* validates
* requires
* implements
* demonstrates

Relationships should be represented explicitly rather than inferred from repository structure.

Repository folders are organizational aids.

Relationships represent engineering knowledge.

---

# 10. Asset Categories

Engineering Asset is an abstract concept.

This section defines the **canonical asset category list** for the Engineering Toolkit.

All other ADRs and assets must reference this list rather than maintaining their own.

Current specializations:

* Architecture Decision Record
* Standard
* Template
* Checklist
* Skill
* Workflow
* Playbook
* Automation
* Verification Asset
* Review Asset
* Knowledge Asset
* Context Specification
* Example
* Brownfield Asset
* Database Asset
* Adapter

Future categories may be introduced through an ADR amendment without modifying the Engineering Asset model.

Adding a category requires justification that it represents a distinct engineering responsibility not already covered by an existing category.

---

# 11. Extension Model

Every specialized asset inherits the Engineering Asset model.

Each specialization may introduce additional properties.

Examples:

A Skill may define:

* inputs
* outputs
* workflow
* validation strategy

A Template may define:

* placeholders
* usage guidance

A Workflow may define:

* sequence
* decision points

A Playbook may define:

* operational scenarios
* risk guidance

Extensions shall never redefine universal properties.

---

# 12. Metadata Model

This ADR intentionally defines concepts rather than serialization formats.

Engineering Assets expose metadata.

How metadata is represented (YAML, JSON, TOML, Markdown front matter, etc.) is an implementation concern.

Metadata serialization shall be defined in a future ADR.

---

# 13. Dependency Rules

Engineering Assets may depend on other Engineering Assets.

Dependencies should satisfy the following principles:

* dependencies are explicit;
* cyclic dependencies are discouraged;
* architectural dependencies are preferred over implementation dependencies;
* reusable assets should minimize coupling.

Dependency validation may be automated in future versions of the toolkit.

---

# 14. Versioning

Each Engineering Asset evolves independently.

Repository versioning and asset versioning are intentionally separated.

This enables:

* independent evolution;
* targeted deprecation;
* compatibility management;
* selective improvements.

Repository releases represent snapshots.

Asset versions represent individual evolution.

---

# 15. Compatibility Rules

Engineering Assets should preserve compatibility whenever practical.

Breaking changes should be exceptional.

When compatibility cannot be preserved:

* rationale should be documented;
* migration guidance should exist;
* superseding assets should be identified.

---

# 16. Evolution Strategy

The Engineering Asset model is intentionally minimal.

New asset categories should extend the model rather than modify it.

Changes to the Engineering Asset abstraction itself are expected to be rare and require architectural justification.

Future ADRs should prefer extension over modification.

---

# 17. Consequences

Positive consequences:

* consistent governance;
* consistent lifecycle;
* reusable automation;
* repository-wide discoverability;
* knowledge graph capabilities;
* simplified tooling;
* reduced duplication;
* stable architecture.

Trade-offs:

* additional architectural discipline;
* explicit metadata management;
* lifecycle governance overhead.

These trade-offs are intentional.

---

# 18. Future Work

This ADR intentionally leaves the following decisions open:

* Asset identifier syntax
* Automated dependency analysis

Future ADRs expected:

* ADR-003 — Asset Metadata Model
* ADR-004 — Context Bundle Specification
* ADR-005 — Skill Authoring Standard
* ADR-006 — Asset Relationship Model
* ADR-007 — Repository Governance
* ADR-009 — Evidence & Verification Model
* ADR-010 — Execution Architecture
* ADR-011 — Context Bundle Contract

Metadata serialization and relationship serialization are addressed in ADR-003 and ADR-006 respectively.

---

# 19. Summary

The Engineering Asset Model establishes the conceptual foundation of the Engineering Toolkit.

Every reusable capability in the repository is treated as an Engineering Asset.

By introducing a shared abstraction, the toolkit gains:

* consistent governance;
* unified lifecycle management;
* explicit relationships;
* independent versioning;
* extensibility;
* long-term architectural stability.

This model enables future tooling, automation, validation and knowledge graph capabilities while remaining independent of implementation technologies and AI vendors.

The Engineering Asset is therefore considered the fundamental architectural building block of the Engineering Toolkit.
