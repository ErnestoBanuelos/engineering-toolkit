---
id: TPL-CB-003
title: "Cold Context Index Template (cold/README.md)"
type: Template
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: templates
tags: [context-bundle, cold-context, knowledge-gaps, onboarding]
depends_on: [ADR-004, STD-001]
related: [TPL-CB-001, TPL-CB-002, TPL-CB-004]
supersedes: ""
superseded_by: ""
---

<!--
TEMPLATE USAGE
==============
This template produces the Cold Context index for a project's Context Bundle.

Instantiation steps:
  1. Copy this file to context/cold/README.md in the consuming project.
  2. Replace all {{PLACEHOLDER}} values with project-specific content.
  3. Keep the "What Belongs Here" section accurate as the project evolves.
  4. Do not invent history. If you cannot identify genuine gaps, say so.
  5. Remove this comment block before committing.

Do NOT commit this template to the Engineering Toolkit.
-->

# context/cold/README.md — Cold Context Index

**Purpose:** This directory holds knowledge that cannot be verified from the current
repository contents. It records historical gaps, undocumented decisions, tribal
knowledge, deprecated paths, and previous incidents that are known to be absent
from the codebase.

Cold Context is read when a new engineer joins the project, when an incident
reveals a previously unknown constraint, or when the warm context is insufficient
to answer a question. It is not assumed to be complete.

---

## What Belongs in Cold Context

### 1. Undocumented Historical Decisions

Architectural or operational choices made before documentation practices were
established, or whose rationale was never recorded. Examples for {{PROJECT_NAME}}:

- {{UNDOCUMENTED_DECISION_EXAMPLE_1}}
- {{UNDOCUMENTED_DECISION_EXAMPLE_2}}

<!--
If no specific examples are known, write:
"No specific undocumented historical decisions have been identified yet."
Do not fabricate. -->

---

### 2. Deprecated Paths

File paths, commands, conventions, or workflows that existed in an earlier version
but have since changed or been removed. Examples:

- {{DEPRECATED_PATH_EXAMPLE_1}}
- {{DEPRECATED_PATH_EXAMPLE_2}}

<!-- If no deprecated paths are known, write:
"No deprecated paths have been identified yet."
Do not fabricate. -->

---

### 3. Tribal Knowledge

Operational knowledge that was never written down and exists only in the memory of
the engineers who originally built the system. Examples:

- {{TRIBAL_KNOWLEDGE_EXAMPLE_1}}
- {{TRIBAL_KNOWLEDGE_EXAMPLE_2}}

<!-- If none identified, state so explicitly. -->

---

### 4. Previous Incidents

Operational incidents or failure modes that are not documented in the current
artefact set. Examples:

- {{INCIDENT_EXAMPLE_1}}

<!-- If no incidents are documented or known, write:
"No previous incidents have been recorded in this repository."
Do not fabricate incidents. -->

---

### 5. Undocumented Architectural Rationale

Constraints or design choices present in the codebase or specification whose
rationale is not explained. Examples:

- {{RATIONALE_GAP_1}}
- {{RATIONALE_GAP_2}}

---

## What Does NOT Belong in Cold Context

- Verified facts that can be read directly from the repository.
- Stack and technology details — those belong in `docs/context/stack.md`.
- Engineering rules and constraints — those belong in `CLAUDE.md`.
- Speculative history — do not invent gaps that cannot be genuinely identified.

---

## Files in This Directory

| File | Contents |
|---|---|
| `README.md` | This index |
| `gap-log.md` | Honest record of identified knowledge gaps |

<!-- Add rows for any additional cold-context documents created over time. -->

---

## Maintenance

Add a new entry to `gap-log.md` whenever:

- An engineer discovers a question that cannot be answered from existing documentation.
- A historical decision surfaces during an incident or review without a traceable
  rationale.
- Tribal knowledge is identified that should be captured before it is lost.

Do not close a gap entry unless the answer has been verified from a primary source
and recorded in the appropriate context layer.
