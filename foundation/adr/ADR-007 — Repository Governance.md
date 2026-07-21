# ADR-007 — Repository Governance

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

---

# 1. Context

The Engineering Toolkit is intended to become a long-lived engineering product.

Long-lived engineering products require governance.

Without governance, repositories gradually accumulate:

* duplicated assets;
* inconsistent standards;
* conflicting engineering practices;
* obsolete documentation;
* architectural drift.

Governance exists to preserve engineering quality while allowing continuous evolution.

---

# 2. Problem Statement

Engineering repositories frequently rely on implicit governance.

Examples include:

* tribal knowledge;
* maintainer memory;
* informal review;
* ad hoc decisions.

These approaches do not scale.

They reduce reproducibility and make architectural decisions difficult to audit.

The Engineering Toolkit requires explicit governance.

---

# 3. Decision

Repository governance shall be based on four principles:

* transparency;
* traceability;
* proportionality;
* human accountability.

Governance exists to improve engineering quality.

It does not exist to slow engineering.

---

# 4. Governance Principles

## G1 — Human Authority

AI may:

* draft;
* review;
* recommend;
* summarize;
* analyze.

AI shall never:

* approve architectural changes;
* approve governance changes;
* authorize releases;
* accept breaking architectural modifications.

Final authority always belongs to humans.

---

## G2 — Evidence Before Approval

Engineering decisions require evidence.

Evidence may include:

* engineering reviews;
* ADR references;
* verification assets;
* independent review;
* implementation examples;
* compatibility analysis.

Opinion alone is insufficient.

---

## G3 — Independent Review

Architectural decisions should receive an independent review whenever practical.

Independent reviewers may include:

* another engineer;
* another AI model;
* another engineering team.

Review independence improves engineering confidence.

---

## G4 — Process Scales With Risk

Governance should remain proportional.

Small editorial improvements require minimal governance.

Architectural changes require comprehensive review.

---

# 5. Governance Scope

Governance applies to:

* ADRs;
* Skills;
* Templates;
* Standards;
* Playbooks;
* Automation;
* Metadata models;
* Repository architecture.

Governance does not apply to temporary working notes.

---

# 6. Repository Roles

The repository recognizes the following conceptual roles.

These roles map directly to the metadata fields defined in ADR-003.

| Governance Role | ADR-003 Metadata Field | Description                                               |
|-----------------|------------------------|-----------------------------------------------------------|
| Approver        | `owner`                | Human authority responsible for accepting the asset       |
| Maintainer      | `maintainer`           | Human responsible for ongoing asset quality               |
| Author          | —                      | Creator of the asset (human or AI); not a governance role |
| Reviewer        | —                      | Performs engineering review; not an ownership role        |
| Contributor     | —                      | Improves assets; operates through the same governance process |

**Minimum ownership assignment rule:**

Every Engineering Asset at status **Approved** or beyond must have at least one named human in the `owner` field.

The `owner` field must never contain an AI name.

Ownership transfer requires the same decision level as the asset type (ADR-007 Section 8).

---

## Author

Creates or modifies assets.

Authors may be:

* humans;
* AI assistants.

---

## Reviewer

Performs engineering review.

Reviews focus on engineering quality.

Review does not imply approval.

---

## Approver

Provides formal acceptance.

Approval always belongs to a human authority.

Maps to the `owner` metadata field in ADR-003.

---

## Maintainer

Publishes approved assets.

Maintainers preserve repository quality.

Maps to the `maintainer` metadata field in ADR-003.

---

## Contributor

Improves existing assets.

Contributors operate through the same governance process.

---

# 7. Governance Workflow

Every significant engineering change follows the same lifecycle.

```text
Idea
    ↓
Draft
    ↓
Engineering Review
    ↓
Revision
    ↓
Independent Review
    ↓
Human Approval
    ↓
Publication
```

This workflow reflects the principles established throughout the Engineering Toolkit.

---

# 8. Decision Classification

Engineering decisions are classified by impact.

## Level 1 — Editorial

Examples:

* grammar;
* formatting;
* broken links.

Requires:

* review.

---

## Level 2 — Content

Examples:

* clarification;
* examples;
* documentation improvements.

Requires:

* engineering review.

---

## Level 3 — Engineering

Examples:

* new Skills;
* new Templates;
* workflow changes.

Requires:

* engineering review;
* independent review;
* human approval.

---

## Level 4 — Architectural

Examples:

* new ADRs;
* repository structure;
* lifecycle changes;
* governance modifications.

Requires:

* comprehensive engineering review;
* independent review;
* explicit human approval.

---

# 9. Review Expectations

Engineering reviews evaluate:

* correctness;
* completeness;
* consistency;
* architectural alignment;
* maintainability;
* portability;
* evidence quality;
* governance compliance.

Reviewers should identify both strengths and weaknesses.

---

# 10. Change Management

Repository evolution should prefer:

* extension;
* refinement;
* compatibility.

Breaking architectural changes require:

* explicit rationale;
* migration guidance;
* new ADR;
* human approval.

Architectural history should remain preserved.

---

# 11. Governance Records

Governance decisions should remain discoverable.

Typical records include:

* ADRs;
* review reports;
* approval history;
* superseded decisions.

Engineering history should never depend on personal memory.

---

# 12. Automation

Automation may support governance through:

* metadata validation;
* dependency analysis;
* repository linting;
* relationship validation;
* documentation checks;
* policy enforcement.

Automation assists governance.

It never replaces human authority.

---

# 13. Anti-Patterns

The following practices violate repository governance.

## AI Self-Approval

AI reviewing and approving its own architectural changes.

---

## Silent Architecture Changes

Changing architecture without ADRs.

---

## Missing Review

Publishing engineering assets without review.

---

## Hidden Decisions

Architectural decisions made outside repository history.

---

## Governance by Convention

Important governance existing only through unwritten expectations.

---

# 14. Compatibility

Governance should evolve conservatively.

New governance rules should preserve existing engineering assets whenever practical.

Governance evolution itself requires governance.

---

# 15. Consequences

Positive consequences:

* predictable repository evolution;
* architectural consistency;
* stronger engineering quality;
* improved auditability;
* explicit decision history;
* lower knowledge loss.

Trade-offs:

* additional review effort;
* governance overhead;
* longer architectural discussions.

These trade-offs are intentional.

---

# 16. Future Work

Future ADRs may define:

* governance automation;
* approval matrices;
* release governance;
* repository metrics;
* engineering scorecards;
* governance dashboards.

Implementation details remain intentionally outside the scope of this ADR.

---

# 17. Summary

Repository Governance establishes the decision-making framework of the Engineering Toolkit.

Governance is based on evidence, review, transparency, proportionality, and human accountability.

The objective of governance is not control.

The objective is preserving engineering quality while enabling continuous evolution.

Governance therefore becomes a reusable engineering capability rather than an organizational policy.
