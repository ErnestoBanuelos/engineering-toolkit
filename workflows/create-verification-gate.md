---
id: WF-002
title: "Create Verification Gate Workflow"
type: Workflow
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: workflows
tags: [verification-gate, ci, required-check, engineering-assets, integrity]
depends_on: [STD-003, ADR-009]
related: [TPL-GRC-000, AUTO-001, STD-003]
supersedes: ""
superseded_by: ""
---

# WF-002 — Create Verification Gate

## 1. Purpose

This workflow defines the repeatable, deterministic sequence of steps for
implementing a Verification Gate in a repository that contains Engineering
Assets.

A Verification Gate is a CI check that runs on every proposed change and
exits non-zero when a named engineering condition is violated. The gate
protects engineering assets from silent degradation — changes that are
syntactically valid but remove, corrupt, or hollow out a required capability.

This workflow operationalises STD-003 — Verification Gate Standard. It is
not a substitute for reading that standard; it is the execution contract for
applying it.

---

## 2. Scope

This workflow applies to any repository that:

- contains one or more Engineering Assets as defined in ADR-002;
- uses a pull-request-based merge workflow;
- has access to a CI/CD platform capable of running shell scripts.

It does not govern:

- test suites for application behaviour;
- linting or code style enforcement;
- security scanning pipelines.

---

## 3. Inputs

| Input | Required | Description |
|---|---|---|
| List of Engineering Assets to protect | Yes | The specific files or sections that the gate will guard |
| List of gate conditions | Yes | Named, binary assertions — one per property to check |
| Repository default branch name | Yes | Used in the CI/CD trigger configuration |
| CI/CD platform | Yes | Determines which trigger template to use |

---

## 4. Outputs

| Output | Description |
|---|---|
| Gate script | Executable file containing all gate logic; runs locally |
| CI/CD trigger file | Platform-specific file that invokes the gate script on pull requests |
| Gate documentation | Records purpose, conditions, admin step, limitations, and verification results |

---

## 5. Pre-conditions

Before beginning this workflow:

- [ ] The Engineering Assets to be protected exist in the repository.
- [ ] STD-003 — Verification Gate Standard has been read and is understood.
- [ ] The conditions to enforce have been listed explicitly (do not design the
  gate and discover the conditions simultaneously).
- [ ] The template set `TPL-GRC-000` has been located.

---

## 6. Workflow Steps

### Step 1 — Select and name the gate

Define the gate's identity before writing any code.

**1a — Name the gate.**  
Choose a short, descriptive identifier. The name should reflect the asset
class being protected, not a technology. Examples:

- `asset-integrity` — protects general Engineering Assets
- `skill-integrity` — protects Skill definitions
- `context-integrity` — protects Context Bundle structure

The name will be used in:
- the CI/CD trigger filename;
- the gate script filename;
- the documentation filename;
- the CI/CD status check display name.

**1b — State the purpose in one sentence.**  
Write a single sentence: "This gate protects `<asset(s)>` by asserting that
`<property>` remains true on every proposed change." If this sentence cannot
be written, the gate's scope is undefined.

---

### Step 2 — List conditions before implementation

Before writing any code, produce a numbered list of every condition the gate
will enforce. Each condition must be:

