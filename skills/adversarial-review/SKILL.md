---
id: SKILL-ADV-001
title: "Adversarial Engineering Review"
type: Skill
status: Approved
version: 1.0.0
created: 2026-07-23
updated: 2026-07-23
owner: ""
maintainer: ""
domain: review
tags:
  - review
  - quality
  - adversarial
  - pre-mortem
  - edge-cases
  - defect-detection
depends_on: []
related:
  - review/seven-lenses
  - verification/independent-test
supersedes: ""
superseded_by: ""
---

# Skill — Adversarial Engineering Review

---

## Purpose

Find implementation defects that normal engineering reviews miss.

A standard code review asks: "Does this implementation look correct?"

An adversarial review asks: "Under what realistic conditions does this implementation fail, and why would we not know until it is too late?"

The two questions are complementary. The adversarial review targets the blind spots that correctness-oriented reviews systematically leave uncovered:

- Assumptions that are true in test fixtures but false in production data.
- Interactions between components that individually appear correct.
- Silent failures — code paths that produce wrong results without raising an error.
- Edge cases that no existing test exercises.

---

## Scope

### When to use

Apply this Skill after an implementation has passed all of the following:

- Code review
- Independent verification
- Automated tests (unit, integration)
- Static analysis (linting, type checking)

The adversarial review is a final quality gate before a change reaches production. It is most valuable when:

- The implementation is non-trivial (multiple interacting components).
- The failure cost is high (financial calculations, security controls, audit logic, data validation).
- A normal review has already been completed and the reviewer knows the code well — which is precisely when blind spots accumulate.

### When not to use

- On a first draft before basic correctness review.
- As a substitute for unit tests or specification review.
- On trivial single-purpose changes where all code paths are directly observable.
- When the reviewer has insufficient context to reason about production inputs.

### Relationship to other reviews

This Skill complements — and explicitly does not replace — the following:

| Review type | What it finds | What it misses |
|---|---|---|
| Code review | Logic errors, style violations, maintainability issues | Failures that only appear with specific production inputs |
| Independent verification | Confirmation that the implementation matches the spec | Failures caused by the spec itself being underspecified |
| Seven-Lens Review | Systematic coverage of behaviour, hidden assumptions, test gaps, security, spec drift, edge cases, over-engineering | Findings are constrained by what the reviewer knows to look for |
| **Adversarial Review** | **Production-realistic failure modes; silent incorrect results; untested input shapes** | **Cannot substitute for test coverage or specification completeness** |

The adversarial review is adversarial in posture only. Its goal is to improve the implementation, not to evaluate the engineer who wrote it.

---

## Inputs

| Input | Required | Description |
|---|---|---|
| Implementation source code | Yes | The complete set of files under review. All modules, not just the diff. |
| Existing test suite | Yes | Required to determine which cases are already covered. Findings that repeat covered cases are excluded. |
| Prior review artefacts | Yes | Results of code review, independent verification, and any prior systematic review (e.g., Seven-Lens). Findings that repeat prior findings are excluded. |
| Specification or requirements | Recommended | Needed to identify gaps between the spec and the implementation. |
| Production context | Recommended | Knowledge of realistic input shapes, caller patterns, and data sources. |

---

## Preconditions

1. The implementation compiles, passes linting, and passes the existing test suite.
2. At least one prior engineering review has been completed and its findings are documented.
3. The reviewer has read the source code. Adversarial findings must reference actual code paths — not speculative scenarios.
4. The reviewer has read the existing test suite to avoid generating findings for already-covered cases.

---

## Procedure

### Step 1 — Establish the review baseline

Read all source modules under review.

Read all existing tests.

Read all prior review documents.

Record:
- The set of source files in scope.
- The number of existing tests and their pass status.
- The findings already documented in prior reviews (to be excluded).

### Step 2 — Run the Pre-mortem

Adopt the perspective of a post-incident engineer, 30 days after the implementation has reached production.

Generate five plausible root causes for a production incident caused by this implementation.

