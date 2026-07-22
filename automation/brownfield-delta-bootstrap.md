---
id: AUTO-002
title: "Brownfield Delta Bootstrap — AI Workflow"
type: Automation
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: automation
tags: [brownfield, delta, ai-workflow, bootstrap, automation, change-management]
depends_on: [STD-006, WF-004, TPL-BD-000, TPL-BD-001, TPL-BD-002, PB-002]
related: [KR-K5D5]
supersedes: ""
superseded_by: ""
---

# AUTO-002 — Brownfield Delta Bootstrap

## 1. Purpose

This document describes a reusable AI-assisted workflow that generates a
Brownfield Delta for any repository whose approved specification is being
amended after sign-off.

The workflow is designed for execution by an AI engineering assistant
operating with a project Context Bundle loaded. It produces a first-draft
delta populated from the approved baseline specification and the change
request, ready for human review.

This automation does not replace the engineering judgment required to identify
genuine removals, challenge backward compatibility assumptions, or approve
the change. It accelerates the mechanical construction steps so that
engineer effort is concentrated on the REMOVED section, the REMOVED Audit,
and the Risk Note — the sections most likely to contain errors when produced
under time pressure.

**This automation never generates repository-specific content in the toolkit.**
All project-specific content lives in the consuming project and its Context
Bundle.

---

## 2. Scope

This automation applies to any repository that:

- contains an engineering specification in Approved or Active status;
- has received a post-approval change request;
- has a project Context Bundle that describes the capability being changed.

It produces an output conforming to TPL-BD-001. For governance and approval,
follow WF-004.

---

## 3. Prerequisites

Before invoking this automation, the engineer must provide:

| Input | Required | How to obtain |
|---|---|---|
| Approved baseline specification | Yes | The specification file at its current approved version |
| Change request description | Yes | Written description of the proposed change from the requester |
| Project Context Bundle | Yes | The project's CLAUDE.md and warm/cold context documents |
| Delta target path | Yes | Where in the project repository the delta file will be placed |

The approved baseline specification is the critical prerequisite. This
automation derives its analysis from the baseline. A baseline that has not
been read in full by the engineer before invoking the automation produces
lower-quality output.

**Human pre-read required:** Before invoking Phase 0, the engineer must read
the approved baseline specification. The automation can process it, but
the engineer's prior understanding improves the quality of human review points.

---

## 4. Engineering Assets Referenced

This automation depends on and references the following Engineering Toolkit
assets:

| Asset | Role |
|---|---|
| STD-006 — Brownfield Delta Standard | Defines what a Brownfield Delta is and what it must satisfy |
| WF-004 — Brownfield Change Analysis Workflow | The human workflow this automation accelerates |
| TPL-BD-000 — Brownfield Delta Template Set README | Usage guidance for the templates |
| TPL-BD-001 — Brownfield Delta Template | The structural template the automation populates |
| TPL-BD-002 — Review Checklist Template | The checklist populated in Phase 7 |
| PB-002 — Backward Compatibility Review Playbook | Guides the REMOVED analysis in Phase 3 |

The automation implements the rules defined in STD-006. It does not
redefine or override them.

---

## 5. AI Workflow

The following is the AI assistant prompt workflow. Each phase is a discrete
instruction. Execute phases in order. Do not skip phases.

Phases 1–4 are analysis phases: AI reads and analyses without writing.
Phases 5–7 are generation phases: AI produces draft delta content.
Every phase ends with a human review point before the next phase begins.

---

### Phase 0 — Load context

**Instruction to AI:**

```
Read the following before proceeding:

1. STD-006 — Brownfield Delta Standard
   Path: engineering-toolkit/standards/brownfield-delta-standard.md

2. WF-004 — Brownfield Change Analysis Workflow
   Path: engineering-toolkit/workflows/brownfield-change-analysis.md

3. TPL-BD-001 — Brownfield Delta Template
   Path: engineering-toolkit/templates/brownfield-delta/delta.template.md

4. PB-002 — Backward Compatibility Review Playbook
   Path: engineering-toolkit/playbooks/backward-compatibility-review.md

5. The project Context Bundle (project CLAUDE.md and relevant context files)

6. The approved baseline specification (provided by the engineer)

7. The change request description (provided by the engineer)

Confirm that you have read all seven inputs. Summarise:
- The capability being changed
- The current specification version
- The change request in one sentence
- The most significant section of the specification for backward
  compatibility analysis

Do not begin any analysis yet.
```

**Expected output:** Confirmation of all seven inputs read. Brief capability
summary. No analysis.

**Human review point:** Confirm the AI has correctly understood the capability
and the change request before proceeding.

---

### Phase 1 — Baseline catalogue

**Instruction to AI:**

