# ADR-001 — Repository Structure

**Status:** Approved

**Date:** 2026-07-21

**Version:** 1.0.0

**Supersedes:** None

**Related ADRs:**

* ADR-000 — Engineering Toolkit Foundation

---

# 1. Context

ADR-000 establishes the Engineering Toolkit as a reusable AI Engineering framework rather than a project repository or prompt collection.

To support long-term evolution, reusable assets must be organized according to engineering responsibilities rather than implementation technologies or AI vendors.

This ADR defines the logical structure of the Engineering Toolkit.

It intentionally focuses on architectural domains rather than physical folder names, allowing implementation details to evolve without changing the repository philosophy.

---

# 2. Problem Statement

Without a clear repository structure, engineering assets tend to become:

* duplicated
* difficult to discover
* tightly coupled
* technology-specific
* inconsistent
* difficult to maintain

A repository organized by tools or projects eventually becomes an archive instead of a reusable engineering framework.

The Engineering Toolkit requires a stable information architecture that supports growth over many years.

---

# 3. Decision

The repository shall be organized around **engineering capabilities**.

Each top-level domain represents a distinct engineering responsibility.

Each asset belongs to one—and only one—primary domain.

Cross-domain references are encouraged.

Cross-domain duplication is prohibited.

---

# 4. Repository Domains

## 4.1 Foundation

Contains the documents governing the toolkit itself.

Examples:

* ADRs
* Vision
* Governance
* Contribution guidelines
* Version history
* Licensing

Purpose:

Defines how the toolkit evolves.

---

## 4.2 Context

Contains specifications describing how external Context Bundles integrate with the toolkit.

The toolkit itself never stores project-specific context.

Purpose:

Defines interfaces, not implementations.

---

## 4.3 Standards

Engineering policies and conventions.

Examples:

* Naming conventions
* Coding standards
* Documentation standards
* Review standards
* Specification standards

Purpose:

Establish engineering consistency.

---

## 4.4 Templates

Reusable document templates.

Examples:

* Feature Specification
* Delta Specification
* ADR
* Replay Packet
* Session Summary
* Runbook

Purpose:

Reduce variability while preserving engineering quality.

---

## 4.5 Skills

Reusable engineering procedures.

A Skill describes:

* objective
* inputs
* outputs
* workflow
* validation

Skills never contain project-specific knowledge.

Purpose:

Capture repeatable engineering expertise.

---

## 4.6 Workflows

Sequences of engineering activities.

Examples:

* Feature development
* Brownfield modernization
* Production incident response
* Architecture review

Purpose:

Describe how multiple assets are combined.

---

## 4.7 Playbooks

Operational guidance.

Examples:

* Greenfield development
* Brownfield development
* Emergency hotfix
* Async engineering
* Supervised engineering

Purpose:

Guide engineering decisions according to context and risk.

---

## 4.8 Review

Assets supporting engineering review.

Examples:

* Seven Lenses
* Business Review
* Architecture Review
* Security Review
* Adversarial Review

Purpose:

Improve engineering quality before implementation.

---

## 4.9 Verification

Assets producing engineering evidence.

Examples:

* Independent testing
* Characterization testing
* Property-based testing
* Regression testing
* Verification checklists

Purpose:

Demonstrate correctness through evidence.

---

## 4.10 Brownfield

Practices for existing systems.

Examples:

* Reverse engineering
* Delta specifications
* Migration planning
* Legacy assessment

Purpose:

Support safe modernization.

---

## 4.11 Database

Database-specific engineering assets.

Examples:

* SQL review
* Migration review
* Schema analysis
* Performance review

Purpose:

Address database engineering risks.

---

## 4.12 Knowledge

Engineering knowledge extraction.

Examples:

* Documentation
* Repository mining
* Incident learning
* Architecture summaries
* Impact analysis

Purpose:

Convert information into reusable engineering knowledge.

---

## 4.13 Automation

Engineering automation.

Examples:

* CI policies
* Local automation
* Bootstrap scripts
* Quality gates

Purpose:

Automate repeatable engineering work.

