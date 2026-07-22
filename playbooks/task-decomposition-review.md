---
asset_id: PB-003
asset_type: Playbook
title: Task Decomposition Review Playbook
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-007
  - ADR-007
  - ADR-009
related:
  - TPL-TD-001
  - TPL-TD-002
  - WF-005
  - AUTO-003
tags:
  - task-decomposition
  - review
  - playbook
  - interface-contracts
  - first-slice
  - seam-identification
---

# Task Decomposition Review Playbook

## Purpose

This playbook guides an engineer through the process of decomposing
engineering work into independently reviewable tasks and reviewing that
decomposition for completeness. It applies whether the engineer is the
decomposition author performing a self-challenge or an independent reviewer
evaluating a submitted decomposition.

The playbook is technology-agnostic. It applies to any engineering change —
new feature, brownfield amendment, refactoring, or migration — regardless
of language, deployment model, domain, or team structure.

---

## Before You Begin

### Confirm your preparation

Answer these questions before starting decomposition or review:

| Question | If no |
|---|---|
| Have you read the approved source document in full? | Read it now. Do not decompose or review a document you have not read in full. |
| Have you read STD-007 (Engineering Task Decomposition Standard)? | Read Section 1 (Philosophy), Section 9 (First Slice), and Section 10 (Highest-Risk) at minimum. |
| Do you have the plan.md template (TPL-TD-001) and tasks.md template (TPL-TD-002) available? | Obtain them before beginning. |

---

## 1. How to Decompose Engineering Work

### Step 1 — Read before you plan

Read the approved source document twice before writing a single task:

- **First read:** Understand the intended capability. Note what is added,
  modified, or removed.
- **Second read:** Identify the logical sections. Each section that
  introduces a distinct engineering concern is a component candidate.

A common mistake is to begin task-writing during the first read. This
produces tasks shaped by the reading order rather than by the engineering
structure.

### Step 2 — Identify implementation components first

Fill `plan.md` before `tasks.md`. Components are higher-level than tasks.
A component represents one engineering concern. A task implements one
component (or a sub-concern of one component).

Ask for each section of the source document:

- "What engineering concern does this section introduce?"
- "What is the output that downstream work depends on?"
- "What does this concern consume from upstream?"

### Step 3 — Find the natural seams

Natural seams are the points in the design where the output of one concern
becomes the input of another. Seams determine task boundaries.

**Four techniques for finding seams:**

**Technique A — Follow the primary signal.**
Identify the primary value that the change produces (a classification, a
flag, a formatted section, a test result). The task that first produces
this value is a natural seam boundary. Every task that depends on this
value must be on the downstream side.

**Technique B — Ask "what has to be true before I can start?"**
For each piece of implementation work, ask what must already exist for it
to begin. The answer identifies its dependencies. Work backwards from the
most downstream task. Each "must exist" statement identifies a seam.

**Technique C — Identify conditional behaviour.**
When a change adds behaviour that only activates under a condition, the
condition evaluation and the conditional behaviour are often separable.
The condition gate belongs upstream; the conditional behaviour belongs
downstream.

**Technique D — Separate implementation from verification.**
Test evidence (acceptance criteria definition, test case authoring) is
always a separate concern from the behaviour being tested. When test
evidence must be produced alongside behaviour, they may share a task —
but the seam should still be considered. In a decomposition where tests
are separate artefacts, they always belong to their own task.

### Step 4 — Size your tasks

Every task must produce a diff under 100 lines and be reviewable in one
afternoon. Before writing a task, estimate its size.

If the estimate exceeds 100 lines:

1. Ask: "Does this task address more than one concern?"
2. If yes: split at the concern boundary.
3. If no: look for a natural midpoint in the concern where the system is
   in a valid intermediate state. Split there.

A valid intermediate state means: all existing tests pass, existing
acceptance criteria are satisfied, and the system behaves correctly for
all previously supported inputs.

