# Verification

## Purpose

The Verification domain contains Engineering Assets that produce independent engineering evidence.

Evidence is the mechanism through which the Engineering Toolkit demonstrates correctness rather than merely asserting it.

---

## Responsibilities

- Provide verification procedures and checklists.
- Define how independent testing is conducted.
- Produce Verification Assets as defined in ADR-009.
- Support replayability through Replay Packet structures.

---

## What Belongs Here

- Independent testing procedures.
- Characterization testing procedures.
- Property-based testing guidelines.
- Regression testing procedures.
- Verification checklists.
- Replay Packet templates.
- Verification Report templates.

---

## What Does NOT Belong Here

- Review assets (those belong to `review/`).
- Automation that runs tests (that belongs to `automation/`).
- Project-specific test suites or test results (those are project artifacts).
- Context Bundles.

---

## Verification is a Support Domain

Verification assets apply to Engineering Assets at any layer.

They produce evidence for governance decisions (ADR-007 requires evidence before approval).

---

## Related ADRs

- ADR-009 — Evidence & Verification Model
- ADR-000 — Engineering Toolkit Foundation (Principle P5: Evidence Before Trust)
- ADR-007 — Repository Governance (G2: Evidence Before Approval)
- ADR-010 — Execution Architecture (provenance and replay)
