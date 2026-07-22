---
id: AUTO-001
title: "Verification Gate Bootstrap — AI Workflow"
type: Automation
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: automation
tags: [verification-gate, ai-workflow, bootstrap, automation, ci, engineering-assets]
depends_on: [STD-003, WF-002, TPL-GRC-000]
related: [KR-K5D3]
supersedes: ""
superseded_by: ""
---

# AUTO-001 — Verification Gate Bootstrap

## 1. Purpose

This document describes a reusable AI-assisted workflow that generates a
Verification Gate for any repository.

The workflow is designed for execution by an AI engineering assistant
operating with a project Context Bundle loaded. It produces the three gate
components defined in STD-003 (gate script, CI/CD trigger, gate documentation)
tailored to the specific Engineering Assets in the target repository.

This automation does not replace the engineering judgment required to select
conditions and verify the gate. It accelerates the mechanical construction
steps so that engineer effort is concentrated on design decisions and
verification.

---

## 2. Scope

This automation applies to any repository that:

- contains Engineering Assets as defined in ADR-002;
- has a pull-request-based merge workflow;
- has access to a CI/CD platform capable of executing shell scripts.

It produces GitHub Actions-compatible output by default. For other platforms,
the gate script is identical; only the trigger file format differs (see
TPL-GRC-000 README — Adapting to Other CI/CD Platforms).

---

## 3. Prerequisites

Before invoking this automation, the engineer must provide:

| Input | Required | How to obtain |
|---|---|---|
| List of Engineering Assets to protect | Yes | Inspect the repository; identify files that, if deleted or corrupted, would degrade an engineering capability |
| List of gate conditions | Yes | Complete WF-002 Step 2 before invoking the automation |
| Repository default branch | Yes | From the repository settings or `git branch --show-current` on the default branch |
| Gate name | Yes | Short identifier chosen per WF-002 Step 1 |
| CI/CD platform | Yes | GitHub Actions (default), or specify alternative |

The condition list from WF-002 Step 2 is the critical prerequisite. This
automation implements conditions; it does not design them. A condition list
that has not been reviewed by a human engineer should not be fed into this
automation.

---

## 4. Engineering Assets Referenced

This automation depends on and references the following Engineering Toolkit
assets:

| Asset | Role |
|---|---|
| STD-003 — Verification Gate Standard | Defines what a Verification Gate is and what it must satisfy |
| WF-002 — Create Verification Gate Workflow | The human workflow this automation accelerates |
| TPL-GRC-000 — GitHub Required Check Template Set | The structural templates the automation populates |

The automation implements the rules defined in STD-003. It does not
redefine or override them.

---

## 5. AI Workflow

The following is the AI assistant prompt workflow. Each phase is a discrete
instruction. Execute phases in order. Do not skip phases.

---

### Phase 0 — Load context

**Instruction to AI:**

```
Read the following before proceeding:

1. STD-003 — Verification Gate Standard
   (engineering-toolkit/standards/verification-gate.md)

2. WF-002 — Create Verification Gate Workflow
   (engineering-toolkit/workflows/create-verification-gate.md)

3. TPL-GRC-000 — GitHub Required Check Template Set
   (engineering-toolkit/templates/github-required-check/)

4. The target repository's Context Bundle (CLAUDE.md and docs/context/stack.md)

Confirm that you have read all four inputs before proceeding to Phase 1.
```

**Expected output:** Confirmation that all four inputs have been read, with a
brief summary of the target repository's Engineering Assets.

---

### Phase 1 — Analyse Engineering Assets

**Instruction to AI:**

```
Inspect the target repository and identify every Engineering Asset that exists
and could be protected by a Verification Gate.

For each asset, state:
- File path
- Asset type (per ADR-002 category list)
- What structural property would be most valuable to protect
- Whether that property is currently checked by any existing CI pipeline

Do not implement anything in this phase. Only analyse and report.
```

**Expected output:** A table of discoverable Engineering Assets, their types,
and candidate protection properties.

**Human review point:** Review the asset list. Add any assets the AI missed.
Remove any that are not worth protecting at this time. Confirm before proceeding.

---

### Phase 2 — Define conditions

**Instruction to AI:**

```
Using the asset list confirmed in Phase 1, produce the condition list for the
Verification Gate.

Follow the format from WF-002 Step 2:

  N. CONDITION_NAME — plain-language description of the binary assertion

Rules (from STD-003):
- Each condition is a single binary assertion.
- Existence checks precede structural checks on the same file.
- Conditions are ordered so that dependency failures exit before structural
  checks run.

Do not implement anything in this phase. Only produce the condition list.
```

**Expected output:** A numbered condition list with short names and plain-language
descriptions.

**Human review point:** Review every condition. Add, remove, or rename as
appropriate. This list is the gate's specification. Approve it explicitly before
Phase 3.

---

### Phase 3 — Generate the gate script

**Instruction to AI:**

