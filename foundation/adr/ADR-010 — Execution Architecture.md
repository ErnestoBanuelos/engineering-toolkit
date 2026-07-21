# ADR-010 — Execution Architecture

**Status:** Approved

**Date:** 2026-07-21

**Version:** 1.0.0

**Supersedes:** None

**Related ADRs:**

* ADR-000 — Engineering Toolkit Foundation
* ADR-001 — Repository Structure
* ADR-002 — Engineering Asset Model
* ADR-003 — Asset Metadata Model
* ADR-004 — Context Bundle Specification
* ADR-005 — Skill Authoring Standard
* ADR-006 — Asset Relationship Model
* ADR-008 — Bootstrap Architecture
* ADR-009 — Evidence & Verification Model
* ADR-011 — Context Bundle Contract

---

# 1. Context

ADR-002 defines Engineering Assets as reusable, versioned units of engineering knowledge.

ADR-005 defines Skills as the primary executable asset type.

ADR-004 defines Context Bundles as the mechanism for supplying project-specific knowledge to assets at runtime.

However, no ADR has defined how an asset is invoked, how context is bound, how outputs are captured, or what constitutes a valid execution environment.

Without this definition, the contract between the toolkit and its consumers remains conceptual.

This ADR defines the Execution Architecture.

---

# 2. Problem Statement

Without a defined execution model:

* engineers independently invent invocation conventions;
* context binding becomes implicit and fragile;
* output capture is inconsistent;
* verification evidence cannot reference execution provenance;
* Skill composition cannot be mechanically defined;
* bootstrap cannot produce execution-ready repositories.

The Engineering Toolkit requires a minimal, vendor-neutral execution contract.

---

# 3. Decision

The Engineering Toolkit shall define a canonical **Execution Architecture**.

The Execution Architecture describes the contract for invoking Engineering Assets.

It is implementation-independent.

AI agents, CLI tools, scripts, and human-led sessions are all valid implementations of this architecture.

No implementation is considered normative.

---

# 4. Design Principles

## E1 — Capability over Implementation

The execution contract describes what must happen.

It does not prescribe the tool, agent, or platform that executes it.

---

## E2 — Context Binding is Explicit

Context is always bound at the start of execution.

Implicit context is a prohibited pattern.

---

## E3 — Outputs are Declared

Every execution produces declared outputs.

Undeclared outputs are not considered engineering artifacts.

---

## E4 — Provenance is Recorded

Every execution records sufficient information to support audit and replay.

---

## E5 — Human Decisions are Preserved

Execution does not bypass governance.

Points requiring human approval are surfaced explicitly during execution.

---

# 5. Execution Unit

The **Execution Unit** is the fundamental element of the Execution Architecture.

An Execution Unit is:

> **A single invocation of one Engineering Asset with a bound Context and declared inputs, producing declared outputs and a Provenance Record.**

An Execution Unit is atomic from a traceability perspective.

Complex engineering operations are composed from multiple Execution Units.

---

# 6. Execution Contract

Every Execution Unit satisfies the following contract.

## Inputs

An Execution Unit receives:

* **Asset Reference** — identifier and version of the Engineering Asset being executed.
* **Context Bundle** — bound project context, satisfying the requirements declared by the asset.
* **Declared Inputs** — the specific inputs required by the asset as defined in its Inputs section.
* **Execution Parameters** — any optional runtime configuration.

---

## Preconditions

Before execution begins:

* the Asset Reference must resolve to a Published Engineering Asset;
* the Context Bundle must satisfy the asset's context requirements;
* all required Inputs must be present.

Execution must not begin if preconditions are not satisfied.

---

## Execution

The asset's Procedure is followed as defined in the asset itself.

No implementation may alter the procedure defined by the asset.

If an implementation cannot execute a step, execution halts and a human decision is required.

---

## Outputs

Every Execution Unit produces:

* **Declared Outputs** — the artifacts listed in the asset's Outputs section.
* **Provenance Record** — described in Section 7.
* **Human Decision Points** — any decisions surfaced during execution that require human approval before continuation.

---

## Postconditions

After execution completes:

* all declared outputs must be present;
* the Provenance Record must be complete;
* any pending Human Decision Points must be recorded.

---

# 7. Provenance Record

Every Execution Unit produces a **Provenance Record**.

