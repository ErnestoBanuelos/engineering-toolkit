---
id: AUTO-003
title: "Task Decomposition Bootstrap — AI Workflow"
type: Automation
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: automation
tags: [task-decomposition, ai-workflow, bootstrap, automation, implementation-planning]
depends_on: [STD-007, WF-005, TPL-TD-000, TPL-TD-001, TPL-TD-002, PB-003]
related: [KR-K5D6]
supersedes: ""
superseded_by: ""
---

# AUTO-003 — Task Decomposition Bootstrap

## 1. Purpose

This document describes a reusable AI-assisted workflow that generates a
complete Implementation Plan and Task List from an approved specification
or Brownfield Delta.

The workflow is designed for execution by an AI engineering assistant
operating with a project Context Bundle loaded. It produces first-draft
`plan.md` and `tasks.md` artefacts, populated from the source document,
ready for human review.

This automation does not replace the engineering judgment required to identify
the First Slice, annotate the highest-risk task, or confirm interface
contracts. It accelerates the structural construction steps so that engineer
effort is concentrated on task boundaries, seam definitions, and the
Engineering Review — the areas most likely to contain errors under time
pressure.

**This automation never generates repository-specific content in the toolkit.**
All project-specific content lives in the consuming project and its Context
Bundle.

---

## 2. Scope

This automation applies to any repository that:

- Contains an engineering specification or Brownfield Delta in Approved status.
- Has a project Context Bundle describing the capability being changed.
- Intends to implement the change in independently reviewable increments.

It produces output conforming to TPL-TD-001 (plan) and TPL-TD-002 (tasks).
For governance and approval, follow WF-005.

---

## 3. Prerequisites

Before invoking this automation, the engineer must provide:

| Input | Required | How to obtain |
|---|---|---|
| Approved source document | Yes | The specification or delta file at its approved version |
| Project Context Bundle | Yes | The project's context documents |
| Target output paths | Yes | Where in the project repository plan.md and tasks.md will be placed |

The approved source document is the critical prerequisite. This automation
derives its analysis entirely from the source document. A source document
in Draft or Reviewed status is not a suitable input — it may change
during decomposition.

**Human pre-read required:** Before invoking Phase 0, the engineer must
read the approved source document. The automation can process it, but
the engineer's prior understanding improves the quality of human review
at each phase.

---

## 4. Engineering Assets Referenced

| Asset | Role |
|---|---|
| STD-007 — Engineering Task Decomposition Standard | Defines what a valid task decomposition is and what it must satisfy |
| WF-005 — Task Decomposition Workflow | The human workflow this automation accelerates |
| TPL-TD-000 — Template Set README | Usage guidance for the templates |
| TPL-TD-001 — Implementation Plan Template | The plan template this automation populates |
| TPL-TD-002 — Task List Template | The task list template this automation populates |
| PB-003 — Task Decomposition Review Playbook | Guides the seam identification and First Slice selection |

The automation implements the rules defined in STD-007. It does not
redefine or override them.

---

## 5. AI Workflow

The following is the AI assistant prompt workflow. Each phase is a discrete
instruction. Execute phases in order. Do not skip phases.

Phases 1–3 are analysis phases: AI reads and analyses without writing.
Phases 4–6 are generation phases: AI produces draft plan and task content.
Every phase ends with a human review point before the next phase begins.

---

### Phase 0 — Load context

**Instruction to AI:**

```
Read the following before proceeding:

1. STD-007 — Engineering Task Decomposition Standard
   Path: engineering-toolkit/standards/task-decomposition-standard.md

2. WF-005 — Task Decomposition Workflow
   Path: engineering-toolkit/workflows/task-decomposition.md

3. TPL-TD-001 — Implementation Plan Template
   Path: engineering-toolkit/templates/task-decomposition/plan.template.md

4. TPL-TD-002 — Task List Template
   Path: engineering-toolkit/templates/task-decomposition/tasks.template.md

5. PB-003 — Task Decomposition Review Playbook
   Path: engineering-toolkit/playbooks/task-decomposition-review.md

6. The project Context Bundle (project context documents)

7. The approved source document (provided by the engineer)

Confirm that you have read all seven inputs. Summarise:
- The source document type (specification or Brownfield Delta)
- The source document version
- The primary change described in the source document in one sentence
- The number of logical sections in the source document

Do not begin any analysis yet.
```

**Expected output:** Confirmation of all seven inputs read. Brief source
document summary. No analysis.

**Human review point:** Confirm the AI has correctly identified the source
document type, version, and primary change before proceeding.

---

### Phase 1 — Source document catalogue

**Instruction to AI:**

