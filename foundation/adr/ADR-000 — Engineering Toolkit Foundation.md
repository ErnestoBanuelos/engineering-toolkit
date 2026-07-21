# ADR-000 — Engineering Toolkit Foundation

**Status:** Approved

**Date:** 2026-07-21

**Version:** 1.0.0

---

# 1. Context

Large Language Models have fundamentally changed how software is developed. While they dramatically increase development speed, they also introduce new engineering risks:

* Context loss
* Prompt drift
* Hidden assumptions
* Self-validation
* Inconsistent engineering practices
* Lack of traceability
* Knowledge fragmentation
* Vendor lock-in
* Poor reproducibility

Most AI-assisted workflows focus on prompts instead of engineering systems.

As a result, valuable engineering knowledge becomes ephemeral, difficult to reuse, and impossible to audit.

This repository exists to solve that problem.

Rather than treating AI as a conversational assistant, this project treats AI-assisted software engineering as an engineering discipline.

---

# 2. Problem Statement

Modern AI workflows frequently suffer from the following anti-patterns:

* Prompt-centric development
* Project-specific knowledge embedded into reusable assets
* Missing specifications
* Missing verification
* Missing provenance
* Missing governance
* Over-reliance on individual conversations
* Poor reproducibility
* Lack of engineering standards

These practices reduce maintainability, portability, auditability, and long-term organizational learning.

The Engineering Toolkit addresses these problems by transforming engineering knowledge into reusable, versioned, and verifiable assets.

---

# 3. Vision

**Engineering Toolkit is a vendor-agnostic AI Engineering framework that transforms engineering knowledge into reusable, versioned, verifiable, and portable engineering assets.**

Its objective is not to generate code.

Its objective is to improve engineering practice.

The toolkit should remain valuable regardless of:

* AI vendor
* IDE
* Programming language
* Framework
* Cloud provider
* Customer
* Repository

---

# 4. Goals

The Engineering Toolkit aims to:

* Standardize AI-assisted engineering practices.
* Capture engineering knowledge as reusable assets.
* Improve software quality through specifications, reviews, verification, and governance.
* Separate reusable capabilities from project-specific knowledge.
* Preserve engineering decisions over time.
* Enable reproducible engineering sessions.
* Reduce onboarding effort.
* Support both greenfield and brownfield development.
* Evolve incrementally through continuous learning.

---

# 5. Non-Goals

The Engineering Toolkit is **not**:

* A prompt collection.
* A code generation framework.
* A replacement for engineering judgment.
* A replacement for software architecture.
* A customer documentation repository.
* A knowledge base containing confidential project information.
* A framework tied to a specific AI vendor.
* A replacement for CI/CD platforms.
* A replacement for engineering leadership.

Human accountability always remains in place.

---

# 6. Guiding Principles

## P1. Context Is Injectable

Reusable assets must never contain project-specific knowledge.

Every project provides its own Context Bundle.

---

## P2. Portability by Default

Every reusable asset should work across:

* repositories
* programming languages
* frameworks
* organizations

Technology-specific knowledge belongs to the Context Bundle.

---

## P3. Knowledge over Prompts

The primary unit of reuse is knowledge, not prompts.

Reusable assets include:

* Skills
* Standards
* Templates
* Checklists
* Workflows
* Playbooks
* Automation
* Decision Records

Prompts are execution mechanisms, not the product.

---

## P4. Specification Before Implementation

Implementation must begin from an explicit specification.

Specifications are living engineering contracts.

They evolve together with the software.

---

## P5. Evidence Before Trust

Engineering decisions require evidence.

Evidence may include:

* Independent tests
* Review findings
* Delta Specifications
* Replay Packets
* Provenance
* Runtime validation
* Characterization tests

Assertions without evidence are hypotheses.

---

## P6. Human Accountability

AI assists.

Humans decide.

The following decisions always require human approval:

* Production releases
* Architecture changes
* Security decisions
* Compliance exceptions
* Data migrations
* Destructive operations
* Customer commitments

---

## P7. Process Scales with Risk

Engineering rigor should be proportional to risk.

Small autocomplete suggestions do not require the same process as production database migrations.

The toolkit should optimize engineering effort while preserving safety.

---

## P8. Vendor Agnostic

The toolkit must remain independent from:

* Claude
* ChatGPT
* Gemini
* Codex
* Cursor
* GitHub Copilot

Tool integrations are adapters.

Capabilities remain stable.

---

## P9. Reusability First

Every engineering activity should leave behind at least one reusable capability.

Learning without reusable outcomes is considered incomplete.

---

## P10. Continuous Improvement

Every project should improve the toolkit.

The toolkit is a living engineering product.

---

# 7. Architectural Decisions

The following architectural decisions are established by this ADR.

## AD-001

Reusable assets and project knowledge are strictly separated.

---

## AD-002

Project knowledge is provided through Context Bundles.

---

## AD-003

Reusable assets never reference customer-specific information.

---

## AD-004

Capabilities are separated from implementations.

Examples:

* Build
* Review
* Verification
* Documentation

are capabilities.

GitHub Actions, Azure DevOps, Cursor, Claude Code, or MCP servers are implementations or adapters.

---

## AD-005

Engineering assets are version-controlled.

Engineering knowledge is treated as code.

---

## AD-006

Architecture decisions are preserved through ADRs.

History must never depend on human memory.

---

# 8. Repository Philosophy

