# ADR-011 — Context Bundle Contract

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
* ADR-008 — Bootstrap Architecture
* ADR-010 — Execution Architecture

---

# 1. Context

ADR-004 establishes the Context Bundle as the primary integration interface between projects and the Engineering Toolkit.

ADR-010 requires that a Context Bundle be bound to every Execution Unit before execution begins.

ADR-008 requires a Context Bundle as a mandatory input for project bootstrap.

However, ADR-004 intentionally deferred the definition of:

* minimum required sections;
* validation rules;
* serialization format.

Without a concrete contract, no Execution Environment can validate context, no bootstrap process can verify completeness, and no asset can declare its context requirements reliably.

This ADR defines the minimum Context Bundle contract required for v1.0 of the Engineering Toolkit.

---

# 2. Problem Statement

Without a minimum contract:

* assets cannot declare which context they require;
* execution environments cannot validate context before invocation;
* bootstrap cannot assess completeness;
* teams independently invent context structures that are incompatible across assets;
* the portability guarantee of the toolkit is compromised.

---

# 3. Decision

The Engineering Toolkit shall define a **minimum required Context Bundle contract**.

This contract defines:

* the minimum sections a Context Bundle must contain to be considered valid;
* the serialization format;
* the mechanism by which assets declare their context requirements;
* validation rules.

Organizations and projects may extend this contract.

Extensions must not remove required sections.

---

# 4. Design Principles

## C1 — Minimum Viable Contract

The contract defines the minimum necessary for the toolkit to operate.

It does not prescribe exhaustive project documentation.

---

## C2 — Extensibility

Projects extend the contract.

The toolkit ignores unknown sections rather than rejecting them.

---

## C3 — Explicit Requirements

Assets declare which context sections they require.

Consumers of a Context Bundle know in advance what they need to provide.

---

## C4 — Confidentiality by Default

Context Bundles may contain confidential information.

The contract does not prescribe access control.

It requires that reusable assets never copy Context Bundle content into themselves.

---

# 5. Minimum Required Sections

A Context Bundle is considered **valid** when it contains all of the following sections with non-empty content.

---

## CB-01 — Project Identity

Required fields:

* `name` — the project name
* `description` — a brief description of the project purpose

Purpose: enables assets to reference the project without ambiguity.

---

## CB-02 — Technology Stack

Required fields:

* `languages` — primary programming languages
* `frameworks` — primary frameworks and libraries
* `platforms` — target platforms or operating environments

Purpose: enables technology-aware Skills to adapt their procedure.

---

## CB-03 — Architecture Summary

Required content:

* A high-level description of the system architecture.
* Identification of primary bounded contexts or major components.

Purpose: enables architecture-aware assets to operate with structural awareness.

---

## CB-04 — Engineering Standards Reference

Required fields:

* `branching_strategy` — the version control branching model in use
* `review_requirements` — minimum review expectations for this project
* `testing_expectations` — expected test coverage or testing approach

Purpose: enables review and verification assets to apply project-appropriate standards.

---

## CB-05 — Domain Glossary

Required content:

* A list of domain-specific terms and their definitions.

A minimum of one entry is required.

An empty glossary is not acceptable for a valid Context Bundle.

Purpose: prevents terminology drift and enables consistent interpretation of domain language.

---

## CB-06 — Repository Conventions

Required fields:

* `folder_structure` — description or diagram of the primary folder layout
* `naming_conventions` — key naming conventions used in this project

Purpose: enables assets to generate or review artifacts consistent with project conventions.

---

# 6. Optional Sections

The following sections are optional but strongly recommended.

* Operational Knowledge (environments, deployment, monitoring)
* Stakeholders
* External References (ADRs, diagrams, runbooks)
* Business Rules and Invariants
* Integration Points

Optional sections should be included whenever the work being performed requires them.

A Skill may declare optional sections as required for its specific execution context.

---

# 7. Context Requirements Declaration

Every Engineering Asset that requires context must declare its context requirements explicitly.

Context requirements are declared in the asset's metadata using the `context_requires` field.

Example:

```yaml
context_requires:
  required:
    - CB-01
    - CB-02
    - CB-04
  optional:
    - CB-05
    - CB-06
```

Before execution, the Execution Environment (ADR-010) must verify that all required sections are present in the bound Context Bundle.

Execution must not begin if a required section is missing or empty.

---

# 8. Serialization Format

Context Bundles use the YAML front matter format established in ADR-003 for their metadata header, followed by Markdown content for each section.

Each required section is represented as a Markdown heading followed by its content.

The section identifiers (CB-01 through CB-06) serve as machine-readable section anchors.

Example structure:

```markdown
---
id: "context-bundle-projectname"
version: "1.0.0"
project: "My Project"
created: "2026-07-21"
updated: "2026-07-21"
---

# CB-01 — Project Identity

name: My Project
description: A short description of the project.

# CB-02 — Technology Stack

languages: [Python, TypeScript]
frameworks: [FastAPI, React]
platforms: [Linux, Docker]

# CB-03 — Architecture Summary

...

# CB-04 — Engineering Standards Reference

branching_strategy: trunk-based development
review_requirements: one peer review before merge
testing_expectations: 80% line coverage minimum

# CB-05 — Domain Glossary

- Event: a discrete change in system state
- Aggregate: ...

# CB-06 — Repository Conventions

folder_structure: src/ for source, tests/ for tests, docs/ for documentation
naming_conventions: snake_case for Python, camelCase for TypeScript
```

---

# 9. Validation Rules

A Context Bundle is valid when:

* all six required sections (CB-01 through CB-06) are present;
* no required section is empty;
* the metadata header is well-formed YAML;
* the `id` field is unique within the consuming repository;
* the `version` field follows semantic versioning.

Validation should be performed:

* during project bootstrap (ADR-008);
* at the start of every Execution Unit (ADR-010);
* as part of repository health checks.

---

# 10. Context Bundle Lifecycle

Context Bundles follow a lightweight lifecycle as defined in ADR-004 Section 11.

A Context Bundle version must be incremented whenever any required section changes.

Execution Environments should record the `context_bundle_id` and `context_version` in the Provenance Record (ADR-010 Section 7) to ensure that execution results remain traceable to a specific context version.

---

# 11. Confidentiality

Context Bundles may contain confidential information.

Engineering Assets must never copy Context Bundle content into reusable assets.

Context Bundles must not be committed to the Engineering Toolkit repository.

They belong to the consuming project.

This reinforces the separation established by ADR-000 and ADR-004.

---

# 12. Compatibility

Context Bundle extensions must preserve all required sections.

Toolkit version upgrades may introduce new optional sections.

Required sections may only be added or changed through an amendment to this ADR with human approval.

Removing a required section constitutes a breaking architectural change.

---

# 13. Consequences

Positive consequences:

* consistent context across all assets and execution environments;
* validated context before execution begins;
* traceable execution through context versioning;
* unambiguous bootstrap inputs;
* portable assets with declared context requirements.

Trade-offs:

* projects must maintain Context Bundles as engineering artifacts;
* initial effort to produce a compliant Context Bundle;
* maintenance overhead as projects evolve.

These trade-offs are intentional.

---

# 14. Summary

The Context Bundle Contract completes the primary integration interface of the Engineering Toolkit.

By defining the minimum required sections, serialization format, context requirements declaration mechanism, and validation rules, this ADR transforms the Context Bundle from an architectural concept into a concrete, implementable engineering contract.

Assets can now declare what they need.

Execution Environments can now validate what they receive.

Projects can now produce context that the entire toolkit can consume reliably.
