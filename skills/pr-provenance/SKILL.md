---
id: SKILL-PRV-001
title: "PR Provenance"
type: Skill
status: Approved
version: 1.0.0
created: 2026-07-23
updated: 2026-07-23
owner: ""
maintainer: ""
domain: review
tags:
  - pull-request
  - provenance
  - traceability
  - evidence
  - review
  - ai-assisted
depends_on: []
related:
  - review/seven-lenses
  - skills/adversarial-review
  - verification/independent-test
supersedes: ""
superseded_by: ""
---

# Skill — PR Provenance

---

## Purpose

Make the engineering record behind a change visible at the point of review.

A Pull Request description is the only artifact that ties a code change to the full
engineering process that produced it. In practice, most PR descriptions contain a title,
a summary paragraph, and a checklist of self-attestations. The reviewer has no way to
independently verify the claims being made.

This is acceptable when the change is trivial and the engineer is known to the reviewer.

It is not acceptable when:

- The change was AI-assisted and the reviewer cannot distinguish the AI's reasoning from
  the engineer's decisions.
- The change spans multiple sessions and the reviewer does not know what context was
  loaded, what was verified, or what decisions were deferred.
- The change touches a safety-relevant, financial, or compliance-sensitive path where
  independent reproducibility of the engineering process matters.

PR Provenance solves this by producing a structured, evidence-backed PR description — a
**provenance package** — that allows a reviewer to evaluate the change using the same
engineering record that produced it.

The objective is singular:

> A reviewer who never participated in the implementation should be able to approve the
> change with confidence, using only the repository evidence.

---

## Scope

### When to use

Apply this Skill when preparing a Pull Request for any of the following:

- A change produced in whole or in part by an AI assistant.
- A change to a safety-relevant path (authentication, authorization, financial
  calculations, audit logic, data validation).
- A change accompanied by a specification, delta, or formal review artefact.
- A change where the reviewer was not present for the implementation session.
- Any change where the engineering process needs to be independently reproducible.

### When not to use

- For trivial single-line changes or configuration updates where the full engineering
  record would be disproportionate to the scope.
- As a substitute for code review. Provenance is a complement to review, not a
  replacement.
- When the repository has no specification or engineering artefacts to link. If no
  evidence exists, the right response is to produce the evidence first, not to produce
  a provenance document that references nothing.

### Relationship to other practices

| Practice | Relationship |
|---|---|
| Code review | PR Provenance provides the context that makes code review more effective. It does not substitute review. |
| Seven-Lens Engineering Review | If conducted, the review report is a primary linked evidence artefact. |
| Adversarial Review | If conducted, the adversarial pass verdict and any fixes applied are recorded in the provenance. |
| Independent Verification | Gate results are recorded in the Verification Gates section. |
| Specification-Driven Development | The specification and delta are the primary evidence sources for the Context Loaded and SDD Approach sections. |

---

## Inputs

| Input | Required | Description |
|---|---|---|
| Implementation artefacts | Yes | The source files modified by the change under review. |
| Engineering evidence artefacts | Yes | Any combination of: specification, delta, plan, task list, session log, review report, ADR. At least one must exist. |
| Verification gate results | Yes | Results of linting, type checking, and automated tests. |
| Human decision record | Yes | The decisions made by the human engineer that are not attributable to tooling or AI. |
| AI tool and model record | If AI-assisted | The AI client and model used, and approximate execution dates. |
| Known limitations | Yes | Honest documentation of what the change does not do, does not cover, or explicitly defers. |

---

## Preconditions

1. The change is ready for review. Code is complete, committed, and pushed to the review
   branch.
2. Verification gates have been run (linting, type checking, automated tests) and their
   results are available.
3. At least one engineering evidence artefact exists and is committed to the repository.
   The provenance document must cite evidence that a reviewer can independently access.
4. The author has identified all human decisions made during the engineering process that
   are not self-evident from the code or artefacts.

---

## Procedure

### Step 1 — Summarize the implementation

Write a concise opening summary covering three things:

1. **What changed** — the specific modules, functions, or behaviours affected.
2. **Why the change exists** — the engineering or product requirement that motivated it.
3. **What engineering value it provides** — what is improved, fixed, or made possible.

The summary must be specific. Generic descriptions ("improved the service", "fixed a bug")
do not give reviewers the context they need to evaluate the change.