```
Using the approved baseline specification, produce a Baseline Behaviour
Catalogue.

For every caller-visible behaviour in the specification, produce one entry:

  Behaviour: <name>
  Location:  <section and subsection in the specification>
  Form:      Explicit (documented) / Implicit (consumer assumption)
  Consumer test: <a test a consumer could write to verify this behaviour>

Focus on:
- Output structure and field names
- Classification schemes and enumeration values
- Error codes and trigger conditions
- Constraints stated as unconditional rules
- Integration contracts
- Acceptance criteria (these define the specification's behavioural ceiling)
- NFR vocabulary checks and their permitted values

Do not analyse the change yet. Only catalogue what exists in the baseline.
```

**Expected output:** A structured catalogue of all caller-visible behaviours.
Each entry has all four fields.

**Human review point:** Review the catalogue. Add any behaviours the AI missed.
Remove any that are not caller-visible. Confirm before proceeding.

---

### Phase 2 — Change categorisation

**Instruction to AI:**

```
Using the confirmed baseline catalogue from Phase 1 and the change request,
categorise every aspect of the proposed change.

For each change element, produce one entry:

  Change:         <description of the change element>
  Type:           Addition / Modification / Removal
  Catalogue items affected: <list the catalogue entries this touches>
  Backward compatible: Yes / No / Conditional — <rationale>

Rules (from STD-006 and WF-004):
- If a modification would break an existing consumer, reclassify as Removal.
- Every addition must be checked: does it require any existing behaviour to
  change? Does it remove any existing guarantee?
- State every answer explicitly. Do not leave any change element unclassified.

Do not generate the delta yet. Only categorise.
```

**Expected output:** A change categorisation table. Every change element
classified. No unclassified items.

**Human review point:** Review each classification. Challenge any Modification
that might actually break consumers. Challenge any claim of "backward
compatible: yes" without rationale. Confirm before proceeding.

---

### Phase 3 — Hidden removal search

**Instruction to AI:**

```
Apply each hidden removal technique from PB-002 Section 3 to the confirmed
change categorisation.

For each technique, state:

  Technique: <name>
  Applied to: <change elements and catalogue items examined>
  Finding: <hidden removal found, or "no hidden removal — rationale">

Techniques to apply:
1. Enumeration ceiling test
2. Unconditional constraint relaxation test
3. Format stability test
4. Maximum value test
5. Consumer implementation thought experiment
6. Acceptance criteria ceiling audit
7. Integration contract audit

For the consumer implementation thought experiment: reason as if you are
an engineer who implemented a consumer of this capability against the
approved specification. What assumptions did you make? Which does the
change invalidate?

Produce a list of all identified implicit and explicit removals, numbered
R-1, R-2, ...

Do not generate the delta yet.
```

**Expected output:** Results of all seven techniques. List of identified
removals with numbering.

**Human review point:** Review each finding. Challenge any technique result
of "no hidden removal" that lacks clear rationale. Add any removals the AI
missed. Remove any that are fabricated. Confirm before proceeding.

---

### Phase 4 — Risk assessment

**Instruction to AI:**

```
Identify the highest-risk preserved behaviour and define the proof test.

Step 1: From the baseline catalogue confirmed in Phase 1, identify the
preserved behaviour most at risk of regression from this change.
Apply the guidance from STD-006 Section 7.1:
- Where do the new behaviour and the old behaviour share a trigger condition?
- Where does the change introduce a conditional relaxation of an
  unconditional rule?
- Where is the new enumeration value adjacent to an existing value?
- Where does the change modify an output section format only under specific
  conditions?

Step 2: State specifically which implementation pattern makes this behaviour
susceptible to regression. Name the failure mode (not vague possibility).

Step 3: Define the proof test:
- Given: <input state that falls under the preserved behaviour's coverage>
- When: <the operation>
- Then: <the expected output — specifically the preserved output value>
- Distinguishing condition: <what would distinguish a correct result from
  the regression>

The proof test must target the boundary between old and new behaviour.
It must not only demonstrate the new behaviour's happy path.

Do not generate the delta yet.
```

**Expected output:** Named highest-risk preserved behaviour. Specific failure
mode description. Proof test in Given/When/Then format.

**Human review point:** Challenge the risk assessment. Is this genuinely the
highest-risk preserved behaviour? Does the proof test target the boundary or
the happy path? Confirm before proceeding.

---

### Phase 5 — Generate the delta draft

**Instruction to AI:**

```
Using the confirmed outputs of Phases 1–4, generate the Brownfield Delta
using the structure from TPL-BD-001.

Requirements:
- Populate every section from the confirmed analysis.
- Do not introduce content that was not confirmed in Phases 1–4.
- ADDED: every confirmed addition, numbered A-1, A-2, ...
- MODIFIED: every confirmed modification with Before and After, numbered M-1, M-2, ...
- REMOVED: every confirmed removal from Phase 3, numbered R-1, R-2, ...
- Risk Note: use the confirmed highest-risk behaviour and proof test from Phase 4.
- No {{PLACEHOLDER}} tokens in the sections populated from confirmed analysis.
  Leave {{PLACEHOLDER}} tokens only in sections not yet complete.
- Do not generate the Engineering Review section yet; that is Phase 6.
- Do not generate the Verification Report section yet; that is Phase 7.

Write the complete delta file. Do not abbreviate.
```