- named (a short label, not just a number);
- a single binary assertion (true or false, not a score or a range);
- independently evaluable (no condition's result depends on another).

**Example format:**

```
1. FILE_EXISTS      — <asset_path> exists on disk
2. FM_OPENS         — <asset_path> begins with a YAML frontmatter delimiter
3. FM_CLOSES        — <asset_path> has a closing frontmatter delimiter
4. FIELD_NAME       — frontmatter contains the 'name' key
5. FIELD_DESCR      — frontmatter contains the 'description' key
6. BODY_NONEMPTY    — document body after frontmatter is not empty
7. CONTEXT_SECTION  — <context_file> contains the required section heading
```

This list becomes the gate's authoritative specification. Implement exactly
these conditions — no more, no fewer — without redesigning them during
implementation.

---

### Step 3 — Separate workflow from script

Create two files:

**3a — Gate script** (`scripts/ci/<gate-script-name>.sh`)

Copy `validation-script.template.sh` from `TPL-GRC-000`. Replace all
placeholders. Implement the conditions from Step 2.

Structure requirements (per STD-003):
- Each condition has its own comment block stating the rule.
- Each condition calls `pass()` or `fail()` with a named, descriptive message.
- Dependency failures (missing files) exit immediately after reporting.
- The script exits `0` iff all conditions pass; `1` if any fail.
- The script runs from the repository root without additional dependencies.

**3b — CI/CD trigger** (`.github/workflows/<gate-name>.yml` or equivalent)

Copy `workflow.template.yml` from `TPL-GRC-000`. Replace all placeholders.

Structure requirements (per STD-003):
- The trigger file contains no gate logic.
- Its only responsibility is: check out the repository; call the script.
- The trigger runs on pull requests targeting the default branch.

The script and the trigger are separate files with separate responsibilities.
The script is the portable, testable artifact. The trigger is the adapter
that connects it to the CI/CD platform.

---

### Step 4 — Test the failure case

Before merging the gate, demonstrate that it can detect a violation.

**4a — Induce a failure.**  
For each condition (or at minimum, one representative condition per category):

1. Temporarily corrupt or remove the protected property.
2. Run the gate script locally: `bash scripts/ci/<gate-script-name>.sh`
3. Confirm exit code is `1`.
4. Confirm the `FAIL:` message names the condition clearly and correctly.

**4b — Record the failure result.**  
Document in the gate's documentation file:
- What was temporarily changed.
- The exact `FAIL:` message produced.
- The exit code observed.

A gate that has not been tested in a failing state is not a verified gate.
It is a script that has only been run when nothing was wrong.

---

### Step 5 — Test the success case

Restore the repository to its correct state.

**5a — Restore the protected property.**  
Undo the change made in Step 4a.

**5b — Run the gate script locally.**
```bash
bash scripts/ci/<gate-script-name>.sh
```

**5c — Confirm the result.**
- Every condition produces a `PASS:` line.
- Exit code is `0`.

**5d — Record the success result.**  
Document in the gate's documentation file:
- The state of the repository (unmodified, all assets intact).
- The full script output.
- The exit code observed.

---

### Step 6 — Create gate documentation

Copy `ci.template.md` from `TPL-GRC-000`. Replace all placeholders. Complete:

- Purpose section: name the protected assets and why they matter.
- Rules table: list every condition with the affected file.
- Local test instructions: exact commands to run.
- Branch protection admin step: how to promote to Required Check.
- Known limitations: list bypass paths and known gaps.
- Verification record: paste the results from Steps 4 and 5.

The documentation is not optional. It is the third component of the gate
(per STD-003 Section 9) and the primary resource for any engineer who
encounters a gate failure.

---

### Step 7 — Document admin steps and promote to Required Check

A gate that runs but does not block merging has no enforcement value.

**7a — Identify the repository admin.**  
Branch protection configuration requires repository administrator access.
Identify the person or team responsible before the gate is merged.

**7b — Confirm the CI/CD job name.**  
The status check name in the hosting service is the `name:` field of the
CI/CD job definition — not the workflow file name. Confirm this before asking
the admin to search for it.

**7c — Document the exact admin step.**  
In the gate's documentation file, provide step-by-step instructions specific
to the repository's hosting service. Do not assume the admin is familiar with
the process.

**7d — Track promotion.**  
If the admin step cannot be completed immediately, create a tracking item
with a specific owner and deadline. An untracked advisory gate will remain
advisory indefinitely.

---

## 7. Exit Criteria

The workflow is complete when:

- [ ] The gate script exists and is executable.
- [ ] The CI/CD trigger file exists and references the gate script.
- [ ] Gate documentation exists with purpose, conditions, and admin step.
- [ ] Failure case has been tested and the result is documented.
- [ ] Success case has been tested and the result is documented.
- [ ] The gate has been promoted to Required Check, or a tracked item exists
      with a named owner and deadline.

---

## 8. Decision Points

### When should logic remain in the trigger file?

Never. If gate logic is in the trigger file, it cannot be run locally without
the CI/CD platform. Move it to the script.

### How many conditions should a gate enforce?

As many as needed to protect the assets, and no more. A gate with twenty
conditions is harder to maintain and produces noisier failures than a gate
with seven well-chosen conditions. Prefer focused gates over comprehensive gates.
If protection requirements are broad, consider two focused gates rather than
one sprawling gate.

### Should conditions be ordered?

Yes. Existence checks must precede structural checks on the same file.
If a file does not exist, checking its contents produces a confusing error,
not a useful failure message. Use the dependency-guard pattern: check for
existence, exit immediately if absent, then proceed with structural checks.

### When is a gate advisory vs. required?

A gate that is not required provides false assurance. It communicates "this
was checked" without providing "this is enforced." Gates should be required
by default. Advisory status is a temporary state while waiting for the admin
to configure branch protection — not a permanent operational mode.

---

## 9. Anti-Patterns

| Anti-pattern | Problem | Correct approach |
|---|---|---|
| Implementing conditions during testing | Conditions discovered during testing are often incomplete | List conditions before implementation |
| Merging a gate without testing failure | Does not prove the gate can detect what it claims to detect | Test failure case before merging |
| Leaving the gate advisory indefinitely | No enforcement value | Promote to Required Check with a deadline |
| Checking only file existence | A file may exist and be empty or corrupt | Check existence and structural validity |
| Combining multiple assets in one gate | Single gate failure is ambiguous | One gate per asset class |
| Embedding the check name in the failure message differently from the condition list | Makes failures harder to trace back to the specification | Use the condition names from Step 2 verbatim |

---

## 10. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.3 kata execution |
