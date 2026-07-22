---
asset_id: WF-005
asset_type: Workflow
title: Task Decomposition Workflow
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-007
  - ADR-002
  - ADR-007
  - ADR-009
  - ADR-010
related:
  - TPL-TD-000
  - TPL-TD-001
  - TPL-TD-002
  - PB-003
  - AUTO-003
  - WF-003
  - WF-004
tags:
  - task-decomposition
  - workflow
  - implementation-planning
  - governance
---

# Task Decomposition Workflow

## Purpose

This workflow defines the canonical sequence of activities that takes an
approved specification or Brownfield Delta through implementation component
identification, task decomposition, interface contract definition, dependency
analysis, engineering review, and approval — before the first line of
implementation is written.

The workflow enforces the governance requirements of ADR-007 and the
decomposition quality requirements of STD-007.

The workflow is technology-agnostic. It applies regardless of language,
deployment model, domain, team structure, or the nature of the change being
decomposed.

---

## Workflow Overview

```
Specification or Delta (Approved)
          ↓
  Stage 1 — Source Analysis
          ↓
  Stage 2 — Implementation Components
          ↓
  Stage 3 — Task Decomposition
          ↓
  Stage 4 — Interface Contracts
          ↓
  Stage 5 — Dependency Graph
          ↓
  Stage 6 — Engineering Review
          ↓
  Stage 7 — Approval
          ↓
  Implementation Ready
```

Each stage has defined inputs, outputs, decision points, deliverables, and
quality gates. A stage must not begin until all entry criteria for that
stage are met.

---

## Stage 1 — Source Analysis

### Purpose

Read and catalogue the approved source document before any decomposition
work begins. This stage prevents decomposition authors from planning
implementation while their understanding of the source is still forming.

### Entry Criteria

- Source document (specification or Brownfield Delta) is in Approved status.
- Decomposition author assigned (named human role).

### Inputs

| Input | Description | Required |
|---|---|---|
| Approved specification or Brownfield Delta | The source document governing this change | Yes |
| STD-007 | Engineering Task Decomposition Standard | Yes |
| TPL-TD-001 and TPL-TD-002 | Plan and Task templates | Yes |
| PB-003 | Task Decomposition Review Playbook | Recommended |

### Activities

1. Read the source document from start to finish without making notes.
2. Re-read the source document, noting every distinct logical section.
3. For each section, answer: "What implementation concern does this section
   introduce, modify, or govern?"
4. Identify the acceptance criteria or behavioural paths in the source
   document. These are the candidates for the First Slice.
5. Record a Source Analysis summary (one paragraph per major section).

### Decision Point 1 — Is the source document ready for decomposition?

| Condition | Action |
|---|---|
| Source document is in Approved status | Proceed to Stage 2 |
| Source document is in Draft or Reviewed status | Stop. Decomposition requires an Approved source document. Return when approved. |
| Source document is ambiguous in a way that blocks decomposition | Record the ambiguity as a finding. Return the document to the specification or delta review cycle. |

### Outputs

| Output | Description |
|---|---|
| Source Analysis summary | One paragraph per major section of the source document; candidate First Slice identified |

### Quality Gate 1

- Source document is in Approved status.
- At least one acceptance criterion or behavioural path identified as a
  First Slice candidate.
- No unresolved ambiguities that would make task boundaries impossible
  to determine.

---

## Stage 2 — Implementation Components

### Purpose

Translate the logical sections of the source document into implementation
components. Each component represents one distinct engineering concern.
Components are the primary input to the task list.

### Entry Criteria

- Quality Gate 1 passed.
- Source Analysis summary complete.

### Inputs

| Input | Description | Required |
|---|---|---|
| Source Analysis summary | Output of Stage 1 | Yes |
| Approved source document | For cross-reference during component definition | Yes |
| TPL-TD-001 | Plan template | Yes |

### Activities

