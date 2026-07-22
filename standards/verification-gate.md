---
id: STD-003
title: "Verification Gate Standard"
type: Standard
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: standards
tags: [verification, ci, gate, quality, integrity, automation, engineering-assets]
depends_on: [ADR-000, ADR-001, ADR-002, ADR-007, ADR-009]
related: [STD-001, STD-002, WF-002, TPL-GRC-000, AUTO-001]
supersedes: ""
superseded_by: ""
---

# STD-003 — Verification Gate Standard

## 1. Purpose

This standard defines what a Verification Gate is, how it is structured, what
it must and must not do, and the engineering principles that govern its design
and operation.

A Verification Gate is a deterministic, automated check that runs on every
proposed change to a repository and fails explicitly when a stated engineering
condition is not satisfied. Its purpose is to protect engineering assets from
silent degradation — changes that are syntactically valid and merge-eligible
but that damage the integrity, completeness, or portability of the repository's
engineering capabilities.

This standard operationalises ADR-000 Principle P5 (Evidence Before Trust)
and ADR-009 (Evidence & Verification Model) at the repository change-control
layer.

---

## 2. Scope

This standard applies to:

- any repository that contains Engineering Assets as defined in ADR-002;
- any automated check intended to protect those assets on proposed changes;
- any engineer designing, implementing, reviewing, or operating a Verification Gate.

This standard does not govern:

- test suites that verify application behaviour (those are Verification Assets
  in the ADR-009 sense; Verification Gates protect engineering assets, not
  application behaviour);
- general linting or style enforcement (those are code quality checks, not
  Verification Gates);
- security scanning or dependency auditing (those are supply-chain controls,
  not Verification Gates).

---

## 3. Terminology

| Term | Definition |
|---|---|
| **Verification Gate** | An automated check that runs on proposed changes and exits non-zero when a defined engineering condition is violated |
| **Gate condition** | A single, named, testable property that the gate asserts must be true |
| **Protected asset** | An Engineering Asset whose integrity the gate is designed to preserve |
| **Failure message** | The human-readable output produced when a gate condition is not satisfied |
| **Exit code** | The integer returned by the gate process: `0` for all conditions satisfied, non-zero for any condition violated |
| **Thin runner** | The CI/CD pipeline trigger file whose sole responsibility is to invoke the gate script; it contains no logic |
| **Gate script** | The executable file containing all gate logic; it is the single source of truth for gate behaviour |
| **Advisory gate** | A Verification Gate that runs but does not block merging |
| **Required gate** | A Verification Gate that blocks merging until it passes; enforced by repository branch protection |

---

## 4. Verification Philosophy

### P1 — Gates protect, they do not discover

A Verification Gate is not a linter or a test runner. Its role is to assert
that a specific, named engineering condition remains true after a proposed
change. The conditions to protect are determined before the gate is implemented,
not discovered by the gate at runtime.

### P2 — Every condition is explicit and named

A gate that produces a pass result without explicitly evaluating every condition
is not a Verification Gate — it is a script that happens to exit zero. Every
condition must be named, evaluated independently, and reported individually in
the output.

### P3 — Failure messages are engineering communications

A failing gate is the most important output the gate ever produces. The failure
message must name the file, the condition, and, where possible, the observed
value that violated the condition. A cryptic failure message that requires an
engineer to read the source code to understand what went wrong is a gate defect.

### P4 — Logic lives in the script, not the pipeline

CI/CD pipeline trigger files define when a gate runs and what runner it uses.
They do not define what the gate checks. All gate logic belongs in an executable
script that can be run locally without the CI/CD platform. This separation is
not a preference — it is what makes a gate independently testable.

### P5 — Gates are testable before deployment

Every Verification Gate must be verified before it is merged:

1. A failure case must be demonstrated: remove or corrupt a protected condition;
   confirm the gate exits non-zero with the expected failure message.
2. A success case must be demonstrated: restore the condition; confirm the gate
   exits zero.

A gate that has not been tested in both states is not a verified gate.

### P6 — Self-protection is limited

