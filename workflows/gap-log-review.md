---
id: WF-001
title: "Gap Log Review Workflow"
type: Workflow
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: workflows
tags: [context-bundle, cold-context, knowledge-gaps, maintenance, onboarding]
depends_on: [ADR-004, STD-001, TPL-CB-004]
related: [STD-001, STD-002]
supersedes: ""
superseded_by: ""
---

# WF-001 — Gap Log Review Workflow

## 1. Purpose

This workflow defines the repeatable process for reviewing, prioritising, and
closing knowledge gaps recorded in a project's Cold Context gap log.

A gap log records genuine unknowns at the time a Context Bundle is bootstrapped or
updated. Without a scheduled review process, gap logs accumulate unchecked entries
and become stale reference documents rather than actionable engineering tools.

This workflow ensures that gaps are:
- surfaced at the right moments;
- assigned to the right owners;
- closed with verified evidence;
- removed from active tracking when resolved.

---

## 2. Scope

This workflow applies to:
- any project with a Cold Context gap log following the format defined in
  `TPL-CB-004 — Gap Log Template`;
- any engineer or AI assistant responsible for maintaining a project's Context Bundle.

This workflow does not govern:
- the content of individual gap entries (see `STD-001 — Context Layer Decision
  Standard`);
- how verified answers are recorded (see `STD-002 — Verification Evidence Standard`).

---

## 3. Inputs

| Input | Required | Description |
|---|---|---|
| `context/cold/gap-log.md` | Yes | The project's current gap log |
| `docs/context/stack.md` | Yes | Warm Context, to verify whether gaps have self-resolved |
| Engineering change log or release notes | Recommended | Identifies changes that may affect open gaps |

---

## 4. Outputs

| Output | Description |
|---|---|
| Updated `gap-log.md` | Gap statuses updated; closed gaps marked; new gaps added |
| Updated `stack.md` | Warm Context updated with any newly verified answers |
| Updated `CLAUDE.md` | Hot Context updated if a gap resolution changes a permanent rule |
| Review record | Summary of what was reviewed, what changed, and what remains open |

---

## 5. Triggers

Initiate a Gap Log Review when any of the following occurs:

| Trigger | Reason |
|---|---|
| **New engineer onboarding** | Fresh perspective surfaces previously invisible tribal knowledge |
| **Post-incident retrospective** | Incidents frequently reveal unknowns that belong in Cold Context |
| **Sprint review** (scheduled) | Regular cadence prevents gap log staleness |
| **Architecture change** | Changes may resolve or introduce gaps |
| **Dependency or stack update** | May resolve or invalidate existing Warm Context claims |
| **Pre-production gate** | Ensures high-priority gaps are resolved before a release |
| **Context Bundle version increment** | Major or minor version bumps should include a gap review |

Minimum recommended cadence: once per sprint or at every significant architectural
change, whichever comes first.

---

## 6. Roles

| Role | Responsibility |
|---|---|
| **Gap Review Owner** | The engineer leading the review session. Accountable for the updated gap log. |
| **Domain Expert** | Engineer with knowledge relevant to specific open gaps. Consulted as needed. |
| **Context Bundle Maintainer** | Responsible for committing updates to stack.md and CLAUDE.md. |

The Gap Review Owner may also be the Context Bundle Maintainer on small teams.
The review should not be completed by a single individual if independent verification
is required to close a high-priority gap (see Step 5).

---

## 7. Workflow Steps

### Step 1 — Load the gap log

Read `context/cold/gap-log.md` in full.

For each entry, note:
- current status (OPEN / PARTIAL / CLOSED);
- priority (High / Medium / Low);
- the stated closure criterion.

---

### Step 2 — Screen for self-resolved gaps

Check whether any OPEN or PARTIAL gap may have been resolved by recent changes:

- Compare the gap's stated subject against recent commits, ADRs, or documentation.
- If evidence exists that the gap is now answerable, proceed to Step 4.
- If no evidence exists, leave the status unchanged.

Common self-resolution signals:
- A new ADR was published that documents a previously undocumented decision.
- A configuration file was added that answers an architectural question.
- A runbook was written that covers a previously undocumented incident response.

---

### Step 3 — Prioritise remaining open gaps

For each OPEN gap, review or confirm its priority:

| Priority | Criteria |
|---|---|
| **High** | Operational blocker; prevents safe incident response, deployment, or production activity |
| **Medium** | Reduces engineering quality; causes duplicated effort or incorrect decisions |
| **Low** | Informational; no immediate engineering impact |