**Guidance:**

- Cause 1 will usually be the obvious failure already discussed in prior reviews. Include it but do not spend analytical effort there.
- Focus effort on Causes 2–5. These are the non-obvious failures that prior reviews have not surfaced.
- Each cause must include:
  - **Trigger** — the specific condition or input that initiates the failure.
  - **Blast radius** — what fails, how many users or operations are affected, and whether the failure is silent or loud.
  - **Exact code location** — file name and line number or function name.
  - **Why existing tests miss it** — a specific explanation of why no current test exercises this path.

After generating all five causes, select the strongest non-obvious finding. "Strongest" means: highest combination of production reachability, failure severity, and test invisibility.

### Step 3 — Run the Edge Case Hunter

Review the implementation for input combinations that are not covered by the existing test suite.

Generate at least three candidate edge cases.

Each edge case must include:
- **Input shape** — the specific combination of values that triggers the failure.
- **Observable failure** — what the caller or user sees (wrong result, silent pass, exception, performance degradation).
- **Exact code location** — file name and line number or function name.
- **Why current tests miss it** — a specific explanation.

After generating all candidates, mark the strongest one. Strongest means: most reachable with realistic production data, most harmful when triggered, least visible without a dedicated test.

### Step 4 — Select findings for resolution

From the pre-mortem and edge case analysis, select:
- **One pre-mortem finding** — the strongest from Step 2.
- **One edge case finding** — the strongest from Step 3.

These two findings proceed to resolution. Additional findings may be recorded for tracking but are not required to reach a resolution decision in this pass.

### Step 5 — Decide resolution for each finding

For each selected finding, choose exactly one resolution:

#### FIX NOW

The defect is reachable with realistic production inputs, produces incorrect or harmful results, and the fix is straightforward.

Document:
- The minimal code change required.
- Why the change is safe (no unintended side effects on existing behaviour).
- The test that must be added to verify the fix.

Do not propose large refactors as part of a FIX NOW decision. The minimal change that eliminates the defect is sufficient.

#### ACCEPT WITH DOCUMENTED RISK

The behaviour is incorrect under a specific input condition, but the condition is not currently defined by the specification, or the risk is bounded and accepted by the team.

Document:
- Why the current risk is acceptable.
- The assumption that supports the acceptance (e.g., "the specification does not define valid ranges for this field").
- The condition that would convert this to FIX NOW (e.g., "if the specification is updated to define negative values as valid").

Do not make code changes for an ACCEPT decision.

#### DEFER WITH TICKET

The finding is real but requires non-trivial investigation or a specification change before it can be fixed safely.

Document:
- Why it is safe to defer (the failure mode is not immediately harmful in the current deployment context).
- What work is required before the ticket can be resolved.
- Any temporary mitigation in place.

### Step 6 — Apply fixes

For any FIX NOW decision:

1. Make the minimal code change described in Step 5.
2. Add the test(s) that verify the fix.
3. Run the full test suite to confirm no regression.
4. Run linting and type checking.

Changes must be minimal. The adversarial review is not a refactoring session.

### Step 7 — Update the engineering review document

Append an `## Adversarial Pass` section to the existing review document.

The section must use the template provided in `review-template.md`.

Required content:
- The model or reviewer identity used.
- The pre-mortem finding with resolution.
- The edge case finding with resolution.
- The overall verdict (APPROVED or CHANGES REQUIRED).

---

## Outputs

| Output | Type | Description |
|---|---|---|
| Pre-mortem analysis | Review Report (ADR-009) | Five root causes with locations, blast radii, and test coverage gaps |
| Edge case analysis | Review Report (ADR-009) | At least three untested input shapes with failure descriptions |
| Resolution decisions | Review Report (ADR-009) | FIX NOW / ACCEPT WITH DOCUMENTED RISK / DEFER WITH TICKET for each selected finding |
| Code fix | Implementation artefact | Minimal code change for any FIX NOW decision |
| New tests | Verification Asset (ADR-009) | Tests that verify the fix and document accepted behaviour |
| Updated review document | Review Report (ADR-009) | `## Adversarial Pass` section appended to the existing review |

