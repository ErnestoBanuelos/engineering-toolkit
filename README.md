# Engineering Toolkit

A vendor-agnostic AI Engineering framework that transforms engineering knowledge into reusable, versioned, verifiable, and portable engineering assets.

---

## Purpose

The Engineering Toolkit exists to solve a fundamental problem in AI-assisted software development:

Engineering knowledge becomes ephemeral.

Prompts are discarded. Conversations are lost. Decisions are forgotten. Quality drifts.

The Engineering Toolkit addresses this by treating AI-assisted engineering as an engineering discipline — not a conversational activity.

Every capability is captured as a reusable Engineering Asset.

Every decision is governed.

Every execution produces traceable evidence.

---

## Vision

> Engineering Toolkit is a vendor-agnostic AI Engineering framework that transforms engineering knowledge into reusable, versioned, verifiable, and portable engineering assets.

Its objective is not to generate code.

Its objective is to improve engineering practice.

The toolkit remains valuable regardless of AI vendor, IDE, programming language, framework, cloud provider, or customer.

---

## Core Principles

| Principle | Summary |
|---|---|
| Context Is Injectable | Reusable assets never contain project-specific knowledge. Projects supply Context Bundles. |
| Portability by Default | Every asset works across repositories, languages, frameworks, and organizations. |
| Knowledge over Prompts | The primary unit of reuse is engineering knowledge, not prompts. |
| Specification Before Implementation | Implementation begins from an explicit specification. |
| Evidence Before Trust | Engineering decisions require independent evidence. |
| Human Accountability | AI assists. Humans decide. Approval always belongs to a human. |
| Process Scales with Risk | Engineering rigor is proportional to the risk of the change. |
| Vendor Agnostic | The toolkit is independent from any AI vendor, IDE, or platform. |
| Reusability First | Every engineering activity leaves behind at least one reusable capability. |
| Continuous Improvement | Every project improves the toolkit. |

---

## Repository Domains

The repository is organized around **engineering capabilities**, not technologies or tools.

| Domain | Responsibility |
|---|---|
| `foundation/` | ADRs, governance, vision, contribution guidelines, version history |
| `context/` | Context Bundle specification and integration interfaces |
| `standards/` | Engineering policies and conventions |
| `templates/` | Reusable document templates |
| `skills/` | Reusable engineering procedures |
| `workflows/` | Sequenced engineering execution contracts |
| `playbooks/` | Decision frameworks for human-led engineering operations |
| `review/` | Engineering review assets |
| `verification/` | Verification assets and evidence producers |
| `brownfield/` | Practices for existing and legacy systems |
| `database/` | Database-specific engineering assets |
| `knowledge/` | Engineering knowledge extraction and preservation |
| `automation/` | Engineering automation and CI policies |
| `adapters/` | Technology integrations connecting capabilities to external systems |
| `examples/` | Reference implementations demonstrating recommended usage |

---

## Context Bundles

The Engineering Toolkit is intentionally project-agnostic.

Every project supplies its own **Context Bundle** — a structured, versioned collection of project-specific engineering knowledge.

The toolkit consumes Context Bundles.

It never owns them.

Context Bundles are never stored in this repository.

They belong to the consuming project.

This separation preserves portability and protects confidential project information.

The Context Bundle minimum contract is defined in `foundation/adr/ADR-011 — Context Bundle Contract.md`.

---

## AI Vendor Independence

The Engineering Toolkit is fully independent from any AI vendor or platform.

It has been designed to work with any AI assistant, agent, or tool — or without one.

Engineering assets describe capabilities.

They never describe tools.

Specific integrations are implemented as Adapters in the `adapters/` domain.

Adapters implement capabilities. They do not define them.

---

## Repository Status

This repository is currently at **Toolkit Bootstrap** phase.

The constitutional architecture (ADR-000 through ADR-011) has been established and reviewed.

The repository skeleton is in place.

Engineering Assets are ready to be authored.

---

## Architecture Overview

The architectural foundation of this toolkit is established through Architecture Decision Records (ADRs).

All ADRs are located in `foundation/adr/`.

| ADR | Title |
|---|---|
| ADR-000 | Engineering Toolkit Foundation |
| ADR-001 | Repository Structure |
| ADR-002 | Engineering Asset Model |
| ADR-003 | Asset Metadata Model |
| ADR-004 | Context Bundle Specification |
| ADR-005 | Skill Authoring Standard |
| ADR-006 | Asset Relationship Model |
| ADR-007 | Repository Governance |
| ADR-008 | Bootstrap Architecture |
| ADR-009 | Evidence & Verification Model |
| ADR-010 | Execution Architecture |
| ADR-011 | Context Bundle Contract |

ADR-000 is the constitutional foundation. All subsequent ADRs derive from it.

---

## Contribution Philosophy

Every engineering activity should leave behind at least one reusable capability.

Learning without reusable outcomes is considered incomplete.

Contributors are expected to:

- Follow the governance process defined in ADR-007.
- Author assets according to the standards defined in the relevant ADRs.
- Preserve the separation between reusable capabilities and project-specific knowledge.
- Ensure every new asset has a declared owner and passes independent review before publication.

See `CONTRIBUTING.md` for the contribution process.

---

## Roadmap

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

Immediate priorities:

- Author foundational Skills across core engineering capabilities
- Author canonical Templates (Feature Specification, ADR, Delta Specification, Replay Packet)
- Define engineering Standards
- Define initial Workflows and Playbooks
- Establish Automation for metadata validation and governance enforcement

---

## License

See `LICENSE`.
