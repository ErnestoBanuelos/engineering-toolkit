# ADR-003 — Asset Metadata Model

**Status:** Approved

**Date:** 2026-07-21

**Version:** 1.0.0

**Supersedes:** None

**Related ADRs:**

* ADR-000 — Engineering Toolkit Foundation
* ADR-001 — Repository Structure
* ADR-002 — Engineering Asset Model

---

# 1. Context

ADR-002 introduced the concept of the **Engineering Asset** as the fundamental architectural unit of the Engineering Toolkit.

While every Engineering Asset shares common characteristics such as identity, lifecycle, governance, and traceability, there is currently no standardized mechanism for describing these characteristics in a machine-readable manner.

Without a common metadata contract, assets become difficult to discover, validate, relate, govern, and automate.

This ADR establishes the canonical metadata model shared by all Engineering Assets.

---

# 2. Problem Statement

Engineering Assets are expected to support:

* governance
* versioning
* traceability
* dependency analysis
* repository navigation
* search
* automation
* quality validation

Without standardized metadata:

* each asset defines its own structure;
* automation becomes repository-specific;
* validation requires manual interpretation;
* relationships become implicit;
* engineering knowledge becomes fragmented.

A shared metadata contract is therefore required.

---

# 3. Decision

Every Engineering Asset shall expose a standard metadata contract.

The metadata model represents the **minimum required engineering information** needed to manage an asset throughout its lifecycle.

Metadata describes the asset.

It never replaces the asset itself.

---

# 4. Design Principles

The metadata model follows the following principles.

## P1 — Technology Neutral

Metadata represents engineering concepts.

It is independent from serialization technologies.

---

## P2 — Human Readable

Metadata should remain understandable without specialized tooling.

---

## P3 — Machine Readable

Metadata should enable validation, automation, indexing, and reporting.

---

## P4 — Minimal Core

Only universally applicable metadata belongs to the base model.

Specialized assets extend rather than modify the base model.

---

## P5 — Stable Evolution

Metadata additions should be backward compatible whenever practical.

---

# 5. Canonical Metadata Contract

Every Engineering Asset shall expose the following conceptual fields.

---

## Identity

Uniquely identifies the asset.

Required concepts:

* Asset Identifier
* Title
* Asset Type

---

## Lifecycle

Describes current engineering maturity.

Required concepts:

* Status
* Version
* Created Date
* Last Updated

---

## Ownership

Describes stewardship.

Required concepts:

* Owner
* Maintainer

Ownership represents accountability.

It does not imply authorship.

**Governance alignment:**

The Owner field maps to the **Approver** role defined in ADR-007 Section 6.

The Maintainer field maps to the **Maintainer** role defined in ADR-007 Section 6.

Every published Engineering Asset must have at least one named human Owner.

Ownership transfer requires the same governance level as the asset's decision classification (ADR-007 Section 8).

---

## Description

Provides a concise engineering summary.

Required concepts:

* Purpose
* Scope

---

## Classification

Supports discovery.

Required concepts:

* Tags
* Domain
* Capability

Classification should never affect behavior.

---

## Traceability

Supports navigation across assets.

Required concepts:

* Depends On
* Related Assets
* Supersedes
* Superseded By

Relationships are defined conceptually.

Their implementation is specified elsewhere.

---

## Governance

Supports engineering review.

Required concepts:

* Review Status
* Approval Status

Governance metadata reflects engineering process.

It never substitutes engineering review.

---

# 6. Metadata Categories

Metadata is divided into four conceptual layers.

## Layer 1 — Identity

Who am I?

---

## Layer 2 — Lifecycle

Where am I in my evolution?

---

## Layer 3 — Relationships

How do I connect with other assets?

---

## Layer 4 — Governance

Can this asset be trusted and reused?

This layered approach intentionally separates concerns.

---

# 7. Asset Extensions

Specialized assets extend the canonical metadata model.

Examples:

Skill

may define:

* Inputs
* Outputs
* Validation Strategy

Workflow

may define:

* Stages
* Entry Criteria
* Exit Criteria

Template

may define:

* Parameters
* Placeholders

ADR

may define:

* Decision
* Consequences
* Alternatives

Extensions must never redefine canonical metadata.

---

# 8. Serialization

The canonical metadata contract is technology neutral.

However, a **reference serialization format** is required to enable automation, validation, and tooling.

**Reference format: YAML front matter**

All Engineering Assets should expose metadata as a YAML front matter block at the top of the asset document.

Example structure:

```yaml
---
id: SKILL-001
title: "Feature Specification Skill"
type: Skill
status: Draft
version: 1.0.0
created: 2026-07-21
updated: 2026-07-21
owner: ""
maintainer: ""
domain: skills
tags: []
depends_on: []
related: []
supersedes: ""
superseded_by: ""
---
```

Tooling must consume the canonical model.

Alternative serialization formats (JSON, TOML) are permitted where tooling requires them, provided they represent the same canonical fields.

The YAML front matter format is the normative reference for manual authoring.

---

# 9. Validation

Metadata should support automated validation.

Typical validation rules include:

* required fields
* identifier uniqueness
* valid lifecycle state
* semantic version validity
* relationship integrity
* ownership completeness

Validation rules may evolve independently from the metadata model.

---

# 10. Automation

The metadata model enables future capabilities including:

* repository indexing
* engineering search
* dependency graphs
* impact analysis
* release notes generation
* governance dashboards
* documentation generation
* asset discovery
* orphan detection
* duplicate detection

Automation is an expected consumer of metadata.

It is not the reason metadata exists.

---

# 11. Compatibility

Metadata evolution should preserve backward compatibility.

New optional fields may be introduced without affecting existing assets.

Removing or redefining canonical fields constitutes a breaking architectural change.

Such changes require a dedicated ADR.

---

# 12. Security Considerations

Metadata must never contain:

* customer-identifiable information;
* secrets;
* credentials;
* proprietary project data;
* environment-specific configuration.

Project-specific information belongs exclusively to Context Bundles.

This rule reinforces the separation established by ADR-000.

---

# 13. Future Work

This ADR intentionally leaves open:

* serialization syntax;
* repository linting;
* metadata generators;
* metadata editors;
* visualization tools.

These capabilities will evolve independently.

---

# 14. Consequences

Positive consequences:

* consistent engineering governance;
* repository-wide discoverability;
* standardized automation;
* stronger traceability;
* reusable tooling;
* simplified repository evolution.

Trade-offs:

* additional authoring discipline;
* metadata maintenance;
* validation overhead.

These trade-offs are considered acceptable.

---

# 15. Summary

The Asset Metadata Model establishes a universal language for describing Engineering Assets.

It enables governance without coupling assets to specific tools, repositories, or technologies.

By separating engineering concepts from implementation details, the Engineering Toolkit gains a stable foundation for automation, validation, search, and long-term maintainability.

Metadata is therefore considered an architectural contract rather than a documentation convenience.