1. Copy `plan.template.md` (TPL-TD-001) to the target project directory.
2. For each logical section of the source document, define one component:
   - Name the component after its engineering concern, not its implementation.
   - State its responsibility in one paragraph.
   - List its inputs (artefacts and upstream component outputs).
   - List its outputs (including any interface signals consumed downstream).
   - Write its interface contract in one sentence.
3. Define the Change Propagation Summary table: map every source document
   item to the component that implements it.
4. Draw a preliminary component dependency diagram.

### Decision Point 2 — Does each component have exactly one concern?

For each component, ask:
- Could the component's responsibility be stated in one sentence?
- If the component's output changes, would it affect more than one
  downstream component in different ways?

If a component has multiple concerns, split it. If splitting produces
components smaller than a meaningful engineering review, merge adjacent
concerns into one component.

### Outputs

| Output | Description |
|---|---|
| `plan.md` | Implementation Plan with all components defined |

### Quality Gate 2

- Every source document section maps to exactly one component.
- Every component has a single-sentence interface contract.
- Component dependency order is defined (no cycles).
- No component says "implement everything."

---

## Stage 3 — Task Decomposition

### Purpose

Translate implementation components into a sequence of 4–8 independently
reviewable tasks. Each task addresses exactly one component or sub-concern
of a component.

### Entry Criteria

- Quality Gate 2 passed.
- `plan.md` complete and author self-reviewed.

### Inputs

| Input | Description | Required |
|---|---|---|
| `plan.md` | Completed Implementation Plan from Stage 2 | Yes |
| Approved source document | For Done criteria traceability | Yes |
| TPL-TD-002 | Task List template | Yes |
| PB-003 | Task Decomposition Review Playbook | Recommended |

### Activities

1. Copy `tasks.template.md` (TPL-TD-002) to the target project directory.
2. For each component in `plan.md`, identify the task or tasks required
   to implement it. Aim for one task per component; split only if the
   component contains more than one independently reviewable concern.
3. For each task:
   a. Assign a stable Task ID (T1, T2, ...).
   b. Write the Input section: source section reference and prior task
      dependencies.
   c. Write the Output section: specific file changes and interface produced.
   d. Write the Done criteria: observable, binary, diff-bounded.
4. Identify the First Slice (T1): the smallest change that implements one
   acceptance criterion end-to-end and unblocks all subsequent tasks.
5. Identify the Highest-Risk task: the task most likely to produce a
   regression in existing behaviour.

### Decision Point 3 — Are tasks independently reviewable?

For each task, apply the independence test (STD-007 Section 3.1):
- Can a reviewer assess correctness from the diff alone?
- Does this task consume any output not yet produced by a prior task?
- Does correctness depend on a future task?

If any answer is "yes," restructure the task.

### Decision Point 4 — Is the task count between 4 and 8?

| Outcome | Action |
|---|---|
| Fewer than 4 tasks | The decomposition is likely too coarse. Split tasks with multiple concerns. |
| 4–8 tasks | Proceed. |
| More than 8 tasks | The change scope may be too large for one decomposition cycle. Consider splitting the source document change into two separate decompositions. |

### Outputs

| Output | Description |
|---|---|
| `tasks.md` (Task List section) | Tasks T1–TN with Input, Output, and Done |

### Quality Gate 3

- Task count is between 4 and 8.
- Every task has a Task ID, Title, Input, Output, and Done section.
- First Slice identified (T1).
- Highest-risk task identified with a one-sentence risk statement.
- Every task is independently reviewable.
- Every Done criterion is observable, binary, and diff-bounded.

---

## Stage 4 — Interface Contracts

### Purpose

Define every seam between tasks. An interface contract names the producer
task, the consuming tasks, the produced value, and the freeze point.

### Entry Criteria

- Quality Gate 3 passed.

### Inputs

| Input | Description | Required |
|---|---|---|
| `tasks.md` (Task List section) | Tasks from Stage 3 | Yes |
| `plan.md` | Component interface contracts | Yes |

### Activities

