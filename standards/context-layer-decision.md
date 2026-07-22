---
id: STD-001
title: "Context Layer Decision Standard"
type: Standard
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: standards
tags: [context, context-bundle, hot-context, warm-context, cold-context, information-architecture]
depends_on: [ADR-004, ADR-011]
related: [STD-002, TPL-CB-001]
supersedes: ""
superseded_by: ""
---

# STD-001 — Context Layer Decision Standard

## 1. Purpose

This standard defines the decision rules for placing engineering information into the
correct layer of a project's Context Bundle.

A Context Bundle is divided into three layers that differ in volatility, audience,
and loading priority:

| Layer | Informal name | Volatility | Primary audience |
|---|---|---|---|
| Hot Context | `CLAUDE.md` or equivalent | Low — rarely changes | AI assistant loaded at every session |
| Warm Context | `docs/context/stack.md` or equivalent | Medium — evolves with project | Engineers and AI during active work |
| Cold Context | `context/cold/` or equivalent | Variable — grows over time | Engineers onboarding; incident response |

Correct layer placement reduces context window pollution, prevents stale information
from influencing active decisions, and ensures that knowledge is discoverable at the
moment it is needed.

---

## 2. Scope

This standard applies to:

- any project adopting the Engineering Toolkit Context Bundle model (ADR-004, ADR-011);
- any engineer authoring or reviewing Context Bundle content;
- any AI assistant operating with a loaded Context Bundle.

This standard does not govern the content of the Engineering Toolkit itself. The
toolkit stores reusable capabilities; project-specific knowledge belongs exclusively
to the project's Context Bundle.

---

## 3. Layer Definitions

### 3.1 Hot Context

**Purpose:** Provide permanent behavioural rules and non-negotiable engineering
constraints that must be active at the start of every session.

**Characteristics:**

- Loaded first, every time, without exception.
- Minimal — every line must earn its place.
- Contains rules, not facts.
- Technology-agnostic — no specific library names, versions, or file paths.
- Durable — changes are rare and require justification.

**Maximum size guidance:** One screen (approximately 80 lines of text). If content
exceeds this limit, it belongs in Warm Context or lower.

**Canonical location in a project:** `CLAUDE.md` (or equivalent AI instruction file).

---

### 3.2 Warm Context

**Purpose:** Provide stable reference knowledge that informs active engineering
work — the technology stack, architectural patterns, repository conventions, and
verified constraints.

**Characteristics:**

- Loaded when work requires structural or technical awareness.
- More detailed than Hot Context; may span several pages.
- Contains verified facts about the project, not rules.
- Should be kept in sync with the actual project state.
- Stale Warm Context is actively harmful — verify claims before including them.

**Canonical location in a project:** `docs/context/stack.md` or equivalent.

---

### 3.3 Cold Context

**Purpose:** Preserve engineering knowledge that cannot be verified from current
artefacts — historical decisions, knowledge gaps, tribal knowledge, and incident
history.

**Characteristics:**

- Not loaded by default; consulted on demand.
- Contains explicitly uncertain or historically contingent information.
- Gaps must be recorded honestly; fabrication is prohibited.
- Every gap entry should state what would be required to close it.

**Canonical location in a project:** `context/cold/` directory with a `README.md`
index and `gap-log.md` record.

---

## 4. Decision Criteria

Apply these questions in order to determine the correct layer.

### Question 1 — Is this a rule or a fact?

| Answer | Direction |
|---|---|
| It is a permanent behavioural rule or constraint | → Hot Context |
| It is a verifiable fact about the project | → Warm Context |
| It is uncertain, historical, or unverifiable from current artefacts | → Cold Context |

---

### Question 2 — Would this information change the behaviour of an AI session if absent?

| Answer | Direction |
|---|---|
| Yes — the session would produce unsafe or incorrect outputs without it | → Hot Context |
| Yes — the session would make uninformed architectural decisions without it | → Warm Context |
| No — it is reference information for onboarding or incident investigation | → Cold Context |

---

### Question 3 — Can this information be verified against the current repository?

| Answer | Direction |
|---|---|
| No verification needed — it is a policy statement | → Hot Context |
| Yes — verified against source files, config, or tests | → Warm Context |
| No — cannot be verified; may be historical or tribal | → Cold Context |

If a claim cannot be verified and is placed in Warm Context, it must be explicitly
marked **Unverified**. Unverified claims in Hot Context are not permitted.

---

### Question 4 — How often does this information change?

| Answer | Direction |
|---|---|
| Rarely — stable across project lifetime | Hot Context (if rule) or Warm Context |
| Occasionally — updates as the project evolves | Warm Context |
| Unknown or historically variable | Cold Context |