```
Using the approved condition list from Phase 2 and the template
`validation-script.template.sh` from TPL-GRC-000, generate the gate script.

Target path: scripts/ci/{{GATE_SCRIPT_NAME}}.sh

Requirements (from STD-003):
- All placeholders replaced with repository-specific values.
- Each condition has its own comment block stating the rule.
- Each condition calls pass() or fail() with a named, descriptive message.
- Dependency failures (missing files) exit immediately.
- Exit 0 iff all conditions pass; exit 1 if any fail.
- Script runs from the repository root without additional installation.
- --help flag prints the header comment block.

Write the complete file. Do not abbreviate.
```

**Expected output:** The complete gate script, ready to write to disk.

**Human review point:** Review the script against the condition list from
Phase 2. Confirm each condition is present and correctly implemented. Check
failure messages for clarity.

---

### Phase 4 — Generate the CI/CD trigger

**Instruction to AI:**

```
Using the template `workflow.template.yml` from TPL-GRC-000, generate the
CI/CD trigger file for the gate.

Target path: .github/workflows/{{GATE_NAME}}.yml

Requirements (from STD-003):
- All placeholders replaced.
- File contains no gate logic.
- Trigger runs on pull requests targeting {{DEFAULT_BRANCH}}.
- The single step calls the gate script generated in Phase 3.
- File is under 30 lines.

Write the complete file. Do not abbreviate.
```

**Expected output:** The complete trigger file.

---

### Phase 5 — Generate gate documentation

**Instruction to AI:**

```
Using the template `ci.template.md` from TPL-GRC-000, generate the gate
documentation file.

Target path: docs/{{GATE_DOC_NAME}}.md

Requirements (from STD-003 Section 9, Component 3):
- Purpose section names the protected assets.
- Rules table lists every condition from Phase 2 with the affected file.
- Local test instructions include the exact command to run.
- Branch protection admin step provides numbered instructions.
- Known limitations section lists bypass paths.
- Verification Record section has headings ready for Phase 6 results.

Write the complete file. Do not abbreviate the conditions table.
```

**Expected output:** The complete documentation file with a blank Verification
Record section ready to be completed in Phase 6.

---

### Phase 6 — Verify the gate

**Instruction to AI:**

```
Perform local verification of the gate.

Failure case:
1. Temporarily corrupt or remove one protected condition from the repository.
2. Run: bash scripts/ci/{{GATE_SCRIPT_NAME}}.sh
3. Report the exact output and exit code.
4. Confirm the FAIL: message names the condition correctly.
5. Restore the repository to its original state.

Success case:
1. Confirm the repository is fully intact.
2. Run: bash scripts/ci/{{GATE_SCRIPT_NAME}}.sh
3. Report the exact output and exit code.
4. Confirm every condition produces a PASS: line.

Insert both results into the Verification Record section of the documentation
file generated in Phase 5.
```

**Expected output:** The documentation file updated with both verification
results. Exit codes and outputs verbatim.

**Human review point:** Review both verification results. Confirm the failure
message is clear and correctly identifies the violated condition. Confirm the
success output shows all conditions passing.

---

### Phase 7 — Produce summary

**Instruction to AI:**

```
Produce a summary of the gate implementation:

1. Files created (path and purpose for each)
2. Conditions enforced (from the approved list in Phase 2)
3. Verification results (pass/fail for both cases)
4. Admin step required before the gate is enforced
5. Known limitations identified
```

**Expected output:** A structured summary suitable for inclusion in a pull
request description or engineering log.

---

## 6. Human Responsibilities

This automation generates mechanical artefacts. The following decisions always
require human judgment:

| Decision | Why human judgment is required |
|---|---|
| Which assets to protect | Requires understanding of what matters most in the repository |
| Condition selection | A condition that seems obvious may be wrong, redundant, or insufficient |
| Condition review (Phase 2) | The condition list is the gate's specification; it must be approved before implementation |
| Script review (Phase 3) | Generated code must be read and understood before it is trusted |
| Failure message quality | Only a human can judge whether a failure message would be immediately understood by another engineer |
| Branch protection promotion | Requires repository administrator access and a deliberate engineering decision |

---

## 7. Limitations

| Limitation | Detail |
|---|---|
| Condition design is not automated | The automation implements conditions; it does not design them. Human analysis of the repository is required in Phase 1 and Phase 2. |
| Gate script is POSIX shell only | The template assumes a bash-compatible shell. Repositories with restricted CI environments may require adjustments. |
| GitHub Actions trigger only | The template set includes a GitHub Actions trigger. Other platforms require adapting the trigger file format while retaining the script unchanged. |
| The gate cannot protect itself | A PR that deletes the gate files bypasses the gate. This is an inherent limitation of all self-referential verification systems. |
| Branch protection is out of scope | The automation generates the gate but cannot configure branch protection. Human admin action is always required. |

---

## 8. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.3 kata execution |
