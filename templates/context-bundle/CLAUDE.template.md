---
id: TPL-CB-001
title: "Hot Context Template (CLAUDE.md)"
type: Template
status: Draft
version: 1.0.0
created: 2026-07-22
updated: 2026-07-22
owner: ""
maintainer: ""
domain: templates
tags: [context-bundle, hot-context, ai-instructions, behavioural-rules]
depends_on: [ADR-004, ADR-011, STD-001]
related: [TPL-CB-002, TPL-CB-003, TPL-CB-004]
supersedes: ""
superseded_by: ""
---

<!--
TEMPLATE USAGE
==============
This template produces the Hot Context layer of a project's Context Bundle.

Instantiation steps:
  1. Copy this file to the project root as CLAUDE.md
     (or the equivalent AI-assistant instruction file for your tooling).
  2. Replace all {{PLACEHOLDER}} values with project-specific content.
  3. Remove this comment block before committing.
  4. Keep the file to one screen (approximately 80 lines).
  5. Every line must be a permanent behavioural rule or constraint.
     Remove any line that is a fact, a stack reference, or an implementation detail.

Layer placement rules (STD-001):
  - Hot Context = rules only; no facts, no stack versions, no file paths.
  - If content exceeds 80 lines, move the excess to Warm Context.
  - If a claim requires verification, it belongs in Warm Context, not here.

Do NOT commit this template to the Engineering Toolkit.
Completed instances belong to the consuming project.
-->

# CLAUDE.md — Hot Context

## Identity

{{PROJECT_IDENTITY_STATEMENT}}

<!-- One to three sentences. Describe what this project is and its primary
     engineering constraint. Example: "This repository is a read-only analysis
     tool. It reads artefacts, produces structured outputs, and escalates all
     write actions to named human roles." -->

---

## Non-Negotiable Rules

<!-- List permanent behavioural rules. Each rule must:
     - be true across the entire project lifetime;
     - change AI behaviour if absent;
     - contain no stack references, version numbers, or file paths.
     Aim for 5–10 rules. More than 10 suggests some belong in Warm Context. -->

1. **{{RULE_1_TITLE}}**
   {{RULE_1_DESCRIPTION}}

2. **{{RULE_2_TITLE}}**
   {{RULE_2_DESCRIPTION}}

3. **{{RULE_3_TITLE}}**
   {{RULE_3_DESCRIPTION}}

<!-- Add rules as needed. Remove this comment block before committing. -->

---

## Escalation Policy

<!-- Optional but recommended for projects where human approval is required
     before certain actions are taken. Define the standard escalation block
     format so every escalation is structured identically. -->

```
ESCALATION REQUIRED
Action:    <the specific action that must be taken>
Role:      <the named human role responsible>
Condition: <trigger or approval gate>
Artefact:  <relevant document or reference>
```

---

## Gap Handling

<!-- Describe how unknown or missing information should be handled.
     Replace this section if the project has no gap-handling convention. -->

When information required to complete a task is absent, state the gap explicitly
rather than inferring or fabricating. An incomplete output is more honest than a
fabricated one.

---

## Safety Statement

<!-- Optional. Include if the project has a safety or read-only constraint
     that must be stated explicitly. -->

{{SAFETY_STATEMENT}}

<!-- Example: "The read-only constraint is not configurable. Any fork removing
     this constraint requires explicit approval from {{APPROVER_ROLE}} before
     use against live infrastructure." -->
