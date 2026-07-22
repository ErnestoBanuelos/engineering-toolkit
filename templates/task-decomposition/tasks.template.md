---
asset_id: TPL-TD-002
asset_type: Template
title: Task List Template
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-007
  - ADR-002
  - ADR-003
related:
  - TPL-TD-000
  - TPL-TD-001
  - WF-005
  - PB-003
tags:
  - task-decomposition
  - task-list
  - template
  - planning
  - interface-contracts
---

<!--
USAGE INSTRUCTIONS (remove this block before publishing the task list)

This template produces a Task List: the second planning artefact in a task
decomposition. It translates the implementation components from plan.md
(TPL-TD-001) into a sequence of 4–8 independently reviewable tasks.

Before filling this template:
  1. Read STD-007 (Engineering Task Decomposition Standard) in full.
  2. Complete plan.md (TPL-TD-001) first. The components in the plan are
     the primary input to this template.
  3. Read PB-003 (Task Decomposition Review Playbook) before choosing task
     boundaries.

Replace every {{PLACEHOLDER}} with real content.
A template that still contains {{...}} tokens is not ready for review.

Task count: between 4 and 8. Fewer than 4 suggests the decomposition has
not been granular enough. More than 8 suggests the scope is too large for
a single decomposition cycle.

Section ordering is fixed. Do not reorder, rename, or remove sections.
-->

# Task Decomposition — {{CHANGE_TITLE}}

**Tasks version:** {{VERSION}}
**Source document:** {{SOURCE_DOCUMENT_PATH}}
**Plan source:** {{PLAN_PATH}}
**Kata / Work item:** {{KATA_OR_TICKET}}
**Date:** {{DATE}}
**Status:** Planning artefact — no implementation included

---

## Task List

---

### T1 — {{TASK_1_TITLE}}

**FIRST SLICE**

<!--
FIRST SLICE RULES (STD-007 Section 9):
- Implements exactly one acceptance criterion end-to-end.
- Produces a diff under 100 lines.
- Unblocks the most downstream work.
- Has no dependencies on other tasks in this set.
- Is independently reviewable.

Explain why T1 is the First Slice in a brief comment here.
-->

```
Task ID:  T1
Title:    {{TASK_1_TITLE}}
```

**Input:**

<!--
List every artefact required to begin this task.
Include: source document sections, prior completed tasks, frozen interface
contracts. T1 (the First Slice) typically has no prior task dependencies.
-->

- {{SOURCE_DOCUMENT_PATH}} — {{RELEVANT_SECTION}}
- {{ADDITIONAL_INPUT}}

**Output:**

<!--
Describe the single reviewable diff this task produces.
Be specific: name the file and the logical change.
State what interface, if any, this task produces for downstream tasks.
Do not say "implement X". Say what changes in which file and what contract
is produced.
-->

{{TASK_1_OUTPUT_DESCRIPTION}}

**Done:**

<!--
List observable, binary, diff-bounded Done criteria.
Every criterion must be verifiable from this task's diff alone.
No criterion may reference a future task.
-->

- [ ] {{DONE_CRITERION_1}}
- [ ] {{DONE_CRITERION_2}}
- [ ] {{DONE_CRITERION_3}}
- [ ] Diff is under 100 lines.

---

### T2 — {{TASK_2_TITLE}}

```
Task ID:  T2
Title:    {{TASK_2_TITLE}}
```

**Input:**

- {{SOURCE_DOCUMENT_PATH}} — {{RELEVANT_SECTION}}
- T1 completed: {{FROZEN_INTERFACE_FROM_T1}}

**Output:**

{{TASK_2_OUTPUT_DESCRIPTION}}

**Done:**

- [ ] {{DONE_CRITERION_1}}
- [ ] {{DONE_CRITERION_2}}
- [ ] {{DONE_CRITERION_3}}
- [ ] Diff is under 100 lines.

---

### T3 — {{TASK_3_TITLE}}

**Highest-risk task**

<!--
HIGHEST-RISK RULES (STD-007 Section 10):
- Exactly one task in the decomposition must be marked Highest-risk.
- Add a one-sentence risk statement immediately after this annotation.
- The risk statement must name the preserved behaviour at risk and the
  specific implementation mistake that would cause the regression.
-->

*{{ONE_SENTENCE_RISK_STATEMENT}}*

```
Task ID:  T3
Title:    {{TASK_3_TITLE}}
```

**Input:**

- {{SOURCE_DOCUMENT_PATH}} — {{RELEVANT_SECTION}}
- T1 completed: {{FROZEN_INTERFACE_FROM_T1}}

**Output:**

{{TASK_3_OUTPUT_DESCRIPTION}}

**Done:**

- [ ] {{DONE_CRITERION_1}}
- [ ] {{DONE_CRITERION_2}}
- [ ] {{DONE_CRITERION_3}}
- [ ] Diff is under 100 lines.

---

### T4 — {{TASK_4_TITLE}}

```
Task ID:  T4
Title:    {{TASK_4_TITLE}}
```

**Input:**

- {{SOURCE_DOCUMENT_PATH}} — {{RELEVANT_SECTION}}
- {{PRIOR_TASK_DEPENDENCY}}

**Output:**

{{TASK_4_OUTPUT_DESCRIPTION}}

**Done:**

- [ ] {{DONE_CRITERION_1}}
- [ ] {{DONE_CRITERION_2}}
- [ ] Diff is under 100 lines.

---

<!--
Add T5–T8 as needed. Total task count: 4–8.
Delete unused task blocks before publishing.
The final task is typically the assembly / version increment / spec update
task that is gated by approval and assembles all prior diffs.
-->

---

## Annotations

**FIRST SLICE:** T1