A gate cannot reliably protect itself. A change that deletes the gate file or
the pipeline trigger removes the gate's ability to run. This is an inherent
limitation of any self-referential verification system. Mitigations (such as
code ownership rules or additional checks protecting pipeline definitions) are
advisable but never complete.

---

## 5. Pass / Fail Semantics

### Exit Codes

| Exit code | Meaning |
|---|---|
| `0` | All gate conditions are satisfied; the protected assets are intact |
| `1` | One or more gate conditions are violated; details are in the output |

Only exit codes `0` and `1` are defined by this standard. Other exit codes
(e.g., `2` for configuration errors, `127` for command not found) may occur
due to script or environment failures; these are treated as gate failures by
most CI/CD platforms and are acceptable.

### Partial Failure

A Verification Gate must report all failures before exiting. It must not exit
on the first failure unless subsequent checks depend on a missing file or
resource that would cause the script itself to fail with an error. When a
dependency failure makes further checks impossible, the gate must:

1. Report the dependency failure.
2. Exit with code `1` immediately.
3. Document in the failure message which subsequent checks were skipped and why.

### Pass vs. SKIP

Skipping a check is not passing it. A condition that cannot be evaluated (for
example, because the file it would inspect is absent) must be reported as a
failure, not silently skipped.

---

## 6. Exit Code Rules

The gate script is the authoritative source of exit codes.

The following rules are non-negotiable:

| Rule | Statement |
|---|---|
| R1 | The script exits `0` if and only if every defined condition evaluates to true |
| R2 | The script exits `1` if any condition evaluates to false |
| R3 | The script never exits `0` when a condition has been skipped rather than evaluated |
| R4 | Exit codes are produced by the gate script, not by the CI/CD pipeline trigger |
| R5 | The script must be runnable locally without CI/CD infrastructure and must produce the same exit code |

---

## 7. Engineering Principles

### Principle 1 — One script, one gate

Each Verification Gate is implemented as exactly one executable script. Multiple
gates may exist in a repository. Each gate has its own script and its own
pipeline trigger.

### Principle 2 — Conditions are documented before implementation

Before implementing a gate, list every condition it will enforce. Each condition
must be expressible as a single pass/fail assertion. If a condition cannot be
expressed as a binary assertion, it is not a gate condition — it is a metric or
a heuristic, and it belongs in a different type of check.

### Principle 3 — Scripts over embedded logic

All validation logic must reside in an executable script, not in the CI/CD
pipeline trigger file. This rule enables local execution, independent testing,
and portability across CI/CD platforms.

### Principle 4 — Fail fast on dependency errors

When a check depends on a file or resource that is missing, the gate should
detect the absence, report it clearly, and exit immediately rather than
producing cascading errors. The failure message should name the missing resource
and its expected location.

### Principle 5 — No false positives by design

A gate condition that sometimes fails on a correctly-configured repository
trains engineers to dismiss gate failures. Every condition must be deterministic
and reliable. If a condition is inherently probabilistic or environment-dependent,
it does not belong in a Verification Gate.

### Principle 6 — Minimal dependencies

Gate scripts should rely only on tools that are reliably present in the target
execution environment without additional installation steps. A gate that
requires installing a language runtime or package manager before it can run
creates fragile CI and slow local execution.

### Principle 7 — Gates require human promotion to Required

An advisory gate (one that runs but does not block merging) has no enforcement
value. A Verification Gate must be promoted to a Required Check via repository
branch protection to fulfil its purpose. This promotion requires a human
administrator and must be documented in the gate's accompanying documentation.

---

## 8. Anti-Patterns

