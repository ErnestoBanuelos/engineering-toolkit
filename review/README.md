# Review

## Purpose

The Review domain contains Engineering Assets that support systematic engineering review.

---

## Responsibilities

- Provide review frameworks and lenses applicable across engineering domains.
- Define review criteria for architecture, security, business logic, and adversarial scenarios.
- Produce Review Reports as Verification Assets (ADR-009).

---

## What Belongs Here

- Seven Lenses review framework.
- Architecture review assets.
- Business review assets.
- Security review assets.
- Adversarial review assets.
- Review checklists and criteria.

---

## What Does NOT Belong Here

- Project-specific review results (those are project artifacts).
- Verification procedures that produce executable test evidence (those belong to `verification/`).
- Standards defining what should be reviewed (those belong to `standards/`).

---

## Review is a Support Domain

Review assets apply to Engineering Assets at any layer of the dependency hierarchy.

They do not sit inside the primary dependency chain.

They serve it.

---

## Related ADRs

- ADR-001 — Repository Structure (Section 4.8)
- ADR-009 — Evidence & Verification Model (Review Report evidence type)
- ADR-007 — Repository Governance (independent review requirement)
