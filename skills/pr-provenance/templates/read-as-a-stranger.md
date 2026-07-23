# Read-as-a-Stranger Validation

<!--
USAGE
  Complete this checklist as the final step before publishing a PR provenance document.
  Answer each question as though you are a reviewer who:
  - Has not participated in the implementation.
  - Has no prior knowledge of this change.
  - Has access only to the repository and its contents.
  - Cannot ask the author for clarification.

  If any question cannot be answered YES from the repository evidence alone,
  the PR is not ready to publish. Identify the gap and close it first.

  Delete HTML comments before publishing.
-->

## Purpose

The Read-as-a-Stranger test answers one question:

> Can a reviewer who never participated in the implementation approve this change
> with confidence, using only the repository evidence?

A positive answer does not mean the reviewer will find no defects. It means the reviewer
has sufficient information to evaluate the change, understand the decisions made, verify
the stated quality claims, and make an informed merge decision — without needing to contact
the author for context that should have been in the PR.

This validation is the final quality gate before publication.

---

## Validation Checklist

### Section 1 — Problem Comprehension

**Q1. Can a reviewer state the engineering problem this change addresses?**

The change summary must explain why the change exists. A reviewer reading only the PR
description should be able to answer: "What problem was being solved?"

Evidence to check:
- The opening summary explicitly states the motivation for the change.
- The linked specification or delta confirms the requirement.

`[ ] YES` — The problem is clearly stated and confirmed by linked evidence.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

**Q2. Can a reviewer identify the scope of the change?**

The reviewer should be able to determine which modules, functions, or behaviours were
changed without reading the full diff.

Evidence to check:
- The opening summary names the primary files or components modified.
- The Context Loaded section lists the implementation files.

`[ ] YES` — Scope is clearly stated.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

### Section 2 — Implementation Understanding

**Q3. Can a reviewer understand why key design decisions were made?**

The reviewer should not have to guess why the implementation takes the approach it takes.
Decisions that are not self-evident from the code must be documented.

Evidence to check:
- The Human Decisions field contains entries for every non-obvious engineering choice.
- Linked ADRs explain architectural decisions.
- Session log or review documents record proposals and their rationale.

`[ ] YES` — Design decisions are documented in the Human Decisions field and linked
artefacts.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

**Q4. Can a reviewer identify what this change explicitly does NOT do?**

Reviewers need to know the scope boundary. What was intentionally deferred, excluded,
or accepted as a known limitation?

Evidence to check:
- The Known Limitations field contains specific, located entries.
- Any findings from reviews that were deferred or accepted as tracked items are listed.
- Any partially-implemented interface contracts are identified.

`[ ] YES` — Scope boundaries and limitations are documented.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

### Section 3 — Verification Reproducibility

**Q5. Can a reviewer independently reproduce the verification gates?**

The reviewer should be able to run the same commands and obtain the same results without
asking the author which commands to use.

Evidence to check:
- The Verification Gates table lists every gate with the specific command used.
- The tool versions are recorded in the session log or equivalent.
- The test count is specific (e.g., "246 passed") rather than vague ("tests pass").

`[ ] YES` — All gates include the command and result. The reviewer can reproduce them.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

**Q6. Can a reviewer evaluate the quality of the test coverage?**

The reviewer should be able to assess whether the tests are sufficient to validate the
claimed behaviour — not just that the tests pass.

Evidence to check:
- The linked test suite corresponds to the implementation being reviewed.
- The engineering review documents coverage gaps, if any.
- Acceptance criteria are linked to specific tests.

`[ ] YES` — Coverage is documented and test quality can be evaluated from the evidence.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

**Q7. Can a reviewer confirm that the change passes all stated quality gates?**

The reviewer should not have to run the gates themselves to know what the results were.

Evidence to check:
- Every gate in the Verification Gates table shows a PASS result (or an explained FAIL).
- No gate entry is vague or missing a result.
- The session log or verification report confirms the gate results were produced from an
  unmodified working tree.

`[ ] YES` — All gates show verifiable results.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

### Section 4 — Risk Assessment

**Q8. Can a reviewer identify the primary risks associated with this change?**

The reviewer should understand what could go wrong, where the highest-risk logic lives,
and what mitigations are in place.

Evidence to check:
- The Known Limitations field contains specific risk entries.
- The engineering review (Seven-Lens, Adversarial, or equivalent) documents findings
  with severities.
- Accepted risks are documented with their acceptance rationale.

`[ ] YES` — Risks are documented with locations and severities.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

**Q9. Can a reviewer evaluate whether accepted risks were decided by a human or assumed
by default?**

The reviewer should be able to distinguish between "this limitation is accepted because
[specific reasoning by a named human]" and "this limitation was not addressed."

Evidence to check:
- Every accepted risk in the Known Limitations field has a documented decision rationale
  in the Human Decisions field.
- The review documents show that accepted risks were discussed, not silently passed over.

`[ ] YES` — Every accepted risk has a human decision entry.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

### Section 5 — Evidence Completeness

**Q10. Can a reviewer access every piece of evidence referenced in the provenance
document?**

A provenance document that links to missing files is worse than one that admits honest
gaps. Broken links damage reviewer trust more than acknowledged absences.

Evidence to check:
- Every path in the Linked Evidence section resolves to an existing file.
- No artefact is described as "available separately" or "on request."
- The repository is the single authoritative source for all referenced evidence.

`[ ] YES` — All linked artefacts exist and are accessible.

`[ ] NO` — Gap: {{DESCRIBE_GAP}}

---

**Q11. Can a reviewer approve this change without asking the author for any additional
context?**

This is the terminal question. It synthesizes all of the above. If any question above
produced a NO, this question is automatically NO.

`[ ] YES` — A reviewer with no prior context can evaluate and approve this change using
only the repository evidence.

`[ ] NO` — The following gaps must be closed before publication:
{{LIST_ALL_GAPS}}

---

## Verdict

<!--
  PASS: All eleven questions answered YES.
  FAIL: One or more questions answered NO. Publication is blocked.
-->

### PASS

All eleven questions answered YES. The provenance document is complete and the change is
ready for reviewer evaluation.

**Justification:** {{ONE_SENTENCE_JUSTIFICATION}}

---

### FAIL

One or more questions answered NO.

The following gaps must be resolved before this PR is published:

| Question | Gap | Required action |
|---|---|---|
| Q{{NUMBER}} | {{GAP_DESCRIPTION}} | {{REQUIRED_ACTION}} |

The PR must not be published until all gaps listed above are closed and this checklist
is re-evaluated.

---

## Reviewer

**Reviewed by:** {{REVIEWER_NAME_OR_ROLE}}

**Date:** {{REVIEW_DATE}}
