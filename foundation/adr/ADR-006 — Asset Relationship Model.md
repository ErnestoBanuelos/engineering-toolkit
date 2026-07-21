# ADR-006 — Asset Relationship Model

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
* ADR-005 — Skill Authoring Standard

---

# 1. Context

The Engineering Toolkit is intended to evolve into a reusable engineering knowledge system rather than a static documentation repository.

As the number of Engineering Assets grows, repository organization alone becomes insufficient for understanding how assets interact.

Folders provide physical organization.

Engineering relationships provide architectural meaning.

This ADR establishes the canonical relationship model for Engineering Assets.

---

# 2. Problem Statement

Traditional repositories communicate relationships through:

* folder hierarchy;
* file names;
* hyperlinks;
* implicit conventions.

These mechanisms are insufficient for:

* dependency analysis;
* impact analysis;
* asset discovery;
* automation;
* governance;
* knowledge visualization.

A formal relationship model is required.

---

# 3. Decision

Engineering Assets shall form an explicit directed knowledge graph.

Relationships are considered first-class architectural concepts.

Repository structure is organizational.

Relationships represent engineering meaning.

---

# 4. Design Principles

## P1 — Explicit Relationships

Relationships should never rely on inference when they can be declared.

---

## P2 — Technology Neutral

Relationships describe engineering concepts rather than implementation details.

---

## P3 — Stable Identity

Relationships reference Engineering Asset identifiers rather than filenames.

---

## P4 — Minimal Coupling

Relationships should expose dependencies without increasing unnecessary coupling.

---

## P5 — Discoverability

Relationships should enable repository navigation.

---

# 5. Relationship Categories

Relationships are classified by engineering intent.

---

## Dependency

An asset requires another asset.

Example:

Workflow

↓

depends on

↓

Skill

---

## Reference

An asset cites another asset for context.

Referenced assets remain optional.

---

## Composition

An asset is built from multiple assets.

Example:

Playbook

↓

composes

↓

Skills

---

## Validation

One asset validates another.

Example:

Checklist

↓

validates

↓

Specification

---

## Generation

One asset produces another.

Example:

Skill

↓

generates

↓

Report

---

## Replacement

An asset replaces another.

Example:

ADR-008

↓

supersedes

↓

ADR-004

---

## Implementation

An asset operationalizes another.

Example:

Automation

↓

implements

↓

Standard

---

## Example

An Example demonstrates usage of another asset.

Examples are educational.

They never replace normative assets.

---

# 6. Relationship Direction

Relationships are directional.

Example:

Skill

↓

generates

↓

Template

does not imply

Template

↓

generates

↓

Skill

Direction conveys engineering meaning.

---

# 7. Relationship Integrity

Relationships should satisfy the following principles.

* targets exist;
* identifiers remain stable;
* obsolete relationships are removed;
* deprecated assets remain traceable;
* superseded assets preserve historical links.

Relationship integrity should be validated automatically whenever practical.

---

# 8. Repository Navigation

Relationships should support engineering questions including:

* What depends on this asset?
* What generated this artifact?
* What validates this output?
* What replaces this asset?
* Which assets compose this workflow?
* Which ADR governs this Skill?

The repository should eventually answer these questions automatically.

---

# 9. Dependency Rules

Dependencies should follow architectural layering.

Lower-level assets should not depend on higher-level operational assets.

Example:

Template

↓

may be used by

↓

Workflow

Workflow

should not redefine

↓

Template

This preserves separation of concerns.

---

# 10. Relationship Evolution

Relationships evolve independently from repository layout.

Renaming files should not require redesigning the knowledge graph.

Architectural meaning should remain stable.

---

# 11. Visualization

The relationship model enables future visualizations such as:

* dependency graphs;
* capability maps;
* governance maps;
* workflow diagrams;
* architecture diagrams.

Visualization is a consumer of relationships.

It is not their purpose.

---

# 12. Automation

The relationship model enables future capabilities including:

* impact analysis;
* orphan detection;
* unused asset detection;
* dependency validation;
* release planning;
* automated documentation;
* engineering search.

Automation consumes relationships.

It does not define them.

---

# 13. Compatibility

New relationship types may be introduced.

Existing relationship semantics should remain stable.

Changing relationship meaning constitutes an architectural change and requires a new ADR.

---

# 14. Anti-Patterns

The following practices are discouraged.

## Folder-Based Architecture

Folder hierarchy is not architecture.

---

## Hidden Dependencies

Undocumented relationships reduce maintainability.

---

## Cyclic Dependency

Engineering Assets should avoid cyclic relationships whenever practical.

---

## Duplicate Relationships

Relationships should have a single authoritative representation.

---

## Semantic Overloading

Each relationship should communicate one engineering meaning.

---

# 15. Consequences

Positive consequences:

* explicit engineering knowledge;
* better navigation;
* improved automation;
* stronger governance;
* dependency visualization;
* scalable repository evolution.

Trade-offs:

* relationship maintenance;
* additional metadata;
* validation complexity.

These trade-offs are intentional.

---

# 16. Future Work

Future ADRs may define:

* graph validation;
* visualization standards;
* dependency linting;
* architectural impact reports.

Relationship serialization uses the YAML front matter format established in ADR-003.

Relationships are represented as entries under the canonical metadata fields `depends_on`, `related`, `supersedes`, and `superseded_by`.

Extended relationship types beyond those four canonical fields are represented as additional YAML keys prefixed with `rel_` (e.g., `rel_validates`, `rel_generates`, `rel_implements`).

Tooling must treat unknown `rel_` keys as valid but optional relationship metadata.

---

# 17. Summary

The Asset Relationship Model transforms the Engineering Toolkit from a repository of independent documents into a connected engineering knowledge graph.

Relationships become architectural assets rather than incidental hyperlinks.

This enables future automation, governance, visualization, and engineering intelligence while preserving portability and technology independence.

The repository structure organizes assets.

The relationship model explains how engineering knowledge works.