**Good:**
> `classify_risk()` was extended with two CRITICAL trigger paths following the five-priority
> evaluation table in `spec §1.2`. The PDB-presence boundary condition prevents a
> replica-count reduction from producing CRITICAL when no PodDisruptionBudget exists in
> State A. 90 tests cover all acceptance criteria and the proof test for the HIGH/CRITICAL
> boundary condition.

**Poor:**
> Added CRITICAL classification support and tests.

---

### Step 2 — Assemble provenance

Collect the following fields. Every field must be filled from actual evidence. No field
may contain a placeholder when the document is published.

#### Tool / Model

Record the AI client, model name, and approximate execution dates if the change was
AI-assisted.

If no AI tool was used, state that explicitly: `Not AI-assisted — all implementation is
human-authored.`

**Good:**
> AI client: [tool name]. Model: [model identifier]. Execution dates: 2026-07-22 to
> 2026-07-23.

**Poor:**
> AI-assisted.

**Why this field exists:** A reviewer evaluating an AI-assisted change needs to know which
model made which suggestions. Model capabilities and failure modes are not uniform. A
change produced by a reasoning model under human supervision is a different engineering
artifact than a change generated by an autocomplete assistant with no specification.

#### Context Loaded

Identify the implementation files primarily modified. List the most important supporting
files actually referenced — not every file in the repository.

State which engineering practices were applied: specification-driven development,
independent verification, formal review.

**Good:**
> Primary: `src/payments/processor.py`. Supporting: `specs/payment-processing/spec.md
> v2.1`, `changes/retry-policy/delta.md`, `tests/test_processor.py`. Engineering
> practices: Specification-Driven Development, Independent Verification (Tier C).

**Poor:**
> All project files.

**Why this field exists:** A reviewer cannot evaluate whether the right context was loaded.
This field documents what information was available to the author — and therefore what
information the author could not have had. Gaps are as important as presence.

#### Verification Gates

List every verification gate with a clear PASS or FAIL result. Include the tool name and
the command used where relevant.

At minimum document:

- Static analysis (linting)
- Type checking (if applicable to the language)
- Automated tests (count and result)
- Any additional quality gates (coverage threshold, integration tests, contract tests)
- Independent Verification (if conducted), with isolation tier
- Engineering review results (Seven-Lens, Adversarial, or equivalent)

**Good:**
> | Gate | Command | Result |
> |---|---|---|
> | Linting | `ruff check .` | PASS — 0 errors |
> | Type checking | `mypy src` | PASS — 0 issues |
> | Unit tests | `pytest` | PASS — 246/246 |
> | Independent Verification | K-series verification protocol | PASS — Tier C |
> | Seven-Lens Review | Manual | REQUEST CHANGES — 22 findings, 0 blockers |

**Poor:**
> Tests pass.

**Why this field exists:** Self-attestation ("tests pass") is not evidence. A gate result
is evidence. A reviewer should be able to independently reproduce any gate listed here.

#### Human Decisions

Document the decisions made by the human engineer that are not derivable from the
specification, the delta, or the tooling.

Each decision entry must contain:
- The decision taken.
- Why it was taken (the reasoning, not just the outcome).
- What alternatives were considered and rejected (if applicable).

**Good:**
> **Decision: Accept negative-value cost inputs as out-of-scope.**
> The specification does not define valid numeric ranges for cost fields. All reference
> figures are positive. Applying a non-negativity guard would add a constraint not
> derived from the specification. Deferred to specification clarification. Recorded in
> review document, Adversarial Pass section.

**Poor:**
> Standard engineering decisions were made.

**Why this field exists:** In AI-assisted engineering, it is often unclear where the AI's
reasoning ends and the engineer's judgment begins. This field draws that line explicitly.
It is the primary accountability field in the provenance package.

#### Known Limitations

Document honest, specific limitations of the change. Do not invent problems. Do not omit
known ones.

Each limitation must be specific. A limitation without a location or a scope boundary is
not a limitation — it is vagueness.

**Good:**
> **`rationale` field deferred from Seam 1 contract.** `classify_risk()` returns
> `RiskLevel` only. The Seam 1 interface contract defines three fields: `risk_level`,
> `critical_active`, and `rationale`. Downstream tasks T2 and T3 must not consume
> `classify_risk()` as though `rationale` is available. Recorded as Finding 1.1 (major)
> in `reviews/T1/review.md`.