1. For each task that produces an output consumed by another task:
   a. Name the seam.
   b. State the producer Task ID.
   c. State the consumer Task IDs.
   d. Define the interface contract: field names, types, and constraints.
   e. State the freeze point: "The interface is frozen after [Task ID] is
      reviewed and accepted."
   f. State the consumption rule: what downstream tasks may and may not
      do with the interface.
2. Verify that every inter-task dependency in the task list corresponds
   to a defined seam.

### Decision Point 5 — Is every inter-task dependency covered by an interface contract?

For every dependency arrow in the preliminary dependency diagram, verify
that a seam definition exists. An undeclared dependency is an implicit
interface — a prohibited pattern (STD-007 Section 7).

### Outputs

| Output | Description |
|---|---|
| `tasks.md` (Interface Contracts section) | All seams defined |

### Quality Gate 4

- Every inter-task dependency has a named seam.
- Every seam has a producer, consumers, contract, and freeze point.
- No implicit dependencies remain.

---

## Stage 5 — Dependency Graph

### Purpose

Produce a directed acyclic graph of all tasks and their dependencies.
Verify that the graph is acyclic before review begins.

### Entry Criteria

- Quality Gate 4 passed.

### Inputs

| Input | Description | Required |
|---|---|---|
| `tasks.md` (Interface Contracts section) | Seams from Stage 4 | Yes |

### Activities

1. Represent every task as a node.
2. Represent every interface-contract dependency as a directed edge from
   producer to consumer.
3. Label each edge with the interface name.
4. Annotate the First Slice node (FIRST SLICE).
5. Annotate the Highest-Risk node (HIGHEST RISK).
6. Check for cycles. A cycle indicates an unresolved circular dependency
   that must be resolved before review.

### Decision Point 6 — Is the dependency graph acyclic?

| Outcome | Action |
|---|---|
| Graph is acyclic | Proceed to Stage 6 |
| Graph contains a cycle | Stop. Resolve the circular dependency: split one of the tasks in the cycle or introduce an intermediate interface. Return to Stage 3. |

### Outputs

| Output | Description |
|---|---|
| `tasks.md` (Dependency Graph section) | Directed acyclic graph in Mermaid or equivalent notation |

### Quality Gate 5

- Graph is acyclic.
- Every task is represented as a node.
- Every inter-task dependency is represented as a directed edge.
- FIRST SLICE and HIGHEST RISK nodes are annotated.

---

## Stage 6 — Engineering Review

### Purpose

Challenge the decomposition before it is submitted for human review.
This stage surfaces problems that would be expensive to discover during
implementation.

### Entry Criteria

- Quality Gate 5 passed.

### Inputs

| Input | Description | Required |
|---|---|---|
| `plan.md` | Completed Implementation Plan | Yes |
| `tasks.md` | Task List with interface contracts and dependency graph | Yes |
| STD-007 Section 11 | Engineering Review checklist | Yes |
| PB-003 | Task Decomposition Review Playbook | Recommended |

### Activities

1. Apply every challenge in STD-007 Section 11.1 to the decomposition.
2. For each challenge, state the result with rationale.
3. For each challenge that reveals a problem, restructure the affected
   tasks before proceeding.
4. Complete the Verification Report table in `tasks.md`.

### Decision Point 7 — Does the decomposition pass all Engineering Review challenges?

| Outcome | Action |
|---|---|
| All challenges pass with rationale | Proceed to Stage 7 |
| One or more challenges fail | Restructure affected tasks. Return to the relevant stage (3, 4, or 5). |
| A challenge reveals that the source document itself is ambiguous | Record the ambiguity as a new finding. Return the source document to its review cycle. Halt decomposition. |

### Outputs

| Output | Description |
|---|---|
| `tasks.md` (Engineering Review section) | All five challenges answered with rationale |
| `tasks.md` (Verification Report) | All rows evaluated as PASS or FAIL |

### Quality Gate 6

- All five Engineering Review challenges answered with examination rationale.
- All Verification Report rows evaluated (no blanks).
- Zero FAIL rows in the Verification Report.
- No task says "implement everything."

