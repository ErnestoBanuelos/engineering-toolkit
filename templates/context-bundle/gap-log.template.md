---
id: TPL-CB-004
title: "Gap Log Template (cold/gap-log.md)"
type: Template
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: templates
tags: [context-bundle, cold-context, knowledge-gaps, gap-log]
depends_on: [ADR-004, STD-001, WF-001]
related: [TPL-CB-001, TPL-CB-002, TPL-CB-003]
supersedes: ""
superseded_by: ""
---

<!--
TEMPLATE USAGE
==============
This template produces the gap log for a project's Cold Context layer.

Instantiation steps:
  1. Copy this file to context/cold/gap-log.md in the consuming project.
  2. Replace all {{PLACEHOLDER}} values.
  3. Add genuine knowledge gaps identified during the Context Bundle bootstrap.
  4. Follow the format of the example gap entries below.
  5. Remove template instructions (this comment block and all HTML comments)
     before committing.
  6. The minimum is three honest gaps. If fewer than three genuine gaps exist,
     state that explicitly — do not fabricate.

Gap status values: OPEN | PARTIAL | CLOSED
Gap categories:
  - Undocumented historical decision
  - Undocumented architectural rationale
  - Tribal knowledge
  - Deprecated path
  - Previous incident
  - Operational gap

Do NOT commit this template to the Engineering Toolkit.
-->

# context/cold/gap-log.md — Knowledge Gap Log

**Purpose:** An honest record of knowledge gaps in this project. Gaps are things
that cannot be answered from the current artefacts, documentation, or commit
history. They are recorded so they can be investigated and resolved — not
fabricated.

**Last reviewed:** {{LAST_REVIEW_DATE}}

---

## Gap Status Key

| Status | Meaning |
|---|---|
| OPEN | Gap identified; no answer yet |
| PARTIAL | Some information available; full answer still missing |
| CLOSED | Gap resolved; answer recorded in designated location |

---

<!-- EXAMPLE GAP — copy this block and replace values for each new gap.
     Delete this comment and the "EXAMPLE" labels before committing. -->

## GAP-001 — {{GAP_TITLE}}

**Status:** {{OPEN | PARTIAL | CLOSED}}
**Category:** {{CATEGORY}}
**Identified:** {{DATE}}

**Description:**
{{GAP_DESCRIPTION}}

<!-- Be specific. State what information is missing and why it matters.
     Do not invent history. If you are speculating, say so. -->

**Why this matters:**
{{WHY_THIS_GAP_MATTERS}}

**What would close this gap:**
{{WHAT_EVIDENCE_OR_ACTION_WOULD_CLOSE_IT}}

**Where to record the answer:**
{{TARGET_DOCUMENT_OR_SECTION_ONCE_RESOLVED}}

---

## GAP-002 — {{GAP_TITLE}}

**Status:** {{OPEN | PARTIAL | CLOSED}}
**Category:** {{CATEGORY}}
**Identified:** {{DATE}}

**Description:**
{{GAP_DESCRIPTION}}

**Why this matters:**
{{WHY_THIS_GAP_MATTERS}}

**What would close this gap:**
{{WHAT_EVIDENCE_OR_ACTION_WOULD_CLOSE_IT}}

**Where to record the answer:**
{{TARGET_DOCUMENT_OR_SECTION_ONCE_RESOLVED}}

---

## GAP-003 — {{GAP_TITLE}}

**Status:** {{OPEN | PARTIAL | CLOSED}}
**Category:** {{CATEGORY}}
**Identified:** {{DATE}}

**Description:**
{{GAP_DESCRIPTION}}

**Why this matters:**
{{WHY_THIS_GAP_MATTERS}}

**What would close this gap:**
{{WHAT_EVIDENCE_OR_ACTION_WOULD_CLOSE_IT}}

**Where to record the answer:**
{{TARGET_DOCUMENT_OR_SECTION_ONCE_RESOLVED}}

---

<!-- Add additional GAP-NNN blocks as new gaps are identified.
     Number gaps sequentially. Never reuse a gap number. -->

---

## Gap Summary

| Gap | Category | Status | Priority |
|---|---|---|---|
| GAP-001 | {{CATEGORY}} | {{STATUS}} | {{High / Medium / Low}} |
| GAP-002 | {{CATEGORY}} | {{STATUS}} | {{High / Medium / Low}} |
| GAP-003 | {{CATEGORY}} | {{STATUS}} | {{High / Medium / Low}} |

<!-- Update this table whenever a gap is added or its status changes.
     Priority:
       High   — operational blocker; must be resolved before next production event
       Medium — affects engineering quality; resolve within two sprints
       Low    — informational; resolve opportunistically -->