<!--
Explain why T1 is the First Slice. State:
- Which acceptance criterion or behavioural path it implements end-to-end.
- What interface it produces that unblocks downstream tasks.
- Why this is the minimal reviewable unit that confirms the decomposition
  direction.
-->

{{FIRST_SLICE_RATIONALE}}

**Highest-risk task:** T3

<!--
State the one-sentence risk explanation. This must match the annotation
on T3 above.
-->

{{HIGHEST_RISK_RATIONALE}}

---

## Interface Contracts

### Seam 1 — T1 → {{CONSUMING_TASKS}}

**Producer:** T1 produces the {{INTERFACE_NAME}} interface.
**Consumers:** {{CONSUMING_TASK_IDS}} consume the {{PRODUCED_VALUES}}.
**The interface is frozen after T1 is reviewed and accepted.**

Contract:

```
{{INTERFACE_FIELD_1}}: {{TYPE_AND_CONSTRAINT}}
{{INTERFACE_FIELD_2}}: {{TYPE_AND_CONSTRAINT}}
```

{{CONSUMPTION_RULE}}

---

### Seam 2 — T2 → {{CONSUMING_TASKS}}

**Producer:** T2 defines the {{OUTPUT_CONTRACT_NAME}}.
**Consumer:** {{CONSUMING_TASK_ID}} verifies {{WHAT_IS_VERIFIED}}.
**The {{OUTPUT_CONTRACT_NAME}} is frozen after T2 is reviewed and accepted.**

Contract:

```
{{CONTRACT_DESCRIPTION}}
```

---

<!--
Add seams for every inter-task dependency.
Every seam must state: producer, consumers, freeze point, and the contract.
-->

---

## Dependency Graph

<!--
A directed acyclic graph showing all tasks and their dependencies.
Recommended format: Mermaid graph TD.
Every task must appear as a node.
Every dependency must appear as a directed edge.
Annotations (FIRST SLICE, HIGHEST RISK) should appear in node labels.
-->

```mermaid
graph TD
    T1["T1<br/>{{T1_TITLE}}<br/>FIRST SLICE"]
    T2["T2<br/>{{T2_TITLE}}"]
    T3["T3<br/>{{T3_TITLE}}<br/>HIGHEST RISK"]
    T4["T4<br/>{{T4_TITLE}}"]

    T1 -->|{{INTERFACE_LABEL}}| T2
    T1 -->|{{INTERFACE_LABEL}}| T3
    T2 -->|{{INTERFACE_LABEL}}| T4
    T3 -->|{{INTERFACE_LABEL}}| T4
```

---

## Engineering Review

<!--
RULES (STD-007 Section 11):
- Every challenge must be answered with rationale.
- State what was checked and what was found.
- Do not answer "yes" without explaining what was examined.
- Any problem found during the review must produce a task restructure
  before the decomposition is submitted for human review.
-->

### Challenge 1 — Does every task fit in one afternoon?

| Task | Estimate | Justification |
|---|---|---|
| T1 | {{ESTIMATE}} | {{JUSTIFICATION}} |
| T2 | {{ESTIMATE}} | {{JUSTIFICATION}} |
| T3 | {{ESTIMATE}} | {{JUSTIFICATION}} |
| T4 | {{ESTIMATE}} | {{JUSTIFICATION}} |

{{CHALLENGE_1_CONCLUSION}}

---

### Challenge 2 — Does every task produce a diff below 100 lines?

| Task | Expected diff scope |
|---|---|
| T1 | {{SCOPE_DESCRIPTION}} |
| T2 | {{SCOPE_DESCRIPTION}} |
| T3 | {{SCOPE_DESCRIPTION}} |
| T4 | {{SCOPE_DESCRIPTION}} |

{{CHALLENGE_2_CONCLUSION}}

---

### Challenge 3 — Does any task say "implement everything"?

{{CHALLENGE_3_ANSWER}}

---

### Challenge 4 — Are seams explicit?

{{CHALLENGE_4_ANSWER}}

---

### Challenge 5 — Does the FIRST SLICE implement only one acceptance criterion?

{{CHALLENGE_5_ANSWER}}

---

## Verification Report

<!--
Complete this section last. Every row must be checked.
A blank row is a failing row.
-->

| Requirement | Met | Evidence |
|---|---|---|
| Task count is between 4 and 8 | {{YES/NO}} | {{NOTE}} |
| Each task has Task ID, Title, Input, Output, Done | {{YES/NO}} | {{NOTE}} |
| Every task produces a reviewable diff under 100 lines | {{YES/NO}} | {{NOTE}} |
| Every task is independently reviewable | {{YES/NO}} | {{NOTE}} |
| Tasks depend only on previously completed tasks | {{YES/NO}} | {{NOTE}} |
| Exactly one FIRST SLICE marked | {{YES/NO}} | {{NOTE}} |
| FIRST SLICE is one AC end-to-end under 100 lines | {{YES/NO}} | {{NOTE}} |
| Highest-risk task identified with one-sentence explanation | {{YES/NO}} | {{NOTE}} |
| Interface Contracts section present | {{YES/NO}} | {{NOTE}} |
| Each seam names producer, consumers, and freeze point | {{YES/NO}} | {{NOTE}} |
| Dependency graph present and acyclic | {{YES/NO}} | {{NOTE}} |
| Engineering Review challenges all five criteria | {{YES/NO}} | {{NOTE}} |
| No task says "implement everything" | {{YES/NO}} | {{NOTE}} |
| No {{PLACEHOLDER}} tokens remaining | {{YES/NO}} | {{NOTE}} |

**Decomposition status:** {{READY FOR REVIEW / NOT READY — [N] items require attention}}

---

*No implementation. Planning artefact only.*
