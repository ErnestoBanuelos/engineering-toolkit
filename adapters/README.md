# Adapters

## Purpose

The Adapters domain contains technology integrations that connect Engineering Toolkit capabilities to external systems and platforms.

---

## Responsibilities

- Implement engineering capabilities in specific external systems.
- Connect the toolkit to repository platforms, project management tools, and CI/CD systems.
- Provide MCP server integrations and IDE extensions.

---

## What Belongs Here

- GitHub integration assets.
- Azure DevOps integration assets.
- GitLab integration assets.
- Jira integration assets.
- MCP server definitions.
- IDE extension configurations.
- Any integration that connects a capability to an external system.

---

## What Does NOT Belong Here

- Engineering policy (that belongs to `standards/`).
- Engineering capabilities (those belong to their respective domains).
- General-purpose automation not tied to a specific external system (that belongs to `automation/`).

---

## Critical Constraint

**Adapters implement capabilities. They never define them.**

If an adapter encodes engineering logic that is not already defined in a Skill or Standard, that logic must be extracted into the appropriate domain first.

An adapter is always a consumer of the toolkit.

It is never a source of architectural decisions.

---

## Vendor Neutrality

The existence of adapters does not compromise vendor neutrality.

Adapters are explicitly recognized as implementation concerns (ADR-000 AD-004).

The capabilities they implement remain stable regardless of which adapter is active.

---

## Related ADRs

- ADR-001 — Repository Structure (Section 4.14)
- ADR-000 — Engineering Toolkit Foundation (AD-004: capabilities vs implementations)