**Poor:**
> Some features are not yet implemented.

**Why this field exists:** Known limitations that are undocumented become unknown
limitations the next time someone reads the code. This field preserves the author's
engineering judgment for future engineers.

#### Session Duration

Provide a reasonable approximation of the elapsed engineering time. Include the number
of sessions and their approximate duration if the work was spread across multiple sittings.

If the work was AI-assisted, distinguish between total elapsed calendar time and active
engineering time per session.

**Good:**
> Three sessions over two days. Session 1 (specification): ~90 min. Session 2
> (implementation): ~120 min. Session 3 (review + fix): ~60 min. Total active
> engineering time: approximately 4.5 hours.

**Poor:**
> A few hours.

#### SDD Approach

If the change followed Specification-Driven Development — or any equivalent practice
where specification precedes implementation — document the workflow used.

Link the specification and delta artefacts using repository-relative paths.

State the spec version that governed the implementation.

If no formal SDD workflow was followed, omit this field and explain why it was not
applicable.

**Good:**
> Specification `specs/payment-processing/spec.md` v2.1 preceded implementation.
> Delta `changes/retry-policy/delta.md` documents ADDED, MODIFIED, and REMOVED
> behaviours. Implementation was constrained to items defined in the delta.

**Poor:**
> Spec-first approach was followed.

---

### Step 3 — Collect engineering evidence

Identify every engineering artefact that supports the change. For each artefact, confirm
it exists in the repository and is accessible to the reviewer.

Recommended evidence by type:

| Evidence type | Purpose |
|---|---|
| Specification | The normative definition of the expected behaviour. Reviewers use this to verify that the implementation matches the intent. |
| Delta / Change record | Documents what changed relative to the baseline specification. Reviewers use this to verify that ADDED, MODIFIED, and REMOVED behaviours are all accounted for. |
| Implementation plan | Documents how the change was decomposed into reviewable units. Reviewers use this to verify that the implementation scope is bounded. |
| Task list | Documents the individual tasks, their completion criteria, and any interface contracts between tasks. |
| Session log | Documents the supervised engineering session: what was proposed, what was approved, and what verification gates were run during implementation. |
| Independent verification | Documents tool gate results (linting, type checking, tests) run against the implementation before review. |
| Engineering review | Documents the structured review findings: behaviour preservation, hidden assumptions, spec drift, test coverage, edge cases, security, and over-engineering. |
| Architecture Decision Records | Documents architectural decisions that governed the implementation and explains why alternatives were rejected. |
| Replay Packet | If produced, documents the minimal context needed to reproduce the engineering session. Optional. |

Do not link artefacts that do not exist. A broken link is worse than an honest gap.

---

### Step 4 — Link specifications

For every specification referenced during the implementation:

- Link to the specific version of the specification.
- State the sections that govern the primary behaviour being changed.
- If the specification was updated as part of this change, state the version before and
  after.

---

### Step 5 — Link reviews

For every review conducted:

- Link to the review document.
- State the review type (Seven-Lens, Adversarial, Code Review, etc.).
- State the verdict.
- State the number of findings by severity.
- State whether any findings were resolved, deferred, or accepted as tracked items.

---

### Step 6 — Link verification

For every automated gate:

- State the tool and version.
- State the command used.
- State the result (pass count, failure count, or summary).

Include the full gate table in the Verification Gates provenance field so the evidence is
co-located with the claim.

---

### Step 7 — Record human decisions

Review the complete engineering record and extract every decision that:

- Was made by a human engineer rather than derivable from the specification.
- Involves accepting a known risk, deferring a known limitation, or choosing one
  implementation approach over another documented alternative.
- Has consequences that are not visible from the code itself.

Each such decision is a Human Decision entry.

If no explicit human decisions were made beyond normal code authorship, state that
explicitly rather than leaving the field empty or inventing entries.

---

### Step 8 — Record known limitations

Review the complete engineering record and extract every:

- Finding from the review that was not resolved in this change.
- Interface contract that is partially implemented.
- Behaviour defined in the specification that is explicitly deferred.
- Assumption embedded in the implementation that has no specification backing.