---

## Stage 7 — Approval

### Purpose

A named human approver validates that the decomposition is complete, that
interfaces are explicit, that the First Slice is correctly identified, and
that the highest-risk task is correctly annotated.

### Entry Criteria

- Quality Gate 6 passed.
- Approver identified (must not be the author).

### Inputs

| Input | Description | Required |
|---|---|---|
| `plan.md` | Completed Implementation Plan | Yes |
| `tasks.md` | Completed Task List | Yes |

### Activities

1. Read `plan.md` and verify that every source document section has a
   corresponding component with a single-concern responsibility.
2. Read `tasks.md` and verify that every task is independently reviewable,
   has a diff under 100 lines, and has complete Done criteria.
3. Verify that the First Slice implements exactly one acceptance criterion
   end-to-end.
4. Verify that the highest-risk task is annotated with a one-sentence
   risk statement that names the preserved behaviour and the specific
   failure mode.
5. Approve or request revision.

### Decision Point 8 — Approve or revise?

| Outcome | Action |
|---|---|
| Decomposition is complete and implementable | Approve. Update status to Approved. Implementation may begin. |
| Decomposition has gaps or task overlap | Request revision. Return to the relevant stage. |
| Source document ambiguity blocks review | Stop. Return the source document to its review cycle. |

### Outputs

| Output | Description |
|---|---|
| Approval record | Named approver, date, any conditions |
| `plan.md` | Updated to Approved status |
| `tasks.md` | Updated to Approved status |

### Quality Gate 7

- Named human approver has signed off.
- Both `plan.md` and `tasks.md` are in Approved status.
- No outstanding FAIL items in the Verification Report.

---

## Implementation Ready

When Quality Gate 7 is passed, implementation may begin.

Tasks are implemented in the order defined by the dependency graph.
A task must not begin until all its declared dependencies are in Completed
and Reviewed status.

If implementation reveals a gap in the decomposition:

1. Stop implementation on the affected task.
2. Record the gap as a new finding.
3. Return to Stage 3 or Stage 4 depending on whether the gap is a missing
   task or a missing interface contract.
4. Do not implement an interpretation not supported by the approved
   `plan.md` or `tasks.md`.

---

## Deliverables Summary

| Stage | Primary deliverable | Status at completion |
|---|---|---|
| 1 — Source Analysis | Source Analysis summary | Not tracked as an Engineering Asset |
| 2 — Implementation Components | `plan.md` | Draft |
| 3 — Task Decomposition | `tasks.md` (Task List section) | Draft |
| 4 — Interface Contracts | `tasks.md` (Interface Contracts section) | Draft |
| 5 — Dependency Graph | `tasks.md` (Dependency Graph section) | Draft |
| 6 — Engineering Review | `tasks.md` (Engineering Review + Verification Report) | Draft |
| 7 — Approval | `plan.md` + `tasks.md` | Approved |

---

## Anti-Patterns

| Anti-pattern | Description | Correction |
|---|---|---|
| Decomposing before source document is approved | Task list produced while specification is still in Draft | Stop. An unapproved source document is not a stable basis for decomposition. |
| First Slice implements multiple acceptance criteria | The first task covers more than one behavioural path | Split. The First Slice must implement exactly one end-to-end AC. |
| Implicit interfaces | Tasks depend on each other's outputs without a defined seam | Define the interface contract before either task begins (Stage 4). |
| Dependency cycle | T3 depends on T4 and T4 depends on T3 | Break the cycle: introduce an intermediate task or split one of the tasks. |
| Tasks with vague Output sections | Output says "implement X" | Rewrite: name the file and the specific change. |
| Engineering Review without examination | Challenges answered "yes" without rationale | Rewrite: state what was examined and what was found or excluded. |
| Highest-risk task not identified | No task is annotated as highest-risk | Apply STD-007 Section 10 criteria; annotate one task. |
| Implementing before approval | Implementation begins while decomposition is in Draft | Stop. Approved status is required. |

---

## Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.6 kata execution |
