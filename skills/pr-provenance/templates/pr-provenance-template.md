# Pull Request

<!--
USAGE
  Copy this template to your repository before editing.
  Replace every {{PLACEHOLDER}} with actual content.
  Delete all HTML comments before publishing.
  Do not publish a provenance document with any placeholder remaining.
  Follow SKILL-PRV-001 (PR Provenance) for authoring guidance.
-->

## {{CHANGE_TITLE}}

<!--
  One to three paragraphs. Cover:
  1. What changed — the specific modules, functions, or behaviours affected.
  2. Why the change exists — the engineering or product requirement that motivated it.
  3. What engineering value it provides — what is improved, fixed, or made possible.

  Be specific. "Added CRITICAL classification and tests" is not acceptable.
  "Extended classify_risk() with two CRITICAL trigger paths from spec §1.2,
  guarded by the PDB-presence boundary condition, with 90 tests covering all
  acceptance criteria" is acceptable.
-->

---

## Provenance

### Tool / Model

<!--
  If AI-assisted: name the AI client, model identifier, and approximate execution dates.
  If not AI-assisted: state "Not AI-assisted — all implementation is human-authored."
  Do not leave this field blank.
-->

| Item | Value |
|---|---|
| AI client | {{AI_CLIENT_OR_NOT_AI_ASSISTED}} |
| Model | {{MODEL_IDENTIFIER}} |
| Execution date(s) | {{APPROXIMATE_DATES}} |

---

### Context Loaded

<!--
  Identify the primary implementation files modified.
  List the most important supporting files actually referenced (not every file).
  State which engineering practices were applied.

  Omit files that were not meaningfully referenced during the engineering work.
-->

**Primary implementation modified:**

{{PRIMARY_FILES_MODIFIED}}

**Supporting files referenced:**

| File | Role |
|---|---|
| {{FILE_PATH}} | {{PURPOSE}} |
| {{FILE_PATH}} | {{PURPOSE}} |

**Engineering practices applied:**

<!--
  Examples: Specification-Driven Development, Independent Verification (state isolation
  tier), Seven-Lens Review, Adversarial Review.
  Omit practices that were not followed.
-->

{{ENGINEERING_PRACTICES}}

---

### Verification Gates

<!--
  List every gate that was run. Include tool name, command, and result.
  Result must be PASS or FAIL — never "n/a" or "unknown".
  If a gate was not run, state why (e.g., "Type checking not applicable — dynamically
  typed language with no type annotation policy").
-->

| Gate | Tool / Command | Result |
|---|---|---|
| Linting | `{{LINT_COMMAND}}` | {{RESULT}} |
| Type checking | `{{TYPE_CHECK_COMMAND}}` | {{RESULT}} |
| Unit tests | `{{TEST_COMMAND}}` | {{RESULT}} — {{COUNT}} passed |
| Coverage | `{{COVERAGE_COMMAND}}` | {{RESULT}} — {{COVERAGE_PCT}}% |
| Independent Verification | {{VERIFICATION_METHOD}} | {{RESULT}} — Tier {{ISOLATION_TIER}} |
| Engineering Review | {{REVIEW_TYPE}} | {{VERDICT}} — {{FINDING_COUNT}} findings |
| Adversarial Review | {{ADVERSARIAL_REVIEW_TYPE}} | {{VERDICT}} |

---

### Human Decisions

<!--
  Document decisions made by the human engineer that are not derivable from the
  specification or tooling alone. Each entry must include:
  - The decision taken.
  - Why it was taken.
  - What alternatives were considered, if any.

  If no human decisions were made beyond normal code authorship, state:
  "No decisions beyond normal code authorship were required for this change."
-->

**Decision: {{DECISION_TITLE}}**

{{DECISION_DESCRIPTION}}

---

### Known Limitations

<!--
  Document specific, honest limitations of the change.
  Each limitation must name a location (file, function, or interface) and state
  the scope boundary precisely.

  Do not invent limitations. Do not omit known ones.

  If no limitations were identified, state:
  "No limitations were identified beyond items tracked in the linked review documents."
-->

**{{LIMITATION_TITLE}}**

{{LIMITATION_DESCRIPTION}}

---

### Session Duration

<!--
  Provide a reasonable approximation. Include:
  - Number of sessions.
  - Approximate duration per session.
  - Total active engineering time.
  If AI-assisted, distinguish between elapsed calendar time and active engineering time.
-->

{{SESSION_DURATION_DESCRIPTION}}

---

### SDD Approach

<!--
  If Specification-Driven Development or an equivalent practice was followed:
  - Reference the specification and delta artefacts using repository-relative paths.
  - State the spec version that governed the implementation.
  - Describe the SDD workflow steps that were completed.

  If SDD was not followed, state why and omit this field.
-->

{{SDD_WORKFLOW_DESCRIPTION}}

Specification: `{{SPEC_PATH}}`

Delta: `{{DELTA_PATH}}`

---

## Linked Evidence

<!--
  Provide repository-relative links to every applicable artefact.
  Confirm every link resolves before publishing.
  Do not link artefacts that do not exist — an honest gap is better than a broken link.
  Delete rows for artefacts that do not exist in this repository.
-->

| Artefact | Path |
|---|---|
| Specification | `{{PATH}}` |
| Delta / Change record | `{{PATH}}` |
| Implementation plan | `{{PATH}}` |
| Task list | `{{PATH}}` |
| Session log | `{{PATH}}` |
| Independent verification | `{{PATH}}` |
| Engineering review | `{{PATH}}` |
| Adversarial pass | `{{PATH}}` |
| Architecture Decision Record | `{{PATH}}` |
| Replay packet | `{{PATH}}` |
| Primary implementation | `{{PATH}}` |
| Test suite | `{{PATH}}` |

---

## Redaction Review

<!--
  Complete the redaction checklist (templates/redaction-checklist.md) before publishing.
  Record the outcome here.

  If no sensitive material was found, write exactly:
  "Redaction review completed. No sensitive material identified."

  If sensitive material was found and removed, describe what was removed and how.
-->

{{REDACTION_REVIEW_OUTCOME}}

---

## Read-as-a-Stranger Validation

<!--
  Complete the Read-as-a-Stranger checklist (templates/read-as-a-stranger.md) before
  publishing. Record the verdict and a brief justification here.

  PASS format:
  PASS — [one sentence explaining why a reviewer unfamiliar with the implementation can
  approve the change using only the repository evidence].

  FAIL format:
  FAIL — [identify the specific question from the checklist that cannot be answered and
  the gap that must be closed before publishing].

  Do not publish if the verdict is FAIL.
-->

{{READ_AS_A_STRANGER_VERDICT}}
