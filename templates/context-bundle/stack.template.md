---
id: TPL-CB-002
title: "Warm Context Template (stack.md)"
type: Template
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: templates
tags: [context-bundle, warm-context, technology-stack, architecture, verification]
depends_on: [ADR-004, ADR-011, STD-001, STD-002]
related: [TPL-CB-001, TPL-CB-003, TPL-CB-004]
supersedes: ""
superseded_by: ""
---

<!--
TEMPLATE USAGE
==============
This template produces the Warm Context layer (CB-02, CB-03, CB-06) of a project's
Context Bundle.

Instantiation steps:
  1. Copy this file to docs/context/stack.md in the consuming project.
  2. Replace all {{PLACEHOLDER}} values with project-specific content.
  3. For every factual claim: verify against the source and record the evidence
     (file + line number). See STD-002 — Verification Evidence Standard.
  4. For claims that cannot be verified: mark them explicitly as **Unverified**
     and state the reason.
  5. Remove this comment block before committing.

Never fabricate. Never guess. Mark unknowns explicitly.
Do NOT commit this template to the Engineering Toolkit.
-->

# docs/context/stack.md — Warm Context

**Purpose:** Stable technical reference for the project stack, repository structure,
and architectural constraints.

**Last verified:** {{VERIFICATION_DATE}}

---

## Language(s)

<!-- Verify each claim against source files, CI config, or package manifests.
     Record evidence as: File / Line. -->

| Language | Role | Verified |
|---|---|---|
| {{LANGUAGE_1}} | {{ROLE_1}} | {{EVIDENCE_1}} |
| {{LANGUAGE_2}} | {{ROLE_2}} | {{EVIDENCE_2}} |

<!-- Add rows as needed. Mark any unverifiable entry as: Unverified — <reason> -->

---

## Framework(s)

| Framework | Role | Verified |
|---|---|---|
| {{FRAMEWORK_1}} | {{ROLE_1}} | {{EVIDENCE_1}} |
| {{FRAMEWORK_2}} | {{ROLE_2}} | {{EVIDENCE_2}} |

<!-- If a framework cannot be identified from the artefacts, mark Unverified. -->

---

## Build System

| Tool | Role | Verified |
|---|---|---|
| {{BUILD_TOOL}} | {{ROLE}} | {{EVIDENCE}} |

---

## Package Manager

| Tool | Role | Verified |
|---|---|---|
| {{PACKAGE_MANAGER}} | {{ROLE}} | {{EVIDENCE}} |

---

## Test Runner

| Tool | Role | Verified |
|---|---|---|
| {{TEST_RUNNER}} | {{ROLE}} | {{EVIDENCE}} |

<!-- Example verification: "Yes — ci.yml line 59: run: pytest tests/" -->

---

## Repository Layout

<!-- Verify against actual directory listing. Replace the tree below with the
     actual structure. -->

```
{{PROJECT_ROOT}}/
├── {{DIR_OR_FILE_1}}     # {{DESCRIPTION_1}}
├── {{DIR_OR_FILE_2}}     # {{DESCRIPTION_2}}
└── {{DIR_OR_FILE_3}}     # {{DESCRIPTION_3}}
```

---

## Architectural Style

<!-- Describe the high-level architectural pattern: microservice, monolith,
     event-driven, read-only agent, CLI tool, library, etc. -->

{{ARCHITECTURAL_STYLE_DESCRIPTION}}

| Property | Value | Verified |
|---|---|---|
| {{PROPERTY_1}} | {{VALUE_1}} | {{EVIDENCE_1}} |
| {{PROPERTY_2}} | {{VALUE_2}} | {{EVIDENCE_2}} |

---

## Engineering Conventions

<!-- List the important project-specific conventions that differ from defaults
     or that would not be obvious to a new engineer. These are facts, not rules.
     Rules belong in CLAUDE.md (Hot Context). -->

1. {{CONVENTION_1}}
2. {{CONVENTION_2}}
3. {{CONVENTION_3}}

<!-- Cite the source for each convention where possible. -->

---

## Verified Architectural Constraint

<!-- Select one architectural constraint that is both important and directly
     verifiable from the repository. Record full verification evidence. -->

**Claim:** {{CONSTRAINT_STATEMENT}}

| Field | Value |
|---|---|
| Evidence | {{EVIDENCE_TEXT}} |
| File | {{EVIDENCE_FILE}} |
| Line | {{EVIDENCE_LINE}} |

**Verification status:** {{CONFIRMED or FAILED — correction made}}

<!-- If verification fails, correct the claim to match the evidence.
     Document what was changed and why. -->

---

## Verification Summary

<!-- Collect all primary verifications in one place for auditability.
     Use this section if inline evidence becomes verbose. -->

| Claim | Evidence | File | Line |
|---|---|---|---|
| {{CLAIM_1}} | {{EVIDENCE_1}} | {{FILE_1}} | {{LINE_1}} |
| {{CLAIM_2}} | {{EVIDENCE_2}} | {{FILE_2}} | {{LINE_2}} |

<!-- Remove rows that are already documented inline above.
     This table should only contain claims not documented elsewhere. -->
