# Adversarial Engineering Review — Prompts

This file contains production-ready prompts for each phase of the adversarial review process.

All prompts are implementation-agnostic and language-agnostic.

Before using any prompt, supply the required context listed under each prompt's **Inputs** section.

---

## Prompt 1 — Pre-mortem

**Purpose:** Generate five plausible root causes for a production incident caused by the implementation under review.

**When to use:** After reading the full source code and existing test suite, and after reading all prior review documents.

**Inputs required before running this prompt:**

- Source code of all modules under review (pasted or provided as file context).
- The existing test suite (pasted or provided as file context).
- The findings from all prior reviews (to exclude).

---

```
You are performing an independent adversarial engineering review.

This is NOT an implementation session.

The implementation has already passed:
[LIST THE GATES THAT HAVE ALREADY PASSED — e.g., code review, linting, type checking, unit tests, seven-lens review]

Your job is to find what those reviews likely missed.

---

# Pre-mortem

Assume the implementation causes a production incident 30 days after deployment.

Generate FIVE plausible root causes.

Rules:
- Cause #1 will usually be the obvious one already mitigated or discussed. Include it and move on.
- Focus your analytical effort on Causes #2–#5.
- Every cause must describe a realistic failure, not a theoretical one.

For each cause include:

**Trigger**
The specific condition, input value, or caller pattern that initiates the failure.

**Blast Radius**
What fails when this trigger fires. How many operations, users, or downstream systems are affected.
State whether the failure is silent (wrong result returned) or loud (exception raised).
Silent failures are more dangerous than loud ones.

**Exact Code Location**
File name and function or line number where the defect lives.
If you cannot cite a specific location, the finding is invalid.

**Why Existing Tests Would Not Detect It**
Name the specific test or test class that should cover this case.
Explain why it does not.

---

Constraints:
- Do NOT repeat findings already identified in prior reviews. Prior findings: [LIST PRIOR FINDING TITLES OR PASTE THE PRIOR REVIEW SUMMARY].
- Do NOT invent scenarios without code evidence. Every finding must reference an actual code path you have read.
- Do NOT produce generic advice ("add input validation"). Name the specific field, function, and failure condition.
- Every cause must be reachable with realistic production inputs — not only crafted adversarial inputs.

After listing all five causes, select the strongest non-obvious finding (typically from Causes #2–#5).

"Strongest" means: highest combination of production reachability, failure severity, and test invisibility.

For the selected finding, propose ONE concrete mitigation.

The mitigation must be an engineering action — a specific code change, not a monitoring recommendation or documentation note.
```

---

## Prompt 2 — Edge Case Hunter

**Purpose:** Identify input combinations that are not covered by the existing test suite and that produce incorrect or unexpected results.

**When to use:** After the Pre-mortem. The Edge Case Hunter focuses on untested inputs rather than failure modes in production.

**Inputs required before running this prompt:**

- Source code of all modules under review.
- The existing test suite (pasted or provided as file context). This is mandatory — findings that repeat already-tested cases are excluded.
- The findings from all prior reviews (to exclude).

---

```
You are performing an independent adversarial engineering review.

This is NOT an implementation session.

---

# Edge Case Hunter

Review the implementation and identify input combinations that are NOT already covered by the existing tests.

Rules:
- Read the test suite carefully before generating candidates. A finding is only valid if no existing test exercises that input shape.
- Exclude anything already tested. If you are unsure whether a case is tested, check the test suite before including it.
- Produce at least THREE candidate edge cases.

For each candidate include:

**Input Shape**
The exact combination of values, types, or structural conditions that triggers the failure.
Be specific: "a negative float in the `monthly_total` field" is a valid input shape.
"unexpected input" is not.

**Observable Failure**
What the caller sees when this input is provided.
Options: wrong return value, silent pass (validator accepts invalid state), exception, performance degradation, data corruption.
Prefer silent failures — they are the hardest to detect.

**Exact Code Location**
File name and function or line number.

**Why Current Tests Miss It**
Name the test class or test fixture that is closest to this case.
Explain the specific gap: which value, type, or condition is absent from the fixture.

---

Constraints:
- Do NOT repeat findings already identified in prior reviews. Prior findings: [LIST PRIOR FINDING TITLES OR PASTE THE PRIOR REVIEW SUMMARY].
- Do NOT invent scenarios without code evidence.
- Do NOT produce generic boundary advice ("test with zero and negative values"). Identify the specific function and field where the gap exists.
- Every candidate must be reachable by a realistic caller — not only by a deliberately malicious one.

After listing all candidates, mark the strongest one.

"Strongest" means: most reachable with production data, most harmful when triggered, least visible without a dedicated test.
```