| Anti-pattern | Problem | Correct approach |
|---|---|---|
| Logic embedded in the pipeline trigger file | Not locally testable; CI platform–specific; hard to review | Move all logic to a script; the trigger file calls the script |
| Checking only that a file exists, not that it is valid | A file may exist and be empty, corrupt, or stripped of required content | Check existence and structural validity independently |
| Producing a single pass/fail result without named conditions | An engineer receiving a failure cannot identify what failed | Report each condition as a named `PASS:` or `FAIL:` line |
| Silently skipping a condition | Creates the appearance of a passing gate with incomplete coverage | Report every skipped condition as a failure with a reason |
| Catching a specific error and returning exit 0 | Hides real failures; produces false confidence | Let the failure propagate; report it |
| Using a gate to enforce code style | Style enforcement is the responsibility of a linter, not a Verification Gate | Use a linter; reserve gates for engineering-asset integrity |
| Testing only the success case | Does not prove the gate can detect failures | Always test at least one failure case before merging a new gate |
| Gate that requires network access or external services | Fragile in offline or restricted CI environments | Use only local file system checks and deterministic assertions |
| Gates that accumulate over time without review | Slows CI; makes individual failures harder to diagnose | Review and retire gates that no longer protect active assets |

---

## 9. Gate Structure

Every Verification Gate implementation consists of three components:

### Component 1 — Gate Script

An executable script that:

- accepts no required arguments (optionally accepts `--help`);
- runs from the repository root;
- evaluates each condition independently;
- prints `PASS: <condition description>` for each satisfied condition;
- prints `FAIL: <condition description> — <observed value or reason>` for each
  violated condition;
- exits `0` if all conditions pass;
- exits `1` if any condition fails.

### Component 2 — CI/CD Trigger

A pipeline definition file that:

- triggers on the appropriate event (pull request, pre-merge, schedule);
- checks out the repository at full depth if the gate needs commit history;
- calls the gate script as a single step;
- contains no gate logic.

### Component 3 — Gate Documentation

A documentation file that records:

- the purpose of the gate and the assets it protects;
- every condition the gate enforces, in a numbered list or table;
- how to run the gate locally;
- how to promote the gate to a Required Check;
- known limitations and bypass paths.

---

## 10. Review Checklist

Use this checklist when reviewing a proposed Verification Gate.

```
Pre-implementation
□ Every condition is listed and named before implementation begins
□ Each condition is expressible as a single binary assertion
□ No condition duplicates existing checks already in the pipeline

Script
□ All logic is in the script; none is in the trigger file
□ Each condition is evaluated independently
□ Each condition produces a named PASS: or FAIL: line
□ Exit code is 0 iff all conditions pass; 1 if any condition fails
□ Failure messages name the file, condition, and observed value
□ The script runs locally from the repository root without CI/CD infrastructure
□ The script requires no installation steps beyond what is already available
□ Dependency failures exit immediately with a descriptive message

CI/CD Trigger
□ Trigger file contains no gate logic
□ Trigger calls the script as a single step
□ Trigger runs on the correct event (e.g., pull request)
□ Trigger targets the correct branch

Testing
□ At least one failure case has been demonstrated (gate exits 1)
□ The success case has been demonstrated (gate exits 0)
□ Both test results are documented

Documentation
□ Gate purpose is stated
□ Every condition is listed
□ Local execution instructions are present
□ Admin promotion step is described
□ Known limitations are documented (including bypass paths)

Promotion
□ Admin has been notified to configure branch protection
□ Gate is promoted to Required Check or a tracking issue exists
```

---

## 11. Relationship to ADRs

| ADR | Relationship |
|---|---|
| ADR-000 P5 — Evidence Before Trust | Constitutional basis: gates produce automated evidence that conditions are satisfied |
| ADR-000 P6 — Human Accountability | Gate promotion to Required Check requires human administrator action |
| ADR-001 Section 4.13 — Automation | Gates are Automation assets; they implement policy, they do not define it |
| ADR-002 — Engineering Asset Model | The gate script, trigger, and documentation together form an Engineering Asset |
| ADR-007 — Repository Governance | Required gates are a governance enforcement mechanism; they do not replace governance |
| ADR-009 — Evidence & Verification Model | The gate's pass/fail results are a form of automated verification evidence |

---

## 12. Version History

| Version | Date | Change |
|---|---|---|
| 1.0.0 | 2026-07-22 | Initial release — extracted from K 5.D.3 kata execution |