### Step 5 — Write Done criteria before the Output section

Write Done criteria first. The Done criteria define what "correct" means
for the task. The Output section then describes the diff that satisfies
those criteria.

When Done criteria are written after the Output section, they tend to
describe what was implemented rather than what was required. This produces
Done criteria that are satisfied by definition and cannot catch errors.

---

## 2. How to Identify Seams

A seam is the interface between two tasks. A well-identified seam has
three properties:

1. **It is named.** The seam has a label that both the producer task and
   the consumer task can reference.

2. **It is typed.** The value crossing the seam has a defined type,
   vocabulary, or format. Examples: a boolean flag, an enumeration token,
   a formatted string, a structured record.

3. **It is frozen at a specific moment.** The seam is frozen when the
   producer task is reviewed and accepted. After freezing, the seam may
   not change without re-reviewing all consumer tasks.

### Common seam types

| Seam type | Example | How it is produced |
|---|---|---|
| Classification result | `risk_level: "LOW" / "MEDIUM" / "HIGH" / "CRITICAL"` | Task that implements the classification logic |
| Activation flag | `feature_active: boolean` | Task that adds the conditional branch or configuration |
| Section format | Fixed structure for a named output section | Task that defines the output section rendering rule |
| Test fixture | Synthetic input data shared by acceptance criterion tasks | Task that defines the fixtures |
| Version boundary | Spec or config file at version N+1 | Terminal assembly task after all other tasks complete |

### How to verify a seam is well-defined

Ask:
- Could a consumer task author write their implementation against this
  seam description alone, without reading the producer task's diff?
- If the seam changes, is it clear exactly which consumer tasks must be
  re-reviewed?
- Is there any ambiguity about what the produced value means?

If any answer is "no", the seam needs further definition.

---

## 3. How to Discover Natural Interfaces

A natural interface is a seam that exists in the design of the capability,
not one invented to make the decomposition work. Natural interfaces are
stable. Invented interfaces break.

### How to find natural interfaces

**Source document structure.** The source document's section headings are
often natural interface boundaries. A section that defines "what value X
is" produces an interface. A section that defines "what happens when X has
value Y" consumes it.

**Acceptance criteria dependency.** An acceptance criterion that says
"the output includes annotation A when condition C is true" implies two
natural interfaces: the interface that carries C (from classification logic),
and the interface that carries A (from the output formatter). These are
separate seams.

**The "downstream freeze" test.** For any two adjacent tasks, ask: "If the
upstream task's implementation changes, does the downstream task's
implementation need to change?" If yes, there is a natural interface
between them. Define it explicitly.

### Red flags for invented interfaces

- The seam is defined after the task list is written, not during it.
- The seam does not correspond to any value or section in the source
  document.
- The seam's "type" is a general-purpose record with many fields rather
  than a specific value.
- The seam does not match any component interface contract in `plan.md`.

---

## 4. How to Minimise Review Size

The goal is not to minimise the total work. The goal is to produce the
smallest unit of work that is meaningful to review.

### Principles

**One concern per task.** A reviewer should be able to describe the
task's purpose in one sentence. If the sentence contains "and" in a way
that introduces two distinct engineering judgements, the task has two
concerns.

**Don't include test evidence in the same task as behaviour.** When test
evidence is a separate artefact (a test file, a specification section,
an acceptance criterion definition), it belongs in its own task. Mixing
implementation and test evidence in one diff makes it harder to review
either.

**Move shared infrastructure upstream.** If multiple tasks need the same
foundational change (a new field, a new constant, a new rule), create a
separate task for the foundational change. Each consuming task then has
a smaller diff because the foundation is already in place.

**Defer the assembly task.** When multiple tasks produce changes to the
same file (e.g., a specification file, a configuration file), each task
should be scoped to one section of that file. The final task assembles
all changes and increments the version. This keeps individual diffs small
and the assembly task mechanical.

