# Adversarial Pass

<!-- Instructions (delete before publishing):
     Fill in every section. Delete placeholder text.
     Do not leave any section blank — if a section does not apply, write "N/A" and explain why.
     The completed section is appended to the existing engineering review document.
     It does not replace prior review sections.
-->

**Reviewer / Model:**
<!-- The name, role, or model identifier of the reviewer who conducted this pass. -->

**Date:**
<!-- ISO 8601 date — YYYY-MM-DD -->

**Scope:**
<!-- List the source files reviewed in this pass. -->

**Prior review excluded:**
<!-- List the prior reviews whose findings were excluded from this pass. -->

---

## Pre-mortem Finding

### Selected Cause

**Title:**
<!-- One line: what is the defect? -->

**Trigger**
<!-- The specific condition, input value, or caller pattern that initiates the failure.
     Be precise. "A negative float in the `monthly_total` field" is a valid trigger.
     "Unexpected input" is not. -->

**Blast Radius**
<!-- What fails when this trigger fires. How many operations or users are affected.
     Is the failure silent (wrong result returned) or loud (exception raised)?
     Silent failures are more dangerous and should be prioritized. -->

**Root Cause**
<!-- The exact code location: file name and function or line number.
     Describe why the defect exists at that location — not just that it exists. -->

**Why existing tests miss it**
<!-- Name the test class or fixture closest to this case.
     Explain the specific gap: which value, type, or condition is absent. -->

**Proposed Mitigation**
<!-- The minimal code change that eliminates the defect.
     Must be a specific engineering action — not a monitoring recommendation. -->

### Resolution

<!-- Choose exactly one. Delete the others. -->

**FIX NOW**

<!-- Describe the minimal code change required.
     Describe the test that must be added to verify the fix.
     Confirm that the fix does not alter existing test behaviour. -->

---

**ACCEPT WITH DOCUMENTED RISK**

<!-- Explain why the current risk is acceptable.
     State the assumption that supports the acceptance
     (e.g., "the specification does not define valid ranges for this field").
     State the condition that would convert this to FIX NOW. -->

---

**DEFER WITH TICKET**

<!-- Describe what work is required before the defect can be fixed.
     Explain why it is safe to defer now.
     Record any temporary mitigation in place. -->

---

## Edge Case Finding

### Selected Candidate

**Title:**
<!-- One line: what is the untested input? -->

**Input Shape**
<!-- The exact combination of values, types, or structural conditions that triggers the failure.
     Be specific about types, ranges, and structural conditions. -->

**Observable Failure**
<!-- What the caller or user sees when this input is provided.
     Options: wrong return value, silent pass (validator accepts invalid state),
     exception, performance degradation, data corruption. -->

**Root Cause**
<!-- The exact code location: file name and function or line number.
     Describe why this input shape reaches the defective path. -->

**Why current tests miss it**
<!-- Name the test fixture or test class that is closest to this case.
     Explain the specific gap: which value, type, or condition is absent from the fixture. -->

**Proposed Mitigation**
<!-- The minimal change that handles this input correctly,
     or the acceptance rationale if this case is out of scope. -->

### Resolution

<!-- Choose exactly one. Delete the others. -->

**FIX NOW**

<!-- Describe the minimal code change required.
     Describe the test that must be added to verify the fix. -->

---

**ACCEPT WITH DOCUMENTED RISK**

<!-- Explain why the current risk is acceptable.
     State the assumption that supports the acceptance.
     State the condition that would convert this to FIX NOW. -->

---

**DEFER WITH TICKET**

<!-- Describe what work is required.
     Explain why it is safe to defer now. -->

---

## Validation

<!-- Complete this checklist after all resolution actions have been applied. -->

- [ ] Every finding cites a specific file, function, or line number.
- [ ] No finding repeats a prior review finding.
- [ ] No finding repeats a case already covered by the existing test suite.
- [ ] Each selected finding has exactly one resolution decision with a written justification.
- [ ] FIX NOW resolutions include a minimal code change description.
- [ ] FIX NOW resolutions include at least one new test.
- [ ] Full test suite passes after any code changes.
- [ ] Linting and type checking pass after any code changes.

---

## Overall Verdict

<!-- Choose exactly one. Delete the other. -->

**APPROVED**

<!-- State that the adversarial pass is complete, changes (if any) have been applied,
     and the implementation is cleared for the next stage of the engineering process. -->

---

**CHANGES REQUIRED**

<!-- State what must be resolved before this verdict can be re-evaluated.
     List the specific findings and their resolution requirements. -->
