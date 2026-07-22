---
id: TPL-GRC-000
title: "GitHub Required Check Template Set — README"
type: Template
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: templates
tags: [verification-gate, ci, github-actions, required-check, template]
depends_on: [STD-003, ADR-001, ADR-003]
related: [WF-002, AUTO-001, KR-K5D3]
supersedes: ""
superseded_by: ""
---

# Template Set — GitHub Required Check

**Template Set ID:** TPL-GRC  
**Version:** 1.0.0

---

## Purpose

This template set provides the three structural components needed to implement
a Verification Gate as a GitHub Actions Required Check, as defined in
STD-003 — Verification Gate Standard.

The templates are generic. They contain no repository-specific logic.
Every placeholder is explicitly marked with `{{UPPERCASE}}` notation.
Replace all placeholders before use.

---

## Contents

| File | Component | Role |
|---|---|---|
| `workflow.template.yml` | CI/CD Trigger | Defines when the gate runs; calls the script |
| `validation-script.template.sh` | Gate Script | All gate logic; locally executable |
| `ci.template.md` | Gate Documentation | Purpose, rules, admin step, limitations |

These three files implement the three-component structure defined in
STD-003 Section 9.

---

## Usage Instructions

### Step 1 — Identify what you are protecting

Before using these templates, complete the following:

1. Name the Engineering Assets the gate will protect.
2. List every condition the gate will enforce (each as a named binary assertion).
3. Identify which files will be checked and what structural property each
   check asserts.

Do not copy the templates until this list exists. A gate without a pre-defined
condition list will drift into checking whatever is convenient rather than
whatever is important.

### Step 2 — Copy the templates

Copy all three files into your repository:

```
.github/workflows/{{GATE_NAME}}.yml        ← from workflow.template.yml
scripts/ci/{{GATE_SCRIPT_NAME}}.sh         ← from validation-script.template.sh
docs/{{GATE_DOC_NAME}}.md                  ← from ci.template.md
```

### Step 3 — Replace all placeholders

Search for every occurrence of `{{...}}` in all three files. Replace each
placeholder with the value appropriate for your repository. See the placeholder
reference table below.

### Step 4 — Implement gate conditions

In the gate script, replace the example check blocks with the actual checks
for your conditions. Follow the pattern established in the template:

- One comment block per check explaining the rule.
- One `pass()` or `fail()` call per check.
- Dependency failures exit immediately.

### Step 5 — Verify both cases locally

```bash
# Failure case: corrupt or remove a protected condition, then run:
bash scripts/ci/{{GATE_SCRIPT_NAME}}.sh
# Confirm exit code 1 and correct FAIL: message

# Success case: restore the condition, then run:
bash scripts/ci/{{GATE_SCRIPT_NAME}}.sh
# Confirm exit code 0 and all PASS: messages
```

Document both results in your gate's documentation file.

### Step 6 — Promote to Required Check

After the first CI run completes, follow the admin step in the gate's
documentation file to configure branch protection and make the gate required.

---

## Placeholder Reference

| Placeholder | Where used | Description |
|---|---|---|
| `{{GATE_NAME}}` | workflow.yml, docs | Short identifier for this gate (e.g., `asset-integrity`) |
| `{{GATE_DISPLAY_NAME}}` | workflow.yml | Human-readable name shown in CI UI (e.g., `Validate engineering assets`) |
| `{{GATE_SCRIPT_NAME}}` | workflow.yml, docs | Filename of the gate script without extension (e.g., `validate-assets`) |
| `{{DEFAULT_BRANCH}}` | workflow.yml | The repository's default branch name (e.g., `main` or `master`) |
| `{{GATE_PURPOSE}}` | script, docs | One sentence describing what assets this gate protects and why |
| `{{PROTECTED_ASSET_1}}` | script, docs | Path or name of the first protected asset |
| `{{PROTECTED_ASSET_N}}` | script, docs | Additional protected assets |
| `{{CONDITION_N_NAME}}` | script | Short name for the Nth check (used in PASS:/FAIL: messages) |
| `{{CONDITION_N_RULE}}` | script, docs | Plain-language description of what the Nth check asserts |
| `{{SECTION_HEADING}}` | docs | The heading string the gate searches for in a document (e.g., `## My Section`) |

---

## Relationship to Standards

| Standard | Relationship |
|---|---|
| STD-003 — Verification Gate Standard | These templates implement the three-component structure defined in STD-003 Section 9 |

---

## Adapting to Other CI/CD Platforms

The gate script (`validation-script.template.sh`) is CI/CD platform-independent.
It requires only a POSIX-compatible shell and standard utilities (`awk`, `grep`,
`head`). It can be called from any CI/CD platform that can execute a shell script.

The workflow template (`workflow.template.yml`) is specific to GitHub Actions.
For other platforms:

| Platform | Equivalent mechanism |
|---|---|
| GitLab CI | `.gitlab-ci.yml` job calling the script |
| Azure DevOps | Pipeline YAML step calling the script |
| Jenkins | `Jenkinsfile` stage calling the script |
| Bitbucket Pipelines | `bitbucket-pipelines.yml` step calling the script |

The script is the portable part. The trigger file is the adapter.

---

## Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.3 kata execution |