### Sizing checklist

Before submitting a task for review, verify:

- [ ] The diff touches at most two files.
- [ ] Every changed line in the diff corresponds to the task's stated concern.
- [ ] There are no "while I was in there" changes unrelated to the task.
- [ ] The estimated line count is below 100.

---

## 5. How to Identify the First Implementation Slice

The First Slice is the task that satisfies four properties simultaneously
(STD-007 Section 9). The selection process is:

### Selection procedure

**Step 1 — List the acceptance criteria from the source document.**
Every acceptance criterion represents a behavioural path that can be
implemented end-to-end.

**Step 2 — Identify the core decision logic.**
Among all acceptance criteria, one will exercise the most fundamental
decision logic of the change. This is typically the criterion that tests
the new classification, routing, or branching behaviour at its simplest.

**Step 3 — Find the minimal task that exercises that logic.**
The minimal task implementing the core decision logic is the First Slice
candidate. Verify:
- It produces the primary signal (flag, token, classification) that
  downstream tasks depend on.
- It has no dependencies on other tasks in the set.
- Its estimated diff is under 100 lines.

**Step 4 — Verify that this task unblocks the most work.**
Count how many tasks depend on this task's output. If another task has a
higher unblocking count and satisfies the first three steps, that task
is the better First Slice.

### Common mistakes in First Slice identification

| Mistake | Why it is a mistake | Correction |
|---|---|---|
| "The First Slice is the setup task" | A setup task (scaffolding, configuration) does not implement a behaviour | The First Slice must implement an observable AC end-to-end |
| "The First Slice implements two ACs to be safe" | Two ACs means two concerns | Split: implement one AC in the First Slice |
| "The First Slice is the most interesting task" | Interesting is not the same as unblocking | The First Slice is the task that unblocks the most downstream work |
| "The First Slice includes tests" | Including tests often doubles the diff size | Keep behaviour and test evidence in separate tasks unless they are trivially small together |

---

## 6. How to Identify the Highest-Risk Task

The highest-risk task is the task most likely to produce a regression in
existing behaviour if implemented incorrectly.

### Identification procedure

**Step 1 — List all preserved behaviours from the source document.**
The source document's Preserved Behaviour section (for a Brownfield Delta)
or the existing acceptance criteria (for a new specification) identify
what must not regress.

**Step 2 — For each task, ask:** "If this task is implemented incorrectly,
which preserved behaviour is most likely to break?"

**Step 3 — Apply the highest-risk indicators:**

| Indicator | Why it signals high risk |
|---|---|
| Shared trigger condition with existing behaviour | A mistake in the condition boundary silently changes both old and new behaviour |
| Unconditional constraint made conditional | An error in the condition applies the relaxed behaviour to previously constrained cases |
| Cross-cutting output change | Applies to all instances; a mistake affects every output, not only the new case |
| Cap, limit, or count modification | Numeric thresholds are easy to get right for the new case and wrong for the existing case |
| Mandatory content injection | A mandatory addition that fires on a wrong condition produces false positives for every output |

**Step 4 — Write the one-sentence risk statement.**

Format: "[Preserved behaviour] is at risk because [specific implementation
mistake] could [specific regression outcome]."

Vague: "This task might cause regressions."
Precise: "The unconditional cap is at risk because applying the raised
cap to non-CRITICAL reports would allow previously disallowed block counts
to appear in LOW/MEDIUM/HIGH outputs."

---

## 7. How to Review a Dependency Graph

### What a correct graph looks like

A correct dependency graph is:

- **Acyclic.** No task depends on a task that depends on it (directly or
  transitively).
- **Complete.** Every task appears as a node. Every inter-task dependency
  appears as an edge.
- **Labelled.** Every edge is labelled with the interface name it carries.
- **Annotated.** The First Slice node and the Highest-Risk node are
  visually distinguished.

### How to check for hidden cycles

