# ADR-009 — Evidence & Verification Model

**Status:** Approved

**Date:** 2026-07-21

**Version:** 1.0.0

**Supersedes:** None

**Related ADRs:**

* ADR-000 — Engineering Toolkit Foundation
* ADR-001 — Repository Structure
* ADR-002 — Engineering Asset Model
* ADR-003 — Asset Metadata Model
* ADR-005 — Skill Authoring Standard
* ADR-007 — Repository Governance

---

# 1. Context

ADR-000 Principle P5 — Evidence Before Trust — establishes that engineering decisions require evidence.

ADR-007 Principle G2 — Evidence Before Approval — requires that verification assets exist before a governance decision is made.

ADR-005 requires Skills to declare which evidence they produce.

However, no ADR defines what constitutes valid engineering evidence, how evidence is structured, or how it relates to Engineering Assets.

Without this definition, P5 remains a statement of intent rather than an architectural capability.

This ADR completes that capability.

---

# 2. Problem Statement

Engineering claims without verification mechanisms produce:

* undetectable errors;
* false confidence;
* ungovernable quality;
* non-reproducible results;
* audit failures.

The Engineering Toolkit requires a formal model for producing, recording, and tracing engineering evidence.

---

# 3. Decision

The Engineering Toolkit shall define a canonical **Evidence & Verification Model**.

Every Verification Asset is an Engineering Asset as defined in ADR-002.

Verification evidence is always independent from the asset it verifies.

Self-validation is explicitly prohibited.

---

# 4. Definition

A **Verification Asset** is:

> **A structured engineering artifact that provides independent evidence that another Engineering Asset satisfies its stated purpose.**

Verification Assets are produced by Skills and Workflows.

They are consumed by Governance (ADR-007) as evidence for approval decisions.

---

# 5. Evidence Types

The following evidence types are recognized by the Engineering Toolkit.

---

## Independent Test

Software tests authored independently from the implementation they verify.

Includes:

* unit tests
* integration tests
* end-to-end tests
* property-based tests
* characterization tests

---

## Review Report

A structured engineering review of an asset, produced by a reviewer independent from the author.

Includes:

* Seven Lenses review
* Architecture review
* Security review
* Adversarial review
* Business review

---

## Checklist Result

A completed engineering checklist with disposition on each criterion.

A checklist result is only valid when every item has been explicitly evaluated.

Unanswered items do not constitute passing evidence.

---

## Delta Specification

A specification describing what changed between two versions of a system or asset.

Provides traceability between prior and current state.

---

## Replay Packet

A structured record sufficient to reproduce an engineering session or execution.

A Replay Packet includes:

* the Engineering Assets used;
* the Context Bundle version;
* the inputs provided;
* the outputs produced;
* the human decisions made.

Replay Packets support replayability as required by the Engineering Deep Theory.

---

## Characterization Test

Tests that capture the current behavior of an existing system before modification.

Used in Brownfield engineering to establish a safety baseline.

---

## Verification Report

A structured summary of evidence gathered, including:

* which assets were verified;
* which evidence types were used;
* outcomes;
* outstanding risks;
* human decisions required.

---

# 6. Independence Requirement

Evidence must be produced independently from the asset it verifies.

An author may not provide the sole verification of their own asset.

Independent verification may be provided by:

* another engineer;
* another AI model operating with a separate context;
* automated tooling with no authoring relationship to the asset.

This rule implements ADR-007 G3 — Independent Review.

---

# 7. Verification Asset Structure

Every Verification Asset shall include the following conceptual sections.

## Subject

The Engineering Asset being verified.

Referenced by asset identifier as defined in ADR-002.

---

## Evidence Type

One of the canonical evidence types defined in Section 5.

---

## Verification Outcome

One of:

* **Pass** — The asset satisfies its stated purpose based on the evidence gathered.
* **Pass with Conditions** — The asset satisfies its purpose subject to specific conditions.
* **Fail** — The asset does not satisfy its stated purpose.
* **Inconclusive** — Evidence gathered is insufficient to reach a conclusion.

---

## Evidence Summary

A description of the evidence gathered and the method used.

---

## Human Decisions Required

Any decisions that cannot be resolved through engineering evidence alone and require explicit human approval.

---

# 8. Relationship to Governance

Verification Assets are required evidence for governance approval decisions.

| ADR-007 Decision Level | Minimum Verification Requirement                             |
|------------------------|--------------------------------------------------------------|
| Level 1 — Editorial    | None required                                                |
| Level 2 — Content      | One Review Report                                            |
| Level 3 — Engineering  | One Review Report + one independent review                   |
| Level 4 — Architectural| Comprehensive Review Report + independent review + human sign-off |

These requirements represent the minimum.

Approvers may require additional evidence based on risk.

---

# 9. Verification Asset Lifecycle

Verification Assets follow the Engineering Asset lifecycle defined in ADR-002.

Verification Assets are produced at the **In Review** stage.

They are required before an asset may transition to **Approved**.

---

# 10. Provenance

Every Verification Asset must record:

* the asset identifier of the subject;
* the version of the subject verified;
* the evidence type used;
* the date of verification;
* the identity of the verifier (human or AI with identifier).

Provenance ensures verification results remain traceable throughout the asset lifecycle.

---

# 11. Replayability

Replay Packets are the primary mechanism for replayability.

A Replay Packet must be sufficient to reproduce the same engineering outcome given the same inputs.

Replay Packets do not guarantee identical AI output.

They guarantee that the engineering process can be re-executed with the same architectural inputs.

---

# 12. Anti-Patterns

The following practices violate the Evidence & Verification Model.

## Self-Validation

An author verifying their own asset is not independent verification.

---

## Opinion as Evidence

Assertions without supporting artifacts or test results do not constitute evidence.

---

## Missing Provenance

Verification without a recorded subject, version, date, and verifier cannot be audited.

---

## Incomplete Checklist

A checklist with unanswered items does not constitute a passing result.

---

## Verification Theater

Creating Verification Assets that satisfy form without performing genuine verification.

---

# 13. Automation

The verification model enables future automation including:

* test execution reports;
* checklist generators;
* review report templates;
* replay packet recorders;
* verification dashboards.

Automation assists verification.

It does not replace independent engineering judgment.

---

# 14. Consequences

Positive consequences:

* explicit engineering evidence;
* stronger governance;
* improved reproducibility;
* better auditability;
* traceable quality history;
* replayable engineering sessions.

Trade-offs:

* additional authoring effort;
* verification overhead;
* governance discipline required.

These trade-offs are intentional.

---

# 15. Summary

The Evidence & Verification Model operationalizes Principle P5 of ADR-000.

It defines what constitutes valid engineering evidence, how evidence is structured, and how it connects to governance approval decisions.

Verification Assets are first-class Engineering Assets.

They are the mechanism through which the Engineering Toolkit transforms engineering claims into auditable, reproducible, and traceable engineering facts.
