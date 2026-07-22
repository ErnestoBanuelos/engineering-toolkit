---
asset_id: STD-007
asset_type: Standard
title: Engineering Task Decomposition Standard
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - ADR-002
  - ADR-003
  - ADR-005
  - ADR-007
  - ADR-009
  - ADR-010
  - STD-004
  - STD-006
related:
  - TPL-TD-000
  - TPL-TD-001
  - TPL-TD-002
  - WF-005
  - PB-003
  - AUTO-003
tags:
  - task-decomposition
  - implementation-planning
  - reviewability
  - interface-contracts
  - first-slice
---

# Engineering Task Decomposition Standard

## Purpose

This standard defines how an approved specification or Brownfield Delta is
decomposed into independently reviewable implementation tasks. It applies to
any engineering change — new feature, brownfield amendment, or refactoring —
regardless of technology stack, language runtime, team structure, or domain.

A task decomposition is the primary artefact that authorises the order and
scope of implementation work. Implementation that proceeds without a task
decomposition risks producing changes too large to review, changes whose
dependencies are implicit, and changes where the highest-risk work is not
identified in advance.

This standard does not describe how to implement. It describes how to plan
implementation so that every change is reviewable, traceable, and safe to
integrate.

**Related ADRs:** ADR-002 (Engineering Asset Model), ADR-005 (Skill Authoring
Standard), ADR-007 (Repository Governance), ADR-009 (Evidence and Verification
Model), ADR-010 (Execution Architecture).

---

## 1. Decomposition Philosophy

Task decomposition is the discipline of translating a specification into a
sequence of independently reviewable changes, each of which leaves the system
in a working state.

The decomposition must satisfy four properties simultaneously:

**Independent reviewability.** Every task must be reviewable in isolation
by a human who has not seen the other tasks. A reviewer must be able to
assess whether a task is correct without reading the implementation of any
other task.

**Explicit interfaces.** The output contract of every task that is consumed
by another task must be named, versioned, and frozen before the consuming
task begins. Implicit interfaces are a primary source of integration defects.

**Minimum viable first change.** The first task in the sequence must be the
smallest change that delivers one end-to-end acceptance criterion, confirms
the core logic, and unblocks all subsequent tasks. This is the First Slice.

**Risk-forward ordering.** The task that carries the highest regression risk
must be identified before implementation begins, not discovered during
integration. Risk identification is a planning activity, not an incident
response.

---

## 2. Reviewable Task Sizing

Every task must produce a reviewable diff that a human reviewer can evaluate
in a single sitting.

### 2.1 Diff Size Target

| Measure | Target |
|---|---|
| Lines changed per task | ≤ 100 lines |
| Expected review duration | ≤ one afternoon |
| Concerns addressed per task | Exactly one |

A task that exceeds 100 lines is a signal that the task has multiple concerns
and must be split. Exceptions require documented rationale.

### 2.2 One Concern Per Task

Every task addresses exactly one engineering concern. Examples of single
concerns:

- Classification logic (one decision rule set).
- Output section format (one output section's rendering contract).
- Validation rule (one constraint's enforcement).
- Test evidence (acceptance criteria for one behavioural path).
- Specification amendment (assembly of previously reviewed diffs).

A task that contains the words "and also" in its description is a candidate
for splitting.

### 2.3 Self-Contained Working State

Every task, when applied, must leave the system in a state that passes all
existing tests and fulfils all previously established acceptance criteria.
A task may not intentionally break the system and rely on a future task to
restore it.

---

## 3. Independent Reviewability

A task is independently reviewable when a reviewer can evaluate its
correctness without:

- Reading the implementation of any other task in the set.
- Understanding the planned future state of the system.
- Making assumptions about what other tasks will change.

### 3.1 How to Verify Independent Reviewability

For each task, ask:

1. Could a reviewer assess whether this task's Done criteria are satisfied
   from the diff alone?
2. Does this task consume any output that has not yet been produced by a
   prior task?
3. Does this task's correctness depend on a change that is made in a later
   task?

If any answer is "yes", the task is not independently reviewable and must
be restructured.

### 3.2 Dependency Direction

Dependencies are always backward-looking. A task may only depend on tasks
that have been completed and reviewed. A task must never depend on a future
task.

---

## 4. Task Boundaries

A task boundary is the line between what one task changes and what the next
task changes. Boundaries must be explicit, not emergent.

### 4.1 Identifying Natural Boundaries

Natural boundaries exist at:

- **Logical sections of a specification.** Each section of a specification
  often corresponds to one concern. A change to the classification logic is
  a different concern from a change to the output format of the same section.

- **Consumer/producer relationships.** When one part of the system produces
  a value that another part consumes, the seam between producer and consumer
  is a natural task boundary.

- **Conditional behaviour additions.** When a change adds behaviour that
  only activates under a specific condition, the activation condition (the
  gate) and the conditional behaviour (the consequence) may be separate
  concerns assignable to separate tasks.

- **Verification coverage.** Test evidence for a behaviour is always a
  separate task from the behaviour itself, unless the test is an inline
  acceptance criterion that can be evaluated without a separate test
  artefact.

### 4.2 Anti-Patterns for Boundaries

| Anti-pattern | Problem | Correction |
|---|---|---|
| "Front-end and back-end in one task" | Two components with different reviewers | Split at the API boundary |
| "Logic and tests in one task" | Reviewer cannot tell what is verified | Separate logic task from test evidence task |
| "All error handling in one task" | Too many concerns; diff too large | One error code per task or group adjacent errors by cause |
| "Configuration and behaviour in one task" | Different reviewers for config and logic | Separate configuration change from behavioural change |

---

## 5. Task Identifiers

Every task must have a stable identifier that is unique within the
decomposition.

### 5.1 Identifier Format

```
T<N>
```

where `<N>` is a monotonically increasing integer starting at 1.

Examples: `T1`, `T2`, `T3`.

Identifiers must not be reused within a decomposition. If a task is
cancelled, its identifier is retired and not reassigned.

### 5.2 Reference Stability

Once a task identifier has been used in an interface contract or a dependency
declaration, it must remain stable throughout the decomposition lifecycle.
Renumbering tasks after interface contracts have been established introduces
traceability errors.

---

## 6. Input / Output / Done Contract

Every task must define three sections: Input, Output, and Done.

### 6.1 Input Section

The Input section lists every artefact the task author needs to begin work.

Required entries:

- Source specification or delta document (file path and section reference).
- Completed prior tasks that this task depends on (identified by Task ID).
- Any interface contracts frozen by prior tasks that this task consumes.

A task whose Input lists an artefact that does not yet exist must be
reordered: it cannot begin until the prerequisite artefact is produced.

### 6.2 Output Section

The Output section describes the single reviewable diff this task produces.

The Output must state:

- Which files are changed.
- What logical change is made to each file.
- What interface, if any, this task produces for downstream tasks to consume.

A task whose Output section says "implement the feature" is not a valid
Output section. The Output must describe a specific, bounded change.

### 6.3 Done Criteria

The Done section contains a checklist of observable conditions that must be
satisfied for the task to be considered complete.

Done criteria must be:

- **Observable.** Each criterion describes something that can be verified
  from the diff without executing the system.
- **Binary.** Each criterion is either satisfied or not. No partial credit.
- **Sufficient.** Satisfying all Done criteria constitutes a complete,
  correct task execution.
- **Diff-bounded.** Every criterion refers to something in the task's own
  diff, not in a future task's diff.

---

## 7. Interface Contracts

An interface contract is an explicit agreement between a task that produces
a value and one or more tasks that consume it.

### 7.1 What Requires an Interface Contract

An interface contract is required when:

- A task produces a value, flag, or output format that another task
  depends on.
- A task changes a section format that a later task's acceptance criteria
  will verify.
- A task introduces a rule or constraint that a later task's logic assumes
  to exist.

### 7.2 Interface Contract Structure

Every interface contract must state:

| Field | Content |
|---|---|
| Producer task | The Task ID that produces this interface |
| Consumer tasks | The Task IDs that consume this interface |
| Interface description | The name, type, and meaning of the produced value |
| Freeze point | The moment after which the interface may not change without versioning |

### 7.3 Interface Freeze Rule

Once a task that produces an interface is reviewed and accepted, the
interface is frozen. A downstream task that requires a change to a frozen
interface must:

1. Raise the change as a new task.
2. Update the interface contract before the downstream task begins.
3. Reversion all tasks that depend on the changed interface.

---

## 8. Dependency Management

### 8.1 Dependency Declaration

Every task must explicitly declare its dependencies using Task IDs.

```
Depends on: T1, T2
```

A task with no declared dependencies may begin at any time. A task with
declared dependencies must not begin until all declared dependencies are
in `Completed` status.

### 8.2 Dependency Graph

Every decomposition must include a dependency graph. The graph must:

- Show every task as a node.
- Show every dependency as a directed edge.
- Be acyclic. A cycle in the dependency graph is an error that must be
  resolved before implementation begins.

Recommended format: Mermaid `graph TD` or equivalent directed-graph notation.

### 8.3 Parallelism

Tasks with no dependency relationship between them may be executed in
parallel. The decomposition must identify parallel opportunities to avoid
artificial serialisation.

However, tasks that produce interfaces consumed by other tasks must always
complete before the consuming tasks begin, regardless of whether parallel
execution is otherwise possible.

---

## 9. First Slice Philosophy

The First Slice is the single task in the decomposition that satisfies all
of the following properties simultaneously:

1. **Implements exactly one acceptance criterion end-to-end.** The First
   Slice exercises the core logic for one behavioural path from input to
   output. It does not implement all paths.

2. **Produces a diff under 100 lines.** The First Slice is the smallest
   possible working change that confirms the decomposition direction is
   correct.

3. **Unblocks the most downstream work.** The First Slice produces the
   interface or establishes the pattern that the maximum number of
   subsequent tasks depend on.

4. **Is independently reviewable.** The First Slice can be reviewed and
   merged without any other task in the set.

### 9.1 How to Identify the First Slice

Apply the following selection criteria in order:

1. Identify the task that touches the core classification, routing, or
   decision logic of the change. This task produces the primary output
   signal (e.g., a flag, a token, or a classification result) that all
   other behaviour depends on.

2. Verify that this task's diff is under 100 lines. If not, split the
   task further.

3. Verify that this task has no dependencies on other tasks in the set.
   If it does, the dependency may itself be a better First Slice candidate.

### 9.2 Why First Slice Matters

The First Slice is the earliest point at which an independent reviewer can
validate that the decomposition direction is sound. Identifying it correctly
means that a blocking error in the decomposition is detected after the
minimum possible investment.

A First Slice that implements too much is a planning failure, not an
implementation shortcut.

---

## 10. Highest-Risk Task Identification

Every decomposition must identify exactly one task as the highest-risk task.

### 10.1 Definition

The highest-risk task is the task most likely to produce a regression in
previously working behaviour if implemented incorrectly.

Highest-risk tasks are typically found at:

- **Shared trigger conditions.** A task that modifies logic shared between
  the new behaviour and existing behaviour.
- **Conditional constraint relaxations.** A task that changes a constraint
  from unconditional to conditional. An error in the condition can apply
  the relaxed behaviour to cases that should remain constrained.
- **Cross-cutting output changes.** A task that modifies an output section
  or format rule that applies to all instances, not only the new case.
- **Cap, limit, or threshold modifications.** A task that changes a numeric
  cap or limit that is consumed by multiple output paths.

### 10.2 Risk Statement Requirement

The highest-risk task must carry a one-sentence risk statement that:

- Names the preserved behaviour that is at risk.
- Identifies the specific implementation mistake that would cause the
  regression.

A vague risk statement ("this task might break things") does not satisfy
this requirement.

---

## 11. Engineering Review Expectations

Every decomposition must include an Engineering Review that self-challenges
the decomposition before implementation begins.

### 11.1 Required Challenges

The Engineering Review must address every item in the following checklist:

| Challenge | Pass condition |
|---|---|
| Every task fits in one afternoon | Estimated review duration ≤ one afternoon for each task |
| Every task produces a diff under 100 lines | Estimated line count ≤ 100 for each task |
| No task says "implement everything" | Every task is scoped to exactly one concern |
| Seams are explicit | Every interface contract has a named producer, consumer, and freeze point |
| First Slice implements only one acceptance criterion | First Slice diff ≤ 100 lines; produces one observable end-to-end result |
| Dependency graph is acyclic | No cycles exist; all dependencies are backward-looking |
| Highest-risk task is identified | One task is marked with a one-sentence risk statement |

### 11.2 Challenging Your Own Decomposition

Apply the following questions to every task before declaring the review
complete:

- "Can this task be split further while still leaving the system in a
  working state after each split?"
- "Does this task's Done section contain a criterion that depends on a
  future task?"
- "Is the interface produced by this task consumed by a task that has
  not been accounted for?"
- "Is there a preserved behaviour from the specification that this task's
  output could accidentally change?"

A question that reveals a problem must produce a task restructure before
the decomposition is submitted for human review.

---

## 12. Anti-Patterns

The following practices violate this standard and must be corrected before
a task decomposition is approved.

| Anti-pattern | Description | Correction |
|---|---|---|
| Monolithic first task | The first task implements the majority of the change | Identify the First Slice: the smallest change that confirms direction |
| Implicit interface | A task produces a value consumed by another task but no interface contract is defined | Define the interface contract before either task begins |
| Backward dependency | A task depends on a task that has not yet been completed | Reorder; a task may only depend on completed predecessor tasks |
| Vague Output section | The Output section says "implement X" without specifying which files change and what changes | Rewrite: name the file, the section, and the specific change |
| Done criteria that reference future tasks | A criterion says "will be verified when T5 is complete" | Rewrite: every Done criterion must be verifiable from the task's own diff |
| Missing highest-risk identification | No task is marked as highest-risk | Apply Section 10 criteria; mark one task with a one-sentence risk statement |
| Missing dependency graph | Tasks are listed without a dependency graph | Produce a directed acyclic graph before submitting for review |
| First Slice that implements too much | First Slice exceeds 100 lines or covers multiple acceptance criteria | Split: the First Slice must implement exactly one AC end-to-end |
| Circular interface dependency | Task T3 waits for an interface from T4 and T4 waits for an interface from T3 | Break the cycle: one task must produce its interface unconditionally |
| Tasks that cannot be reviewed independently | A task's correctness can only be assessed by reading another task | Split at the dependency boundary; introduce an explicit interface |

---

## 13. Decomposition Lifecycle

Task decompositions follow the Engineering Asset lifecycle defined in ADR-002.

| State | Trigger | Gate |
|---|---|---|
| Draft | Author begins decomposition | None |
| In Review | Author submits for independent review | Reviewer assigned who did not author |
| Reviewed | Review complete; no blocking findings | Engineering Review checklist satisfied |
| Approved | Named human approver signs off | ADR-007 L3 governance; approver ≠ author |
| Implementation Active | Implementation begins task by task | Approved state required |
| Superseded | A replacement decomposition is approved | Reference to successor required |

A decomposition in Draft state must not govern implementation.

---

## 14. Relationship to Other Standards

| Standard | Relationship |
|---|---|
| STD-004 — Engineering Specification Standard | A task decomposition derives its tasks from an approved specification |
| STD-006 — Brownfield Delta Standard | A task decomposition may derive from a Brownfield Delta |
| ADR-005 — Skill Authoring Standard | Tasks decompose Skills; Skills may invoke other Skills as components |
| ADR-010 — Execution Architecture | Each task corresponds to one or more Execution Units; interface contracts align with Context Bundle requirements |

---

## 15. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.6 kata execution |
