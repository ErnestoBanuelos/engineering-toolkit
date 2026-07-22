# CI Gate — {{GATE_DISPLAY_NAME}}

<!--
  Template: ci.template.md (TPL-GRC-000)
  Standard: STD-003 — Verification Gate Standard
  Replace all {{PLACEHOLDER}} values before use.
-->

## Purpose

This gate protects the repository's engineering assets on every pull request.
It ensures that:

{{ASSET_PROTECTION_DESCRIPTION}}

Without this gate, a pull request could silently degrade an Engineering Asset
while passing all other CI checks.

---

## Rule Enforced

The CI job `validate` in `.github/workflows/{{GATE_NAME}}.yml` fails (exit 1)
if **any** of the following is true:

| # | Condition | Checked asset |
|---|---|---|
| 1 | {{CONDITION_1_RULE}} | `{{PROTECTED_ASSET_1}}` |
| 2 | {{CONDITION_2_RULE}} | `{{PROTECTED_ASSET_2}}` |
| 3 | {{CONDITION_3_RULE}} | `{{PROTECTED_ASSET_1}}` |
| 4 | {{CONDITION_4_RULE}} | `{{PROTECTED_ASSET_1}}` |
| 5 | {{CONDITION_5_RULE}} | `{{PROTECTED_ASSET_1}}` |
| 6 | {{CONDITION_6_RULE}} | `{{PROTECTED_ASSET_2}}` |

The gate exits 0 (success) only when all conditions are satisfied.

All validation logic lives in `scripts/ci/{{GATE_SCRIPT_NAME}}.sh`.
The workflow YAML is a thin runner — it checks out the repository and calls
the script.

---

## How to Test Locally

Run the script from the repository root:

```bash
bash scripts/ci/{{GATE_SCRIPT_NAME}}.sh
```

Expected output on a clean repository:

```
=== {{GATE_DISPLAY_NAME}} ===
Asset 1: {{PROTECTED_ASSET_1}}
Asset 2: {{PROTECTED_ASSET_2}}

PASS: <condition 1>
PASS: <condition 2>
PASS: <condition 3>
...

=== Result: PASSED (all checks passed) ===
```

To test a failure, temporarily corrupt or remove a protected condition and
re-run. The script will print `FAIL:` lines and exit 1. Restore the condition
to return to a passing state.

For inline help:

```bash
bash scripts/ci/{{GATE_SCRIPT_NAME}}.sh --help
```

---

## Branch Protection — Admin Step

To make this gate **required** (blocking merge), a repository admin must
configure branch protection after the first CI run completes:

1. Go to **Settings → Branches** in the repository hosting service.
2. Add or edit the protection rule for `{{DEFAULT_BRANCH}}`.
3. Enable **Require status checks to pass before merging**.
4. Search for and select the check named **`{{GATE_DISPLAY_NAME}}`**.
5. Enable **Require branches to be up to date before merging**.
6. Save the rule.

Until these steps are completed, the workflow runs on every pull request but
does not block merging. The gate is advisory only until branch protection is
applied.

> **Note:** The status check name that appears in the CI UI is the `name:`
> field of the job in the workflow file — `{{GATE_DISPLAY_NAME}}`. Use this
> exact string when searching for the check to require.

---

## Known Limitations

| Limitation | Detail |
|---|---|
| Logic is not self-protecting | A pull request that deletes the workflow file or the script removes the gate. Mitigate with code ownership rules requiring admin review on pipeline files. |
| Gate does not run on direct push | The workflow triggers on `pull_request` only. Direct pushes to `{{DEFAULT_BRANCH}}` bypass the gate. Branch protection (admin step above) is required to prevent this. |
| Structural checks are presence-based | The gate verifies that required content is present; it does not parse or semantically validate content. Structural checks are faster and more reliable, but deeper validation requires additional tooling. |
| Script requires bash 4+ | Uses `(( ))` and `[[ ]]` constructs. Standard on Linux CI runners. macOS users may need to upgrade bash via a package manager. |

---

## Verification Record

<!--
  Complete this section after performing both verification cases.
  Do not merge a gate that has not been verified in both states.
-->

### Failure Case

**Change made:** {{FAILURE_TEST_DESCRIPTION}}

**Script output:**
```
(paste actual output here)
```

**Exit code:** 1 ✓

---

### Success Case

**State:** Repository fully intact

**Script output:**
```
(paste actual output here)
```

**Exit code:** 0 ✓

---

## Files

| File | Purpose |
|---|---|
| `.github/workflows/{{GATE_NAME}}.yml` | CI/CD trigger — runs on PR; calls the script |
| `scripts/ci/{{GATE_SCRIPT_NAME}}.sh` | All validation logic |
| `docs/{{GATE_DOC_NAME}}.md` | This file |