A hidden cycle is a transitive cycle: T1 → T2 → T3 → T1. It does not
appear as a direct cycle between two tasks but exists through an
intermediate task.

To detect hidden cycles:

1. Start at every leaf task (a task with no outgoing edges).
2. Walk backwards following incoming edges.
3. If you encounter a node you have already visited in the current walk,
   you have found a cycle.

### How to check for missing edges

For each interface contract defined in the Interface Contracts section,
verify that a corresponding directed edge exists in the graph. An interface
contract with no corresponding edge is an inconsistency.

For each dependency listed in any task's Input section, verify that a
corresponding edge exists in the graph. An Input dependency with no
corresponding edge is an inconsistency.

---

## 8. Common Mistakes

### Mistake 1 — Planning without reading the source document

Decompositions produced without a full read of the source document often
miss the implicit constraints and shared boundaries that only become
apparent from reading the whole document.

**Prevention:** Complete a full read and a Source Analysis summary before
writing a single task.

### Mistake 2 — Tasks that say "implement X"

A task Output section that says "implement X" or "add the feature" is not
an Output section. It describes intention, not engineering work.

**Prevention:** Name the specific file and the specific change in every
Output section. If you cannot name the file, you do not yet understand
the task well enough to write it.

### Mistake 3 — First Slice too large

A First Slice that covers multiple acceptance criteria or produces a diff
over 100 lines is a planning failure.

**Prevention:** If the First Slice candidate exceeds 100 lines, split it
by separating the core signal production from its first consumer.

### Mistake 4 — Implicit interfaces

Tasks that depend on each other without an explicit interface contract
are the most common source of integration defects discovered during review.

**Prevention:** For every dependency between tasks, write the interface
contract before either task begins.

### Mistake 5 — Done criteria that reference future tasks

Done criteria must be verifiable from the current task's diff. A criterion
that says "will be validated in T5" is not a Done criterion; it is a note.

**Prevention:** For each Done criterion, ask: "Can I verify this from the
diff right now?" If no, rewrite or remove it.

### Mistake 6 — Highest-risk task identified vaguely

A risk statement that says "this is risky because it touches important
code" does not help reviewers or implementers.

**Prevention:** Name the preserved behaviour that is at risk, the specific
implementation mistake, and the specific regression outcome.

### Mistake 7 — Assembly task not separated from behaviour tasks

When multiple tasks produce changes to the same file, mixing assembly work
into behaviour tasks makes each diff harder to review.

**Prevention:** Create a dedicated final task that assembles all approved
diffs and increments the version. Gate this task on approval of all
preceding tasks.

### Mistake 8 — Engineering Review done last as a formality

Engineering Review answers "yes" without examination rationale.

**Prevention:** For each challenge, describe what was examined, what was
found, and what was explicitly excluded with the reason for exclusion.

---

## 9. Decomposition Review Completion Checklist

Before submitting the decomposition for independent review, verify:

- [ ] `plan.md` is complete with no `{{PLACEHOLDER}}` tokens.
- [ ] `tasks.md` is complete with no `{{PLACEHOLDER}}` tokens.
- [ ] Task count is between 4 and 8.
- [ ] Every task has Task ID, Title, Input, Output, and Done sections.
- [ ] Every Done criterion is observable, binary, and diff-bounded.
- [ ] T1 is marked as FIRST SLICE with a rationale.
- [ ] Exactly one task is marked as Highest-risk with a one-sentence statement.
- [ ] Every inter-task dependency has a named interface contract.
- [ ] Dependency graph is present and acyclic.
- [ ] All five Engineering Review challenges are answered with rationale.
- [ ] All Verification Report rows are evaluated as PASS.
- [ ] No task says "implement everything."
- [ ] Source document items trace to components in `plan.md`.
- [ ] Components in `plan.md` trace to tasks in `tasks.md`.

A checklist item left blank is the same as FAIL for the purpose of
this review.