---

## Validation

A completed adversarial review pass is valid when:

- [ ] Every finding references an actual code path (file, function, or line number). No speculative findings.
- [ ] No finding repeats a finding from a prior review document.
- [ ] No finding repeats a case already covered by the existing test suite.
- [ ] Every selected finding has exactly one resolution decision with a written justification.
- [ ] FIX NOW resolutions include a minimal code change description.
- [ ] FIX NOW resolutions include at least one new test.
- [ ] The full test suite passes after any code changes.
- [ ] Linting and type checking pass after any code changes.
- [ ] The `## Adversarial Pass` section has been appended to the engineering review document.

---

## Limitations

- **Scope is the existing implementation.** The adversarial review does not evaluate whether the specification itself is correct. Specification gaps are noted but not resolved by this Skill.
- **Findings require code evidence.** The reviewer must have read the implementation. Findings generated without reading the code are invalid.
- **The review is a sample, not a proof.** A completed adversarial pass increases confidence; it does not guarantee the absence of defects.
- **Resolution is not deployment approval.** APPROVE verdict from this review is a quality gate result. It does not substitute for deployment governance.
- **FIX NOW changes must be minimal.** This Skill does not authorize architectural refactoring. Refactoring decisions are escalated to the engineering team.

---

## Human Decisions

The following decisions require explicit human approval and are outside the scope of this Skill:

| Decision | Why human approval is required |
|---|---|
| ACCEPT WITH DOCUMENTED RISK | Acceptance of a known defect is a risk decision owned by a named human. |
| DEFER WITH TICKET | Deferral of a real defect requires a human to own the ticket and validate that the deferral is safe. |
| Applying a FIX NOW change to a production branch | Code changes to production branches require engineering team review and sign-off. |
| Verdict of CHANGES REQUIRED | If the adversarial pass produces a CHANGES REQUIRED verdict, a human must decide whether to block or proceed. |

---

## Best Practices

**Ground every finding in the actual code.** The difference between a useful adversarial finding and a generic observation is the exact code path. "This function does not validate negative inputs" is a generic observation. "The `floor` computation at `validator.py:197` multiplies a caller-supplied float by 1.20 without a non-negativity guard, so a negative baseline produces a negative floor and allows `hard_cap=0.0` to pass validation" is an adversarial finding.

**Prioritize silent failures over loud ones.** An implementation that raises an exception on bad input is self-diagnosing. An implementation that returns the wrong result silently is the adversarial reviewer's primary target.

**Focus on the gap between test fixtures and production data.** Test fixtures are designed by the author of the tests. They contain the inputs the author thought to test. Production data is shaped by callers the author did not anticipate. The gap between these two sets is where defects live.

**Separate finding from resolution.** Document all findings before deciding resolutions. Deciding resolution prematurely closes off findings that might be stronger.

**One minimal fix per FIX NOW.** Scope creep during adversarial fixes introduces risk. If the fix requires more than 10 lines of code, question whether it is truly minimal.

---

## Common Mistakes

| Mistake | Consequence | Correction |
|---|---|---|
| Repeating findings from prior reviews | Wastes time; reviewer loses credibility | Read all prior review documents before starting. |
| Inventing scenarios without code evidence | Speculative findings have no engineering value | Every finding must cite a file, function, or line number. |
| Producing generic advice ("add input validation") | No actionable path | Every finding must name the specific field, caller, and failure condition. |
| Reviewing only the diff | Misses defects in code the diff interacts with | Read all modules that the changed code depends on or is called by. |
| Conflating FIX NOW with a refactoring opportunity | Introduces unreviewed scope | FIX NOW means the minimal change. Refactoring is a separate engineering decision. |
| Accepting a finding without documenting the assumption | Risk is invisible at the next review | ACCEPT WITH DOCUMENTED RISK requires a written assumption and a trigger condition for re-evaluation. |