Document each limitation with enough precision that a future engineer reading the code
can match the limitation to a specific location.

---

### Step 9 — Perform redaction review

Before publishing the provenance document, conduct a redaction pass.

Use the redaction checklist in `templates/redaction-checklist.md`.

Every category must receive an explicit PASS or finding. No category may be left blank.

If the redaction review finds sensitive material, remove or redact it before publication.
Document the redaction action in the review output.

A completed redaction review with no findings should be documented explicitly:

> Redaction review completed. No sensitive material identified.

---

### Step 10 — Perform Read-as-a-Stranger validation

Before publishing, validate that a reviewer without implementation context can approve
the change using only the repository evidence.

Use the checklist in `templates/read-as-a-stranger.md`.

The validation must produce a PASS or FAIL verdict with specific justification.

PASS means: a reviewer can understand the problem, the solution, the verification, and
the remaining risks without asking the author for additional context.

FAIL means: at least one question from the checklist cannot be answered from the
repository evidence. The specific gap must be identified and addressed before the PR
is published.

---

### Step 11 — Publish PR

Publish the provenance document to the repository at the agreed path (e.g.,
`reviews/<task-id>/pr-provenance.md`) and reference it from the PR description.

The PR description should contain:

1. The opening summary (Step 1).
2. A link to the full provenance document.
3. The verification gate table (a copy, not just a link, so reviewers see the gates
   without navigating).

The full provenance document may be copied directly into GitHub's PR description field
or maintained as a file in the repository — both are acceptable. The repository file is
preferred because it is version-controlled and searchable.

---

## Outputs

| Output | Type | Description |
|---|---|---|
| PR description summary | Engineering summary | The opening section: what changed, why, and what engineering value it provides. |
| Provenance block | Evidence Record (ADR-009) | The structured fields: Tool/Model, Context Loaded, Verification Gates, Human Decisions, Known Limitations, Session Duration, SDD Approach. |
| Linked evidence section | Traceability record | Repository-relative links to every applicable artefact. |
| Redaction review | Verification Asset (ADR-009) | Completed checklist confirming no sensitive material is present. |
| Read-as-a-Stranger validation | Verification Asset (ADR-009) | PASS/FAIL verdict with justification confirming reviewability. |

---

## Validation

A completed provenance package is valid when all of the following are satisfied:

- [ ] The opening summary is specific. It names the files, functions, or behaviours
      changed and states why the change exists.
- [ ] Every provenance field is filled with actual evidence. No field contains a
      placeholder.
- [ ] The Tool / Model field names a specific model or explicitly states that the
      change is not AI-assisted.
- [ ] The Verification Gates table lists every gate that was run, with a PASS or FAIL
      result for each.
- [ ] The Human Decisions field contains at least one entry or explicitly states that
      no human decisions beyond normal code authorship were made.
- [ ] The Known Limitations field contains at least one entry or explicitly states that
      no limitations were identified.
- [ ] Every linked artefact exists in the repository. No broken links are present.
- [ ] The redaction checklist has been completed and all categories have an explicit
      result.
- [ ] The Read-as-a-Stranger validation has been completed and produces a PASS verdict.
      If FAIL, the gap has been resolved before publication.

---

## Limitations

- **Provenance documents what was done, not whether what was done was correct.**
  A complete provenance package does not certify engineering quality. It certifies that
  the engineering process is visible. A reviewer using the provenance may still find
  defects.

- **The value of provenance scales with the quality of the underlying evidence.**
  A provenance document that links to a session log with one line of notes provides less
  assurance than one that links to a supervised session log with gate verdicts, proposals,
  approvals, and a verification summary.

- **Provenance cannot be retroactively fabricated.**
  Evidence must be produced at the time of the engineering work. A provenance document
  written after the fact without reference to contemporaneous engineering artefacts is not
  provenance — it is reconstruction. Reconstruction is not a substitute.

- **Isolation tier affects the strength of the verification claim.**
  Independent verification conducted by the same engineer who wrote the implementation
  (Tier C) provides weaker assurance than verification conducted by a separate engineer
  (Tier A). The isolation tier must be honestly stated.

- **This Skill does not define what evidence is sufficient.**
  Different changes require different evidence levels. The Skill defines the fields and
  the process. The engineering team defines the required evidence depth for each class
  of change.

---