---

## 4.14 Adapters

Technology integrations.

Examples:

* GitHub
* Azure DevOps
* GitLab
* Jira
* MCP servers

Purpose:

Connect engineering capabilities to external systems.

Adapters must never define engineering policy.

They only implement it.

---

## 4.15 Examples

Reference implementations.

Examples:

* Sample Skills
* Sample Specifications
* Example Context Bundles

Purpose:

Demonstrate recommended usage.

Examples are educational.

They are not normative.

---

# 5. Architectural Rules

The following rules govern repository organization.

## R1

Each asset has one primary responsibility.

---

## R2

An asset belongs to one primary domain.

---

## R3

Reusable knowledge is preferred over duplicated documentation.

---

## R4

Cross-references are preferred over copies.

---

## R5

Project-specific information never belongs inside the toolkit.

---

## R6

Assets should remain vendor agnostic whenever possible.

---

## R7

Operational behavior belongs to Playbooks.

Reusable procedures belong to Skills.

Engineering policy belongs to Standards.

**The distinction between Workflows and Playbooks is architectural:**

* A **Workflow** is a sequenced, deterministic execution contract composed from Skills and Templates. It defines *what steps are executed and in what order*. It is reusable across contexts.

* A **Playbook** is a decision framework for human-led operations. It defines *how to respond to a situation* based on context and risk. It is context-dependent and may not be fully deterministic.

A Workflow may be referenced by a Playbook.

A Playbook must not be referenced by a Workflow.

This separation is intentional.

---

# 6. Dependency Model

Repository dependencies follow a directed hierarchy.

```text
Foundation
    ↓
Standards
    ↓
Templates
    ↓
Skills
    ↓
Workflows
    ↓
Playbooks
    ↓
Automation
```

**Transversal domains** — domains that provide input to any layer without themselves depending on operational layers:

* **Context** — provides project-specific input at execution time; it is consumed by Skills, Workflows, and Playbooks but never depends on them.
* **Knowledge** — extracts and stores engineering knowledge; it may reference any layer but should not alter it.

**Support domains** — domains that serve multiple layers without sitting inside the primary hierarchy:

* **Review** — applies to assets at any layer.
* **Verification** — produces evidence for assets at any layer.
* **Brownfield** — applies Skills, Templates, and Workflows to existing systems.
* **Database** — domain-specific assets that depend on Skills and Templates.
* **Adapters** — depend on Automation; they implement capabilities but never define them.
* **Examples** — depend on whichever layer they demonstrate; they are non-normative.

Engineering assets should not introduce cyclic dependencies between domains.

---

# 7. Evolution Rules

New domains should only be introduced when:

* they represent a distinct engineering capability;
* they cannot reasonably belong to an existing domain;
* they are expected to contain multiple reusable assets.

Repository growth should remain intentional.

---

# 8. Compatibility

Future repository reorganizations should preserve logical domains.

Physical folder names may evolve.

Architectural responsibilities should remain stable.

---

# 9. Consequences

Positive consequences:

* predictable repository growth;
* easier onboarding;
* reduced duplication;
* clearer ownership;
* improved discoverability;
* stronger separation of concerns.

Trade-offs:

* initial discipline required;
* occasional need to refactor asset placement;
* additional governance during repository evolution.

These trade-offs are considered acceptable.

---

# 10. Future Work

This ADR intentionally does not define:

* physical directory names;
* file naming conventions;
* asset metadata;
* Context Bundle schema;
* Skill authoring rules.

These topics are delegated to subsequent ADRs, including:

* ADR-002 — Engineering Asset Model
* ADR-003 — Asset Metadata Model
* ADR-004 — Context Bundle Specification
* ADR-005 — Skill Authoring Standard
* ADR-011 — Context Bundle Contract

---

# 11. Summary

The Engineering Toolkit repository is organized around **engineering capabilities**, not technologies, projects, or AI tools.

The repository is designed to remain stable as technologies evolve.

Logical architecture is considered part of the product itself and shall evolve through Architecture Decision Records rather than ad hoc restructuring.