---

## Prompt 3 — Full Adversarial Review

**Purpose:** Run the complete adversarial review process in a single pass — Pre-mortem, Edge Case Hunter, and Resolution decisions — and produce output ready to append to an engineering review document.

**When to use:** When you want the full adversarial review in one structured output rather than running the phases separately.

**Inputs required before running this prompt:**

- Source code of all modules under review.
- The existing test suite.
- The findings from all prior reviews (to exclude).
- The path or identifier of the engineering review document to append to.

---

```
You are performing an independent adversarial engineering review.

This is NOT an implementation session.

The implementation has already passed:
[LIST THE GATES THAT HAVE ALREADY PASSED]

Your job is to find what those reviews likely missed.

Repository: [REPOSITORY NAME OR PATH]
Review document to append to: [PATH TO REVIEW DOCUMENT]

Follow this process exactly.

---

# Part 1 — Pre-mortem

Assume the implementation causes a production incident 30 days after deployment.

Generate FIVE plausible root causes.

Important:
- Cause #1 will usually be the obvious one already mitigated. Include it briefly.
- Focus your analysis on Causes #2–#5.
- After listing all five, select the strongest non-obvious finding.

For each cause include:

- Trigger
- Blast Radius
- Exact file and code location
- Why existing tests would not detect it

For the selected finding, propose ONE concrete mitigation.
The mitigation must be a specific engineering change — not generic monitoring or documentation.

---

# Part 2 — Edge Case Hunter

Review the implementation and identify input combinations that are NOT already covered by the existing tests.

Exclude anything already tested.

Produce at least THREE candidate edge cases.

For each include:

- Input Shape
- Observable Failure
- Exact file and code location
- Why current tests miss it

Mark the strongest candidate.

---

# Part 3 — Resolution

For BOTH selected findings (one from Part 1, one from Part 2), decide exactly one resolution:

- FIX NOW
- ACCEPT WITH DOCUMENTED RISK
- DEFER WITH TICKET

Justify the decision.

If FIX NOW:
  Describe the minimal code change required.
  Describe the test that must be added.

If ACCEPT WITH DOCUMENTED RISK:
  Explain why the current risk is acceptable.
  State the assumption that supports the acceptance.
  State the condition that would convert this to FIX NOW.

If DEFER WITH TICKET:
  Describe what work is required.
  Explain why it is safe to defer now.

---

# Constraints

- Do NOT repeat findings already identified in prior reviews.
  Prior findings: [LIST PRIOR FINDING TITLES OR PASTE THE PRIOR REVIEW SUMMARY]
- Do NOT invent scenarios without code evidence.
  Every finding must reference an actual code path you have read.
- Do NOT produce generic recommendations.
  Name the specific function, field, and failure condition in every finding.
- Every finding must be reachable with realistic production inputs.
- Prioritize correctness over quantity. Three precise findings are more valuable than ten vague ones.

---

The output must be ready to append directly to the engineering review document
under the section:

## Adversarial Pass
```

---

## Prompt Usage Notes

### Supplying prior review findings

In every prompt, replace `[LIST PRIOR FINDING TITLES OR PASTE THE PRIOR REVIEW SUMMARY]` with the actual content. The minimum required is a list of finding titles with their severity ratings. A full summary is preferred.

If no prior review exists, replace the placeholder with: `No prior reviews have been completed for this implementation.`

### Specifying the gates that have passed

Replace `[LIST THE GATES THAT HAVE ALREADY PASSED]` with the actual gates — for example:

```
- Code review (approved)
- Linting: 0 errors
- Type checking: 0 issues
- Unit tests: 87/87 passed
- Integration tests: 14/14 passed
```

The more precise the gate list, the more focused the adversarial analysis will be. A reviewer who knows that mypy has already passed will not spend time on type annotation issues.

### Context window management

For large codebases, provide only the modules directly relevant to the change under review. The reviewer must read the full source of those modules — not just the diff.

If the codebase is too large to fit in a single context window, run separate passes for each subsystem and merge findings before resolution.

### Validating output quality

A high-quality adversarial review output satisfies all of the following:

- Every finding cites a specific file, function, or line number.
- No finding repeats a case already covered by the test suite.
- No finding repeats a finding from a prior review.
- The proposed mitigation for the pre-mortem finding is a specific code change, not advice.
- The resolution decisions are justified with concrete reasoning, not assertions.