```
Using the approved source document, produce a Source Document Catalogue.

For every logical section in the source document, produce one entry:

  Section: <name or identifier>
  Location: <document section heading>
  Engineering concern: <what implementation concern does this section
                        introduce, modify, or govern?>
  Downstream dependency: <which other sections depend on this section's
                          implementation? state "none" if terminal>
  Acceptance criteria or proof test: <list any AC or test that exercises
                                      this section's behaviour>

Focus on:
- Output sections and format rules
- Classification and routing logic
- Constraint definitions and their conditions
- Integration rules
- NFR vocabulary and enforcement rules
- Acceptance criteria (these define implementable behaviour end-to-end)

Do not plan components yet. Only catalogue what is in the source document.
```

**Expected output:** A structured catalogue. Every logical section has all
five fields. Acceptance criteria are explicitly listed.

**Human review point:** Review the catalogue. Add any sections the AI
missed. Remove any that are not implementation-relevant. Confirm the
acceptance criterion list before proceeding.

---

### Phase 2 — Implementation component design

**Instruction to AI:**

```
Using the confirmed source document catalogue from Phase 1, design
the implementation components for plan.md.

For each logical section in the confirmed catalogue, design one component:

  Component name: <engineering concern, not implementation detail>
  Responsibility: <one paragraph, what this component governs>
  Inputs: <list of artefacts and upstream component outputs>
  Outputs: <list including any interface signal for downstream components>
  Interface contract: <one sentence — what this component accepts and emits>
  Source items addressed: <list of catalogue entries this component covers>

Rules (from STD-007 and PB-003):
- One concern per component.
- Interface contracts must be one sentence.
- The first component (Component 1) should produce the primary signal
  (flag, token, classification) that all other components depend on.
  This component is the First Slice candidate for the task list.
- State the propagation order explicitly: which component is upstream of
  which.

Do not generate tasks yet. Only design components.
```

**Expected output:** A component design for every catalogue section.
Each component has all six fields. Propagation order stated.

**Human review point:** Review each component. Challenge any component
with multiple responsibilities. Verify that the First Slice candidate
is the one that produces the primary signal. Confirm before proceeding.

---

### Phase 3 — Task identification and seam analysis

**Instruction to AI:**

```
Using the confirmed component design from Phase 2, identify the tasks
and seams for tasks.md.

For each component (or sub-concern of a component), identify one task:

  Task ID: T<N>
  Title: <engineering concern, not implementation detail>
  Component source: <which component in Phase 2 this implements>
  Dependencies: <list Task IDs this task depends on; "none" if T1>
  Primary signal produced: <the interface value or output section this
                            task produces for downstream tasks>
  Estimated diff scope: <brief description; estimated line count>
  Done criteria candidates: <3–5 observable, binary criteria>

Apply seam identification (PB-003 Section 2):
  For every task that produces an output consumed by another task,
  define the seam:
    Seam name: <label>
    Producer: <Task ID>
    Consumers: <Task IDs>
    Contract: <value name, type, vocabulary or constraints>
    Freeze point: <"frozen after TN is reviewed and accepted">

Then identify:

  FIRST SLICE: which task satisfies all four criteria in STD-007 Section 9?
    - Implements exactly one AC end-to-end
    - Estimated diff under 100 lines
    - Unblocks the most downstream tasks
    - Has no dependencies on other tasks in this set

  HIGHEST-RISK TASK: which task is most likely to produce a regression
  in existing behaviour if implemented incorrectly? (STD-007 Section 10)
    - State the one-sentence risk statement naming:
      the preserved behaviour, the specific mistake, the regression outcome

Do not generate the plan or task list yet. Only produce the identification
analysis.
```

**Expected output:** Task identification table. Seam definitions. First
Slice identification with rationale. Highest-risk task with one-sentence
risk statement.

**Human review point:** Review each task. Challenge any task with multiple
concerns. Verify that the First Slice candidate is correct. Challenge
the highest-risk identification. Confirm before proceeding.

---

### Phase 4 — Generate plan.md

**Instruction to AI:**

```
Using the confirmed outputs of Phases 1–3, generate plan.md using the
structure from TPL-TD-001.

Requirements:
- Populate every section from the confirmed component design (Phase 2).
- Do not introduce content that was not confirmed in Phases 1–3.
- Components section: one component per confirmed component in Phase 2.
- Each component: Responsibility, Inputs, Outputs, Interface Contract.
- Propagation diagram: use the confirmed propagation order from Phase 2.
- Change Propagation Summary table: map every source document item to
  its component.
- No {{PLACEHOLDER}} tokens in sections populated from confirmed analysis.
- Footer: "No implementation. Planning artefact only."

Write the complete plan.md file. Do not abbreviate.
```

**Expected output:** Complete plan.md file with all sections populated.
No {{PLACEHOLDER}} tokens in confirmed sections.

**Human review point:** Review the entire plan. Verify:
- Every source document section maps to a component.
- Every component has a single-concern responsibility.
- The interface contract for Component 1 matches the Phase 3 seam
  definition for Seam 1.
Correct any discrepancies before proceeding.

---

### Phase 5 — Generate tasks.md

**Instruction to AI:**