**Expected output:** Complete delta file with all sections through Risk Note
populated. Engineering Review and Verification Report sections contain
placeholders.

**Human review point:** Review the entire draft delta. Verify:
- Every ADDED item was confirmed in Phase 2.
- Every REMOVED item was confirmed in Phase 3.
- The preserved behaviour matches the Phase 1 catalogue.
- The proof test matches Phase 4.
Correct any discrepancies before proceeding.

---

### Phase 6 — REMOVED Audit and Engineering Review

**Instruction to AI:**

```
Complete the REMOVED Audit and Engineering Review sections of the delta.

REMOVED Audit:
Apply the six-step procedure from STD-006 Section 6.2:
1. For each ADDED item, state whether it removes any previous guarantee.
2. For each MODIFIED item, state whether it removes any previous guarantee.
3. For each common removal category, state whether it is affected and why.
4. Apply the consumer perspective.
5. If any new removals are found, add them to the REMOVED section and re-run.
6. Write the completion statement using the format in STD-006 Section 6.3.

Engineering Review:
Answer all five questions from STD-006 Section 8.1:
1. Is ADDED complete?
2. Is MODIFIED complete?
3. Is REMOVED honest?
4. Are backward compatibility guarantees missing?
5. Would an implementation engineer understand exactly what changed?

For each question:
- State the answer directly with rationale.
- Describe what was examined.
- Describe what was found (or not found).
- Describe what was examined and excluded, with the reason.

Do not answer "yes, complete" without examination evidence.
```

**Expected output:** REMOVED Audit section complete with completion statement.
Engineering Review section complete with examination rationale for each question.

**Human review point:** Review the REMOVED Audit completion statement. Is it
accurate? Review the Engineering Review. Are any answers thin? Correct before
proceeding.

---

### Phase 7 — Verification Report and checklist

**Instruction to AI:**

```
Complete the Verification Report section of the delta.

For each row in the Verification Report table:
- Evaluate the delta against the criterion.
- Mark PASS or FAIL.
- Add a note for any FAIL explaining what needs correction.

Then produce the Part 1 (Author Self-Review) section of the review checklist
(TPL-BD-002).

For each row in the Part 1 checklist:
- Mark PASS or FAIL based on the delta content.
- Add a note for any FAIL.

Produce a summary:
1. Files generated (path and purpose)
2. Sections complete (PASS count in Verification Report)
3. Items requiring human correction (FAIL count with descriptions)
4. Next step: submit for independent review (WF-004 Stage 7)
```

**Expected output:** Verification Report complete. Part 1 of review checklist
complete. Summary with PASS/FAIL counts and any items requiring correction.

**Human review point:** Review all FAIL items. Correct them before submitting
for independent review.

---

## 6. Human Responsibilities

This automation generates a first draft. The following decisions always
require human judgment:

| Decision | Why human judgment is required |
|---|---|
| Baseline catalogue completeness (Phase 1) | The AI may miss implicit consumer behaviours that an experienced engineer would identify |
| Backward compatibility classification (Phase 2) | Whether a modification truly breaks consumers requires domain knowledge the AI may not have |
| Hidden removal completeness (Phase 3) | The consumer implementation thought experiment requires genuine empathy for how consumers are built |
| Highest-risk preserved behaviour (Phase 4) | Risk prioritisation requires understanding which consumers exist and what they depend on |
| REMOVED honesty (Phase 6) | Only a human can verify that a removal is genuine and not fabricated |
| Independent review (WF-004 Stage 7) | The independent reviewer must be a human who did not author the delta |
| Approval (WF-004 Stage 7) | Approval always requires a named human; AI never approves |

---

## 7. Limitations

| Limitation | Detail |
|---|---|
| Implicit removal quality depends on context | The consumer implementation thought experiment in Phase 3 is only as good as the context the AI has about how consumers are built. A thin Context Bundle produces thin removals. |
| Specification ambiguity propagates | If the approved baseline specification is ambiguous, the delta will reflect that ambiguity. Resolve ambiguities in the specification before invoking this automation. |
| The automation cannot identify unknown consumers | If consumers exist that are not described in the Context Bundle, their assumptions cannot be modelled. The engineer must supplement with domain knowledge. |
| Engineering Review cannot be fully automated | The Engineering Review in Phase 6 requires genuine self-challenge. An AI that has just generated the delta is the least suitable reviewer of it. Human review in WF-004 Stage 7 is mandatory. |
| Risk assessment quality depends on implementation knowledge | The highest-risk preserved behaviour identification requires understanding of how classifiers, parsers, and matchers are typically implemented. The AI's estimate should be challenged by an engineer with implementation experience. |

---

## 8. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.5 kata execution |