Update priority in the gap log if it has changed since the last review.

---

### Step 4 — Attempt gap resolution

For each High-priority gap and any PARTIAL gap with a clear path to closure:

**4a — Identify the primary source.**
Determine where the answer should exist: source code, configuration files,
ADRs, incident reports, team members with domain knowledge.

**4b — Verify the answer.**
Locate the specific evidence. Record: claim, evidence, file, line.
Follow the evidence requirements in `STD-002 — Verification Evidence Standard`.

**4c — Record the answer in the appropriate context layer.**
- If the answer is a permanent rule: promote to Hot Context (`CLAUDE.md`).
- If the answer is a verified fact: record in Warm Context (`stack.md`).
- If the answer is a design decision: propose an ADR or document in the project.

**4d — Mark the gap CLOSED in the gap log.**
Closing a gap requires:
- the answer is recorded in the appropriate layer;
- the evidence is independently verifiable (not tribal knowledge);
- the gap log entry cites where the answer was recorded.

---

### Step 5 — Handle gaps that cannot be closed

If a gap cannot be closed during this review:

- Confirm or update the priority.
- Update the "What would close this gap" field if the closure path has become
  clearer.
- If the gap has been open for more than two review cycles without progress, escalate
  to a named owner with a due date.

A gap may remain OPEN indefinitely. What is not acceptable is a gap that is OPEN
with no owner and no stated closure path.

---

### Step 6 — Add newly identified gaps

During the review, new gaps may be identified. For each:

1. Assign a sequential identifier (GAP-NNN, continuing from the current highest number).
2. Record the gap using the format from `TPL-CB-004`.
3. Assign an initial priority.
4. State the closure criterion.

Do not fabricate gaps. Only record genuine unknowns.

---

### Step 7 — Update the summary table

Update the Gap Summary table at the bottom of `gap-log.md`:

- Update statuses for any gap that changed.
- Add rows for any new gaps.
- Do not remove rows for CLOSED gaps — retain them with status CLOSED for
  historical traceability.

---

### Step 8 — Produce a review record

After completing the review, record a brief summary:

```
Gap Log Review
Date:           {{REVIEW_DATE}}
Reviewer:       {{REVIEWER_NAME_OR_ROLE}}
Gaps reviewed:  {{COUNT}}
Closed:         {{COUNT}} — {{GAP_IDs}}
Status changed: {{COUNT}} — {{GAP_IDs}}
New gaps added: {{COUNT}} — {{GAP_IDs}}
High-priority open gaps: {{COUNT}} — {{GAP_IDs}}
Notes:          {{ANY_NOTABLE_OBSERVATIONS}}
```

This record may be appended to the gap log, added to a project changelog, or
recorded in a session summary — whichever is appropriate for the project's
documentation practice.

---

## 8. Closure Criteria

A gap is only CLOSED when all of the following are true:

| Criterion | Description |
|---|---|
| **Answer recorded** | The answer exists in the appropriate context layer or project document |
| **Evidence cited** | The answer is backed by verifiable evidence (not memory or assertion) |
| **Layer correct** | The answer is placed in the correct context layer (STD-001) |
| **Gap log updated** | The gap entry shows status CLOSED and references where the answer is recorded |

A gap that is "answered verbally" or exists only in an engineer's memory is not CLOSED.
It remains PARTIAL until the answer is documented.

---

## 9. Exit Criteria

The workflow is complete when:

- All gaps have been reviewed.
- All High-priority gaps are either CLOSED or have a named owner with a due date.
- The gap summary table reflects the current state.
- The review record has been produced.

---

## 10. Anti-Patterns

| Anti-pattern | Problem | Correct behaviour |
|---|---|---|
| Closing a gap without recording the evidence | Creates appearance of closure without knowledge transfer | Record evidence in the correct context layer first |
| Deleting closed gaps from the log | Loses historical traceability | Mark CLOSED; retain the entry |
| Adding gaps speculatively | Bloats the log with non-genuine unknowns | Only record genuine, identifiable unknowns |
| Never reviewing the gap log | Gaps become stale; high-priority gaps stay unresolved | Follow the trigger list in Section 5 |
| Single reviewer for high-priority gaps | Risks self-validation on important questions | Involve a second reviewer or domain expert |

---

## 11. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.1 kata execution |