```
Using the confirmed outputs of Phases 1–3, generate tasks.md using the
structure from TPL-TD-002.

Requirements:
- Populate every task from the confirmed task identification (Phase 3).
- Mark T1 as FIRST SLICE with the confirmed rationale.
- Mark the highest-risk task with the confirmed one-sentence risk statement.
- Input sections: list source document sections and prior task dependencies.
- Output sections: name specific files changed and interfaces produced.
- Done criteria: observable, binary, diff-bounded. Include "Diff is under
  100 lines" as the final criterion in every task.
- Interface Contracts section: include every seam from Phase 3.
  Each seam: producer, consumers, contract, freeze point, consumption rule.
- Dependency Graph: Mermaid graph TD. Annotate FIRST SLICE and HIGHEST RISK.
- Engineering Review section: leave as {{PLACEHOLDER}} — this is Phase 6.
- Verification Report section: leave as {{PLACEHOLDER}} — this is Phase 6.
- Footer: "No implementation. Planning artefact only."

Write the complete tasks.md file. Do not abbreviate.
```

**Expected output:** Complete tasks.md file with Task List, Annotations,
Interface Contracts, and Dependency Graph populated. Engineering Review
and Verification Report sections contain placeholders.

**Human review point:** Review the entire task list. Verify:
- Every task in the Phase 3 identification is present.
- T1 First Slice rationale is correct.
- Every seam from Phase 3 is in the Interface Contracts section.
- Dependency graph edges match the Interface Contracts.
Correct any discrepancies before proceeding.

---

### Phase 6 — Engineering Review and Verification Report

**Instruction to AI:**

```
Complete the Engineering Review and Verification Report sections of tasks.md.

Engineering Review:
Apply all five challenges from STD-007 Section 11.1:

  Challenge 1: Does every task fit in one afternoon?
    - Produce the estimate table for all tasks.
    - State a conclusion with rationale.

  Challenge 2: Does every task produce a diff under 100 lines?
    - Produce the scope table for all tasks.
    - State a conclusion with rationale.

  Challenge 3: Does any task say "implement everything"?
    - Review each task's Output section.
    - State yes or no with evidence.

  Challenge 4: Are seams explicit?
    - Review the Interface Contracts section.
    - State yes or no, naming the seams verified.

  Challenge 5: Does the FIRST SLICE implement only one acceptance criterion?
    - State which AC the First Slice implements.
    - Confirm it is one AC and one AC only.
    - Confirm the estimated diff is under 100 lines.

For each challenge:
- State the result with rationale.
- Describe what was examined.
- Do not answer "yes" without examination evidence.

Verification Report:
For each row in the Verification Report table:
- Evaluate tasks.md against the criterion.
- Mark YES or NO.
- Add a note for any NO explaining what needs correction.

Then produce a summary:
1. Files generated (path and purpose)
2. Rows passing in the Verification Report
3. Items requiring human correction (NO rows with descriptions)
4. Next step: submit for independent review (WF-005 Stage 7)
```

**Expected output:** Engineering Review complete with examination rationale
for all five challenges. Verification Report complete with all rows
evaluated. Summary with pass count and any items requiring correction.

**Human review point:** Review all NO items. Correct them before submitting
for independent review.

---

## 6. Human Responsibilities

This automation generates a first draft. The following decisions always
require human judgment:

| Decision | Why human judgment is required |
|---|---|
| Source document catalogue completeness (Phase 1) | The AI may miss implicit concerns that an experienced engineer would identify |
| Component concern separation (Phase 2) | Deciding whether two concerns belong in one component or two requires domain knowledge |
| First Slice identification (Phase 3) | Choosing the minimal unblocking task requires understanding what future reviewers will need first |
| Highest-risk task identification (Phase 3) | Risk prioritisation requires knowledge of how implementations fail, not just what specifications say |
| Seam contract definition (Phase 3) | Interface contracts require understanding of how consuming code will use the produced value |
| Engineering Review challenge quality (Phase 6) | An AI that just generated the plan has the change deeply in context and may confirm its own choices |
| Independent review (WF-005 Stage 7) | The independent reviewer must be a human who did not author the decomposition |
| Approval (WF-005 Stage 7) | Approval always requires a named human; AI never approves |

---

## 7. Limitations

| Limitation | Detail |
|---|---|
| Component design quality depends on context | Thin Context Bundles produce components with lower-quality responsibility statements. Provide rich architectural context. |
| Task size estimates are approximations | The AI estimates line counts from the source document structure. Actual diffs may differ. The engineer must verify before review. |
| Seam discovery depends on specification clarity | If the source document does not clearly separate concerns, the seam analysis will reflect that ambiguity. Resolve source document ambiguities before invoking. |
| Engineering Review is partially self-referential | The AI that just generated the plan is the least reliable reviewer of it. Phase 6 output should be challenged by a human reviewer before submission. |
| Highest-risk task identification requires implementation knowledge | The AI's estimate of which task is highest-risk should be challenged by an engineer with implementation experience in the relevant domain. |

---

## 8. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.6 kata execution |