A Provenance Record captures:

| Field               | Description                                                    |
|---------------------|----------------------------------------------------------------|
| `asset_id`          | Identifier of the executed asset                               |
| `asset_version`     | Version of the asset at time of execution                      |
| `context_bundle_id` | Identifier of the Context Bundle used                          |
| `context_version`   | Version of the Context Bundle at time of execution             |
| `executed_at`       | Timestamp of execution                                         |
| `executor`          | Identity of the executor (human, AI agent identifier, or tool) |
| `inputs_summary`    | Summary of inputs provided (not full content)                  |
| `outputs_produced`  | List of output artifact identifiers                            |
| `human_decisions`   | Human decisions made during execution                          |
| `outcome`           | Pass / Fail / Incomplete                                       |

Provenance Records are the basis for Replay Packets as defined in ADR-009.

---

# 8. Skill Composition Execution

When a Skill invokes another Skill (as declared in ADR-005 Section 8), the following rules apply.

**Sequential composition:**

Each Skill executes as an independent Execution Unit.

The output of the preceding Skill is provided as input to the following Skill.

Execution halts if any Execution Unit fails.

---

**Parallel composition:**

Skills execute as independent Execution Units with no ordering dependency.

Outputs are combined after all parallel units complete.

---

**Conditional composition:**

A Skill executes only if its declared precondition evaluates to true.

The precondition must be defined in the Skill's Preconditions section.

Skipped Skill invocations are recorded in the Provenance Record.

---

# 9. Execution Environment

An **Execution Environment** is any context in which Execution Units can be run.

The Engineering Toolkit places no constraint on the nature of the Execution Environment, provided it satisfies this contract:

* it can resolve asset references to published Engineering Assets;
* it can bind a Context Bundle to an execution;
* it can capture declared outputs;
* it can produce a Provenance Record;
* it surfaces human decision points without bypassing them.

Implementations include but are not limited to:

* AI agents (any vendor);
* CLI tools;
* IDE integrations;
* scripts;
* human-led sessions with manual documentation.

No Execution Environment is considered normative.

This preserves vendor neutrality as required by ADR-000 P8.

---

# 10. Governance Integration

Execution is a governed activity.

Provenance Records are engineering evidence as defined in ADR-009.

Automated execution does not transfer governance authority.

Human approval gates defined in an asset's Human Decisions section must be respected by every Execution Environment.

---

# 11. Replay

A Provenance Record combined with the Context Bundle and inputs constitutes a **Replay Packet**.

A Replay Packet enables:

* reproduction of an engineering session;
* audit of decisions made;
* training through example;
* incident investigation.

Replay does not guarantee identical AI output.

It guarantees that the same engineering process can be re-executed under the same conditions.

---

# 12. Anti-Patterns

The following practices violate the Execution Architecture.

## Context-Free Execution

Executing a Skill without a bound Context Bundle.

---

## Undeclared Output

Producing engineering artifacts not listed in the asset's Outputs section.

---

## Missing Provenance

Completing an execution without recording a Provenance Record.

---

## Bypassed Human Decision

Allowing execution to continue past a defined Human Decision point without obtaining human approval.

---

## Implementation-Locked Execution

Designing assets that only execute in one specific AI platform or tool.

---

# 13. Consequences

Positive consequences:

* consistent execution behavior across implementations;
* traceable engineering provenance;
* reproducible engineering sessions;
* governance-aware execution;
* vendor-neutral execution model;
* foundation for automated tooling.

Trade-offs:

* execution overhead for provenance recording;
* authoring discipline to declare inputs and outputs;
* governance gates may slow automated pipelines.

These trade-offs are intentional.

---

# 14. Future Work

Future ADRs may define:

* standard Provenance Record serialization format;
* Replay Packet schema;
* Execution Environment certification criteria;
* execution monitoring and dashboards.

Implementation of specific Execution Environments remains outside this ADR.

---

# 15. Summary

The Execution Architecture defines the missing runtime contract of the Engineering Toolkit.

It specifies how Engineering Assets are invoked, how context is bound, how outputs are captured, and how provenance is recorded — without prescribing any specific tool, AI vendor, or platform.

By separating the execution contract from its implementations, the Engineering Toolkit preserves vendor neutrality while enabling consistent, governed, and reproducible engineering execution across all environments.