---

### Question 5 — What is the size of this content?

| Answer | Direction |
|---|---|
| One to three sentences; a rule or a single constraint | → Hot Context |
| A table, a structured list, or a paragraph | → Warm Context |
| A historical narrative, a gap analysis, or an open question | → Cold Context |

---

## 5. Examples

### Correct Placements

| Information | Layer | Reasoning |
|---|---|---|
| "Produce exactly three hypotheses per diagnosis" | Hot | Behavioural rule; must always be active |
| "Unknown information must be stated as `UNKNOWN — owner needed`" | Hot | Safety constraint; must never be absent |
| "Language: Python 3.11 (verified: `ci.yml` line 53)" | Warm | Verified fact about the stack |
| "Test runner: pytest (verified: `ci.yml` line 59)" | Warm | Verified technical fact |
| "Repository layout: `src/`, `tests/`, `docs/`" | Warm | Structural reference |
| "Checklist origin: unknown — no source standard cited" | Cold | Unverifiable; honest gap |
| "Pre-v1.0 design history: not documented" | Cold | Historical gap; cannot be verified |
| "Pager tool and on-call identity: undefined" | Cold | Operational gap; known unknown |

---

### Anti-Patterns (Incorrect Placements)

| Anti-pattern | Problem | Correction |
|---|---|---|
| Stack version numbers in Hot Context | Pollutes Hot with facts that change; exceeds size budget | Move to Warm Context |
| Fabricated history in Cold Context | Violates the honesty requirement for cold context | Remove; record as OPEN gap |
| Unverified technical facts in Warm Context without marking | Creates false confidence | Mark explicitly as **Unverified** |
| Permanent rules buried in Warm Context | Rules may not be loaded when needed | Promote to Hot Context |
| Cold Context containing implementation instructions | Warm or Hot is the correct layer for actionable guidance | Reclassify to appropriate layer |
| Knowledge gaps in Hot Context | Hot Context is for rules, not gaps | Move gap to Cold Context |
| Project-specific content in the Engineering Toolkit | Violates ADR-000 P1 and ADR-004 | Keep in project's Context Bundle |

---

## 6. Boundary Rules

The following rules are not subject to interpretation. They derive directly from the
ADR constitutional architecture.

**B1:** Hot Context must never contain stack-specific facts (language versions, library
names, file paths). These belong in Warm Context. (ADR-004 P2 — Portability by Default)

**B2:** Warm Context must never contain information that cannot be verified or that is
explicitly marked as uncertain without an **Unverified** label. (ADR-009 P5 — Evidence
Before Trust)

**B3:** Cold Context must never fabricate history. Every entry must be a genuine,
identifiable gap. (ADR-000 AD-003 — Assets never reference customer-specific information
by invention)

**B4:** No layer may contain project-specific information inside a reusable Engineering
Asset. The Context Bundle itself belongs to the project. (ADR-000 P1 — Context Is
Injectable)

**B5:** When a claim can be verified, it must be verified before being placed in Warm
Context. Record the evidence (file, line). (ADR-009 — Evidence & Verification Model)

---

## 7. Review Checklist

Use this checklist when reviewing a Context Bundle for correct layer placement.

```
Hot Context Review
□ Every entry is a rule or constraint, not a fact
□ No stack versions, library names, or file paths are present
□ Total line count is within the defined maximum (guidance: 80 lines)
□ Every rule would cause incorrect behaviour if absent
□ No duplicates with Warm Context entries

Warm Context Review
□ Every factual claim is either verified (with evidence) or marked Unverified
□ No permanent behavioural rules are present (those belong in Hot)
□ No historical gaps or unverifiable knowledge (those belong in Cold)
□ Content reflects the current state of the project
□ Stack, layout, conventions, and architectural constraints are all present

Cold Context Review
□ README.md explains what belongs in Cold Context
□ gap-log.md contains only genuine, identifiable gaps
□ No fabricated history is present
□ Every gap states what would be required to close it
□ High-priority operational gaps are flagged appropriately
□ No entry duplicates verified information already in Warm Context
```

---

## 8. Relationship to ADRs

| ADR | Relationship |
|---|---|
| ADR-000 P1 — Context Is Injectable | Foundation for the entire layer model |
| ADR-000 P5 — Evidence Before Trust | Grounds the verification requirement for Warm Context |
| ADR-004 — Context Bundle Specification | Defines the Context Bundle scope; this standard refines placement within it |
| ADR-009 — Evidence & Verification Model | Establishes evidence standards applied to Warm Context verification |
| ADR-011 — Context Bundle Contract | Defines minimum required sections; this standard explains how to populate them correctly |

---

## 9. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.1 kata execution |
