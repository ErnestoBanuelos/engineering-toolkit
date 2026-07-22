---
id: STD-002
title: "Verification Evidence Standard"
type: Standard
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: standards
tags: [verification, evidence, documentation, traceability, warm-context]
depends_on: [ADR-009]
related: [STD-001, TPL-CB-001]
supersedes: ""
superseded_by: ""
---

# STD-002 — Verification Evidence Standard

## 1. Purpose

This standard defines how factual claims in engineering documentation are verified,
recorded, and maintained.

A factual claim is any statement that asserts something about the current state of a
project: a technology version, a file path, a configuration value, a dependency, an
architectural constraint, or a behavioural property.

Claims that cannot be independently verified must be explicitly labelled. Claims that
are verified must record the evidence so the verification can be audited and repeated.

This standard operationalises ADR-000 Principle P5 — Evidence Before Trust — at the
documentation layer.

---

## 2. Scope

This standard applies to:

- factual claims in Context Bundle documents (Warm Context and Hot Context);
- factual claims in Engineering Asset documentation;
- any claim used as the basis for an architectural decision or engineering review.

This standard does not apply to:

- deliberate rule statements ("must", "shall", "never") — these are policies, not claims;
- forward-looking intent ("we plan to...") — these are design notes, not facts;
- examples marked explicitly as illustrative.

---

## 3. Evidence Requirement

Every factual claim in engineering documentation that can be verified against an
artefact must be verified.

**Verified** means: the claim has been checked against a primary source (source file,
configuration, test output, or other durable artefact) and the evidence has been
recorded.

**Unverified** means: the claim could not be checked at the time of authoring. The
reason must be stated.

A claim that is neither verified nor explicitly marked Unverified is a documentation
defect.

---

## 4. Required Evidence Fields

When recording a verification, include all of the following fields:

| Field | Required | Description |
|---|---|---|
| **Claim** | Yes | The exact statement being verified, verbatim or paraphrased |
| **Evidence** | Yes | The specific text, value, or artefact that supports the claim |
| **File** | Yes | The path to the source file containing the evidence |
| **Line** | Yes (when applicable) | The line number(s) where the evidence appears |
| **Verified by** | Recommended | The engineer or AI reviewer who performed the verification |
| **Verified on** | Recommended | The date of verification |

If a line number is not applicable (e.g., the evidence is a directory structure,
a binary file property, or an environment output), state the reason and provide an
alternative locator.

---

## 5. Verification Record Format

Use the following format when embedding verification evidence inline in a document:

```
Claim:       <the statement being verified>
Evidence:    <the specific text or value observed>
File:        <relative path to the source file>
Line:        <line number, or "N/A — <reason>" if not applicable>
```

**Inline example (abbreviated):**

```
Claim:       The application runtime is Python 3.11
Evidence:    python-version: "3.11"
File:        .github/workflows/ci.yml
Line:        53
```

For documentation sections with many verifiable claims (e.g., a technology stack
document), collect all verifications in a dedicated Verification Summary section
rather than annotating inline.

---

## 6. Acceptable Evidence

The following constitute acceptable verification evidence:

| Evidence type | Acceptable when |
|---|---|
| Source file content (line reference) | The claim directly corresponds to text in a committed file |
| Configuration file value | The claim asserts a configuration setting present in a config file |
| Test or CI output | The claim asserts a runtime or build-time property provable from test/CI results |
| Directory structure listing | The claim asserts the presence or absence of a directory or file |
| Package manifest entry | The claim asserts a declared dependency (e.g., `requirements.txt`, `package.json`) |
| ADR or specification text | The claim restates a decision already recorded in an authoritative document |
| Run log or execution trace | The claim asserts behaviour observed during a recorded execution |

---

## 7. Unacceptable Evidence

The following do not constitute acceptable verification evidence:

| Unacceptable form | Reason |
|---|---|
| "Common knowledge" or "industry standard" | Cannot be traced to the specific project artefact |
| AI-generated assertion without source | Self-referential; not independent |
| Memory or tribal knowledge | Cannot be audited |
| Prior documentation without a primary source | Circular; a document cannot verify itself |
| Inference ("it probably uses X because Y") | Inference is a hypothesis, not evidence |
| Absence of evidence for a positive claim | Silence does not confirm presence |

---

## 8. Handling Unverified Claims

When a claim cannot be verified at the time of documentation:

1. Include the claim if it is relevant and plausible.
2. Append the label **Unverified** immediately after the claim.
3. State the reason the claim could not be verified.
4. Record it as an open gap in the Cold Context gap log.

**Example:**

```
The service uses FastAPI as its HTTP framework. **Unverified** — no application
source files are present in this repository. The framework would need to be confirmed
from the application repository's dependency manifest.
```

Unverified claims must never appear in Hot Context. They are permitted in Warm
Context with the label. They are expected in Cold Context gap entries.

---

## 9. Verification Workflow

Follow these steps when documenting a factual claim:

**Step 1 — State the claim.**
Write the claim as a declarative statement: "The language runtime is X", "Tests
are run using Y", "The deployment target is Z."

**Step 2 — Identify the primary source.**
Determine which artefact would contain evidence for or against this claim.
Typical sources: source files, configuration files, CI/CD definitions, package
manifests, ADRs, run logs.

**Step 3 — Locate the evidence.**
Find the specific text, value, or structure in the identified source.

**Step 4 — Record the evidence.**
Using the required fields from Section 4, record: claim, evidence, file, line.

**Step 5 — Handle failure.**
If the source does not exist, or the claim is contradicted by the source:
- Correct the claim to match the evidence.
- If the claim is genuinely uncertain, mark it Unverified.
- If the claim is demonstrably false, remove it.

**Step 6 — Add to the gap log if unverifiable.**
If verification cannot be completed, open a gap entry in Cold Context.

---

## 10. Verification in Context Bundles

Warm Context is the primary location where verification evidence is recorded for
a project's Context Bundle.

Every factual claim in a Warm Context document (e.g., `stack.md`) must be either:

- verified with evidence fields (claim, evidence, file, line), or
- explicitly labelled **Unverified** with a stated reason.

A Warm Context document that contains unverified claims without labels is a
documentation defect (see STD-001 — Context Layer Decision Standard, Section 6,
Rule B2).

---

## 11. Maintenance

Verification evidence becomes stale when:

- the underlying source file changes;
- a dependency version is updated;
- a configuration is modified;
- the repository structure changes.

Stale verification evidence is misleading. It is preferable to mark a claim
Unverified and re-verify than to retain outdated evidence.

Trigger a verification review when:
- a CI/CD pipeline changes;
- a language or framework version is updated;
- a dependency is added or removed;
- the repository layout changes significantly.

---

## 12. Anti-Patterns

| Anti-pattern | Problem | Correction |
|---|---|---|
| "Verified" with no evidence recorded | Creates false confidence; cannot be audited | Record file and line |
| Claiming a default value without checking | Defaults change across versions | Check and record the specific source |
| Treating documentation as a primary source | A document verifying a document is circular | Trace to source code or config |
| Skipping verification for "obvious" facts | Obvious facts are often wrong or stale | Verify and record |
| Updating documentation without re-verifying | Propagates stale evidence | Re-verify whenever the underlying system changes |

---

## 13. Relationship to ADRs

| ADR | Relationship |
|---|---|
| ADR-000 P5 — Evidence Before Trust | Constitutional basis for this standard |
| ADR-009 — Evidence & Verification Model | Defines the broader verification model; this standard applies it to documentation |
| ADR-004 — Context Bundle Specification | Warm Context is the primary documentation target of this standard |
| ADR-011 — Context Bundle Contract | CB-02 (Technology Stack) and CB-03 (Architecture) require verifiable facts |

---

## 14. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.1 kata execution |
