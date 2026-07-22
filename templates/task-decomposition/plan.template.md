---
asset_id: TPL-TD-001
asset_type: Template
title: Implementation Plan Template
version: 1.0.0
status: Draft
owner: Engineering Toolkit Maintainer
created: 2026-07-22
last_modified: 2026-07-22
depends_on:
  - STD-007
  - ADR-002
  - ADR-003
related:
  - TPL-TD-000
  - TPL-TD-002
  - WF-005
tags:
  - task-decomposition
  - implementation-plan
  - template
  - planning
---

<!--
USAGE INSTRUCTIONS (remove this block before publishing the plan)

This template produces an Implementation Plan: the first planning artefact
in a task decomposition. It translates a specification or Brownfield Delta
into a set of implementation components — one per logical section of the
source document.

Before filling this template:
  1. Read STD-007 (Engineering Task Decomposition Standard) in full.
  2. Read the approved specification or Brownfield Delta in its entirety.
  3. Identify the logical sections of the source document. Each section
     that represents a distinct concern becomes one component.

Replace every {{PLACEHOLDER}} with real content.
A template that still contains {{...}} tokens is not ready for review.

Section ordering is fixed. Do not reorder, rename, or remove sections.
Fill tasks.template.md (TPL-TD-002) after this plan is complete.
-->

# Implementation Plan — {{CHANGE_TITLE}}

**Plan version:** {{VERSION}}
**Source document:** {{SOURCE_DOCUMENT_PATH}} — {{SOURCE_DOCUMENT_TYPE}}
**Source version:** {{SOURCE_VERSION}}
**Kata / Work item:** {{KATA_OR_TICKET}}
**Date:** {{DATE}}
**Status:** Planning artefact — no implementation included

---

## How the Change Propagates

<!--
RULES:
- Describe the propagation path in one concise block.
- The propagation must show how the source document's changes flow
  through the implementation components defined below.
- Use a text diagram or ASCII flow if helpful.
- Do not describe implementation. Describe the engineering dependency order.
-->

{{PROPAGATION_DESCRIPTION}}

```
{{PROPAGATION_DIAGRAM}}
```

Every downstream component depends on {{UPSTREAM_COMPONENT}} as its
upstream input. No component modifies the upstream logic; each extends or
constrains the output contract for exactly one concern.

---

## Component 1 — {{COMPONENT_1_NAME}}

**Source items:** {{SOURCE_ITEMS_ADDRESSED}}

### Responsibility

<!--
State what this component is responsible for in one paragraph.
Name the specific behaviour, rule, or output this component governs.
Do not describe implementation.
-->

{{COMPONENT_1_RESPONSIBILITY}}

### Inputs

<!--
List every input this component receives.
Each input must be a concrete artefact or the output of another component.
-->

- {{INPUT_1}}
- {{INPUT_2}}

### Outputs

<!--
List every output this component produces.
Include any interface signal (flag, token, value) consumed by downstream
components.
-->

- {{OUTPUT_1}}
- {{OUTPUT_2}}

### Interface Contract

<!--
One sentence. State what this component accepts and what it emits.
The interface contract is frozen when this component's task is reviewed
and accepted. Downstream components may not re-evaluate the inputs
that produced this component's outputs.
-->

{{INTERFACE_CONTRACT_ONE_SENTENCE}}

---

## Component 2 — {{COMPONENT_2_NAME}}

**Source items:** {{SOURCE_ITEMS_ADDRESSED}}

### Responsibility

{{COMPONENT_2_RESPONSIBILITY}}

### Inputs

- {{INPUT_1}}
- {{INPUT_2}}

### Outputs

- {{OUTPUT_1}}
- {{OUTPUT_2}}

### Interface Contract

{{INTERFACE_CONTRACT_ONE_SENTENCE}}

---

## Component 3 — {{COMPONENT_3_NAME}}

**Source items:** {{SOURCE_ITEMS_ADDRESSED}}

### Responsibility

{{COMPONENT_3_RESPONSIBILITY}}

### Inputs

- {{INPUT_1}}
- {{INPUT_2}}

### Outputs

- {{OUTPUT_1}}
- {{OUTPUT_2}}

### Interface Contract

{{INTERFACE_CONTRACT_ONE_SENTENCE}}

---

<!-- Add additional components as needed. One component per logical section
     of the source document. Typical range: 3–7 components. -->

---

## Change Propagation Summary

<!--
Summarise how each change in the source document maps to a component.
This table provides traceability from the source document to the plan.
-->

| From (source document) | To (implementation) | Propagation path |
|---|---|---|
| {{SOURCE_ITEM}} | {{IMPLEMENTATION_OUTCOME}} | {{COMPONENT_OR_COMPONENTS}} |
| {{SOURCE_ITEM}} | {{IMPLEMENTATION_OUTCOME}} | {{COMPONENT_OR_COMPONENTS}} |
| {{SOURCE_ITEM}} | {{IMPLEMENTATION_OUTCOME}} | {{COMPONENT_OR_COMPONENTS}} |

<!-- Add rows for every item in the source document. -->

---

*No implementation. Planning artefact only.*