The repository stores engineering capabilities.

It does **not** store projects.

It does **not** store customer knowledge.

It does **not** store conversations.

Instead, it stores reusable engineering assets that can be applied to many projects.

---

# 9. Context Bundle Model

Every project supplies an independent Context Bundle.

Typical contents include:

* Project overview
* Technology stack
* Architecture
* Coding standards
* Domain glossary
* Business rules
* ADR references
* Repository conventions

The toolkit consumes the Context Bundle.

It never owns it.

This separation preserves portability and protects confidential information.

---

# 10. Governance Model

Engineering governance is explicit.

The toolkit distinguishes between:

* AI-generated proposals
* Engineering review
* Human approval
* Automated enforcement

Governance exists independently from any AI model.

Policies may be enforced through:

* CI
* Repository rules
* Automation
* Manual approval

---

# 11. Asset Taxonomy

The toolkit organizes reusable knowledge into engineering capabilities.

Examples include:

* Principles
* Standards
* Templates
* Checklists
* Skills
* Workflows
* Playbooks
* Review
* Verification
* Brownfield
* Database
* Knowledge
* Automation
* Adapters
* Governance
* Documentation
* Examples

Each asset should have a single, clearly defined responsibility.

---

# 12. Versioning Strategy

The toolkit follows Semantic Versioning.

Major versions indicate architectural changes.

Minor versions introduce new reusable capabilities.

Patch versions improve existing assets without changing behavior.

Every kata completed during the learning journey should contribute to a future version of the toolkit.

---

# 13. Evolution Strategy

The toolkit evolves through continuous extraction.

The lifecycle is:

1. Learn
2. Apply
3. Review
4. Generalize
5. Extract reusable asset
6. Publish
7. Version
8. Repeat

Learning is only complete once reusable knowledge has been captured.

---

# 14. Success Criteria

The toolkit is considered successful when:

* A new project can begin without modifying the toolkit.
* Only the Context Bundle changes between projects.
* Reusable assets remain technology independent.
* No confidential customer information exists inside reusable assets.
* Engineering decisions are reproducible.
* Specifications precede implementation.
* Reviews are systematic.
* Verification produces independent evidence.
* Brownfield work is supported as a first-class workflow.
* Every completed kata contributes at least one reusable engineering asset.

---

# 15. Consequences

Adopting this architecture implies:

Positive consequences:

* Improved consistency
* Better onboarding
* Reduced engineering drift
* Stronger governance
* Better reproducibility
* Lower vendor lock-in
* Better knowledge preservation
* Higher engineering quality

Trade-offs:

* Initial investment in documentation
* Additional maintenance of engineering assets
* Governance overhead for high-risk work
* Continuous evolution rather than one-time setup

These trade-offs are intentional.

---

# 16. Canonical ADR Register

The following ADRs constitute the constitutional architecture of the Engineering Toolkit.

Each ADR extends this foundation without superseding it unless explicitly stated.

| ADR     | Title                          | Concern                                                     |
|---------|--------------------------------|-------------------------------------------------------------|
| ADR-000 | Engineering Toolkit Foundation | Vision, principles, and constitutional philosophy           |
| ADR-001 | Repository Structure           | Domain organization and dependency model                    |
| ADR-002 | Engineering Asset Model        | Universal asset abstraction, lifecycle, and categories      |
| ADR-003 | Asset Metadata Model           | Canonical metadata contract and serialization               |
| ADR-004 | Context Bundle Specification   | Context separation, lifecycle, and extensibility            |
| ADR-005 | Skill Authoring Standard       | Skill structure, composition, and quality                   |
| ADR-006 | Asset Relationship Model       | Knowledge graph, relationship types, and serialization      |
| ADR-007 | Repository Governance          | Decision authority, roles, and lifecycle governance         |
| ADR-008 | Bootstrap Architecture         | Reproducible toolkit and project initialization             |
| ADR-009 | Evidence & Verification Model  | Verification assets, evidence types, and independent review |
| ADR-010 | Execution Architecture         | Asset invocation, context binding, and output capture       |
| ADR-011 | Context Bundle Contract        | Minimum required schema and validation rules                |

ADR-000 is the constitutional foundation of the Engineering Toolkit.

Its principles are expected to remain stable over time.

Subsequent ADRs refine implementation details but preserve the philosophy established here unless explicitly superseded.

---

# 17. Engineering Deep Theory

The Engineering Toolkit is grounded in the **Engineering Deep Theory**.

The Deep Theory establishes the foundational principles from which all architectural decisions derive.

Key principles inherited from the Engineering Deep Theory:

* Context over prompts
* Human accountability
* Independent verification
* Specification-driven engineering
* Brownfield support
* Governance
* Replayability
* Provenance
* Vendor neutrality
* Process proportional to risk

Every ADR in this register must remain consistent with the Engineering Deep Theory.

When a conflict arises between an ADR and the Deep Theory, the Deep Theory takes precedence.

---

# 18. Kata Model

A **kata** is a bounded, intentional engineering practice activity.

Each kata:

* targets one specific engineering capability;
* produces at least one reusable Engineering Asset or improvement to an existing one;
* is considered incomplete until its learning is captured in the toolkit.

Katas are the primary mechanism through which the Engineering Toolkit grows.

They are not governed artifacts themselves.

Their outputs — improved or new Engineering Assets — are governed through the standard asset lifecycle defined in ADR-002.