## Human Decisions

The following decisions require explicit human judgment and are outside the scope of this
Skill:

| Decision | Why human judgment is required |
|---|---|
| What evidence depth is required | The Skill defines fields. The engineering team decides which artefacts are mandatory for a given change class. |
| Whether to accept a known limitation | Accepting a documented limitation is a risk decision owned by a named human engineer or reviewer. |
| Whether a FAIL in Read-as-a-Stranger blocks the PR | A gap identified by the validation checklist may be acceptable in some contexts and blocking in others. A human reviewer decides. |
| Redaction judgments | Whether a piece of information is sensitive requires human judgment. The checklist identifies categories; humans make the determination. |
| Merge decision | The provenance package informs the reviewer. The merge decision belongs to the reviewer. |

---

## Why Provenance Matters in AI-Assisted Engineering

When a human engineer writes code without tooling assistance, the engineering record is
implicit in the code itself. The variable names, the test cases, the comments, the commit
messages — together they tell a story that a skilled reviewer can reconstruct.

When an AI assistant contributes to the engineering work, this implicit record breaks
down in three specific ways:

**The reasoning is invisible.** A human engineer who makes a design decision leaves
traces — a comment, an ADR, a commit message. An AI assistant that makes the same
decision leaves only the output. The reasoning that produced the output is not in the
repository.

**The decisions are ambiguous.** A reviewer looking at a PR cannot determine whether a
design choice was made by the engineer or suggested by the AI. This ambiguity matters
when the choice involves accepted risks, deferred limitations, or tradeoffs that are not
self-evident from the code.

**The verification surface is larger.** AI-assisted implementations can be produced more
quickly than human-only implementations. This means the time between "idea" and "ready
for review" is compressed. Without a formal record of what was verified and when,
reviewers are asked to trust results they cannot reproduce.

PR Provenance addresses all three problems by requiring that the engineering record be
made explicit before the change reaches review. The reviewer does not need to trust the
author's claim that the implementation is correct. The reviewer can evaluate the evidence
directly.

This is the same principle that makes peer review in science valuable: it is not that
the reviewer trusts the researcher, but that the researcher has documented the work in
sufficient detail for the reviewer to reproduce and evaluate it independently.

---

## Best Practices

**Produce evidence during the engineering work, not after.**
Session logs, gate results, and review findings are most accurate when recorded
contemporaneously. A provenance document assembled from memory after the fact is less
reliable than one assembled from real-time records.

**Be specific about limitations.**
A limitation with a file name, a function name, and a one-sentence explanation is
actionable. A limitation that says "this could be improved in the future" is noise.
Future engineers need to match limitations to locations.

**Separate what is done from what is deferred.**
Known deferred items are not the same as unknown limitations. A deferred item has a
location, a reason, and an explicit decision to defer. Conflating the two obscures the
engineering record.

**The redaction review is not optional.**
A PR that contains a customer name, an internal API endpoint, or an authentication
credential is a security incident. The redaction checklist is one minute of prevention
against a potentially irreversible publication.

**Own the Human Decisions field.**
This is the field that distinguishes a responsible engineer from one who delegated
accountability to a tool. Every decision with a consequence that is not self-evident from
the code should appear here with a justification. If the field is empty, either the
change is trivial or the engineer has not thought carefully about what decisions they made.

---

## Common Mistakes

| Mistake | Consequence | Correction |
|---|---|---|
| Filling fields with placeholders | The provenance document is published with `[TODO]` or `[See above]` entries | Complete every field before running the redaction review. |
| Linking artefacts that do not exist | The reviewer hits a 404 or a missing file | Confirm every link resolves before Step 11. |
| Listing verification gates without results | "Tests pass" is not a gate result | Include count, tool, and command. |
| Human Decisions field is empty | AI decisions are invisible to the reviewer | Review the engineering record for any decision with a consequence that is not derivable from the spec. |
| Known Limitations omits tracked findings | Future engineers cannot match deferred items to code locations | Include every finding from reviews that was deferred or accepted. |
| Read-as-a-Stranger produces FAIL and the PR is published anyway | The reviewer is blocked and must contact the author | Resolve the gap first, then publish. |
| Redaction review is skipped | Sensitive material is published permanently | The redaction checklist takes minutes. An exposed credential takes days to rotate. |
