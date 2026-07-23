# Replay Packet — Example

**Scenario:** A backend billing service, `ledger`, has a rate-limiting module. An
AI-assisted engineering session was used to produce a specification for a new
graduated rate-limiting policy. The specification was generated correctly during the
session but was never written to the repository because the prompt did not include an
explicit persistence instruction. The gap was discovered during PR review two days later.

This example demonstrates a complete Replay Packet for this incident.

---

# Replay Packet — Rate Limiter Specification Persistence

**Packet ID:** `REPLAY-007`
**Date:** 2026-06-18
**Sensitivity:** Internal — no credentials, keys, customer data, or proprietary
identifiers present.
**Status:** Complete

---

## Redactions Applied

No redactions applied. No sensitive content was identified in the observable
engineering record.

---

## Task / Prompt

### Engineering Objective

The engineering team was developing a graduated rate-limiting policy for the `ledger`
billing API. The objective was to produce a formal specification for the new policy —
covering the rate tier definitions, the client identification mechanism, the burst
allowance calculation, and the behavior at tier boundaries — before any implementation
work began.

### Prompt Intent

The engineer's intent was for the AI assistant to produce a complete specification
document for the graduated rate-limiting policy and to make it available for review.

The exact prompt wording is not available. The session transcript was not preserved.
The following intent description is based on the engineer's recollection, confirmed
against the content of the specification that was eventually written (see
`specs/ledger/rate-limiting/v1.0.md`, committed 2026-06-18 in the corrective session).

The original prompt described the desired policy behavior in detail but did not specify:
- An output file path
- A target directory
- An instruction to write the specification to disk
- An expected artifact summary at the end of the session

---

## Context Snapshot

### Repository

**Name:** `ledger-service`
**Branch:** `feature/graduated-rate-limiting`
**State at time of incident:** The branch had been created from `main`. No specification
files existed under `specs/ledger/rate-limiting/`. The `src/rate_limiter/` directory
contained the existing flat-rate limiter implementation.

### Relevant Engineering Artifacts

| Artifact | Path | Status at time of incident |
|---|---|---|
| Existing rate limiter implementation | `src/rate_limiter/limiter.py` | Present |
| Brownfield delta (rate limiting change) | `changes/rate-limiting-v2/delta.md` | Present |
| Graduated rate-limiting specification | `specs/ledger/rate-limiting/v1.0.md` | **Absent** — not yet created |
| Implementation plan | `changes/rate-limiting-v2/plan.md` | Present |

### Limitations

The session transcript from the original AI-assisted session was not preserved. The
evidence available is limited to: the repository state before and after the corrective
session, the engineer's recollection of the prompt intent, and the content of the
specification that was written during the corrective session.

No reconstruction of the original session's AI responses has been attempted.

---

## Tool and Agent Metadata

| Field | Value |
|---|---|
| Agent / tool | AI coding assistant (interactive CLI) |
| Model identifier | Unknown — not recorded in the original session |
| Approximate execution date | 2026-06-16 (original session); 2026-06-18 (corrective session) |
| Supervised mode | Yes — proposals required human approval |
| Human-in-the-loop | Yes |

---

## Ordered Action Log

| Step | Action | Evidence | Result |
|---|---|---|---|
| 1 | Engineer provides prompt describing desired graduated rate-limiting policy behavior | Inferred from engineer recollection and corrective session content | Session begins |
| 2 | AI assistant generates full specification for graduated rate-limiting policy as a chat response | Content exists in `specs/ledger/rate-limiting/v1.0.md` (created in corrective session, 2026-06-18) — content matches expected scope | Specification content generated and visible in conversation |
| 3 | AI assistant does not issue a file-write operation | No file creation in `feature/graduated-rate-limiting` branch between 2026-06-16 and 2026-06-18; `specs/ledger/rate-limiting/` directory absent from repository history until corrective commit | Zero new files persisted |
| 4 | Session ends | No commit on 2026-06-16 adding specification files | Specification content exists only in the chat transcript |
| 5 | Engineer opens PR for implementation work; reviewer notes that the specification file referenced in `changes/rate-limiting-v2/plan.md` does not exist in the repository | PR review comment, 2026-06-18: "Can't find `specs/ledger/rate-limiting/v1.0.md` — is this published?" | Gap detected |
| 6 | Engineer recognizes that the specification was generated but not persisted | Engineer recollection, confirmed by repository state | Corrective session initiated |
| 7 | Follow-up prompt issued with explicit output path, directory, and persistence instruction | Corrective commit 2026-06-18 adds `specs/ledger/rate-limiting/v1.0.md` (247 lines) and `specs/ledger/rate-limiting/` directory | Specification file written to disk and committed |
| 8 | PR updated to reference the committed specification | Updated PR description references `specs/ledger/rate-limiting/v1.0.md` | PR reviewable with specification evidence in place |

---

## Output

### What Was Produced

The AI assistant generated the complete graduated rate-limiting specification as an
in-session text response. The generated content included:

- Policy scope and purpose
- Four rate tier definitions (Free, Growth, Business, Enterprise) with per-minute
  and per-day limits
- Client identification mechanism (API key → tier mapping via `clients` table)
- Burst allowance calculation (10% of per-minute limit, maximum 50 requests)
- Tier boundary behavior (immediate enforcement on downgrade, 5-minute grace on upgrade)
- Error response format (HTTP 429 with `Retry-After` and `X-RateLimit-Tier` headers)
- Six acceptance criteria with pass conditions

The content was accurate and complete when generated.

### Persistence Status

The specification existed in the conversation but was not persisted into the repository.

The `specs/ledger/rate-limiting/v1.0.md` file was absent from the repository from
2026-06-16 through 2026-06-17. It was written to disk only after a follow-up prompt
on 2026-06-18 that explicitly specified the target directory, output file path, and a
persistence requirement.

The two-day gap is confirmed by repository commit history.

---

## Triage Note

### Failure Mode

**Classification:** Artifact persistence gap

The AI assistant correctly interpreted the prompt as a generation request and produced
the specification content. It had no instruction to issue a file-write operation. No
tool call to create a file was made during the original session.

This is not a content failure. The generated specification was accurate. The failure
was exclusively in the persistence step.

### Trigger

The original prompt described the desired policy behavior and asked the agent to
"produce a specification." The prompt did not include:
- A target file path (e.g., `specs/ledger/rate-limiting/v1.0.md`)
- A target directory
- An instruction to write the file to disk
- An expected artifact summary at session end

The agent interpreted "produce a specification" as a generation request (produce in
the chat) rather than a persistence request (write to disk). Both interpretations are
plausible from the prompt wording.

### Detection

Human review during PR preparation. The reviewer noted that the specification file
referenced in `changes/rate-limiting-v2/plan.md` was not present in the repository.

### Correction

A follow-up prompt was issued with the following elements explicitly specified:
- Target repository: `ledger-service`
- Branch: `feature/graduated-rate-limiting`
- Output path: `specs/ledger/rate-limiting/v1.0.md`
- Instruction to create the file (not just generate the content)
- Request for a file creation summary at the end of the session

The agent created the file and committed it. The PR was updated to reference the
committed specification.

### Mitigation

All prompts that are expected to result in files being written to the repository must
include:
1. An explicit output path for each file to be created.
2. An explicit instruction to create the file (not just to generate content).
3. A request for a file creation summary at the end of the session as a verification
   gate.

Prompts that describe what to generate without specifying where to persist it are
classified as generation-only requests. File creation requires explicit instruction.

### Packet Sufficient for Triage

Partial. The exact prompt wording from the original session is not available, and the
session transcript was not preserved. The failure mode, trigger, and mitigation are
confirmed from observable evidence (repository history, PR review comment, corrective
session content). Full triage of the original prompt wording is not possible.

---

## Lessons Learned

### Lesson 1 — Persistence requires explicit instruction

**Before this incident:**
Prompts described what to generate (e.g., "produce a specification for X") without
specifying whether the output should exist in the chat or in the repository. Engineers
assumed that "produce" implied "write to disk."

**After this incident:**
All prompts that expect repository files must include:
- An explicit output path for each file
- The phrase "create the file at [path]" or equivalent
- A request for a file creation summary at the end of the session

"Generate" and "create" are distinct instructions. Generation produces chat output.
Creation produces repository files. Prompts must use the correct verb for the intended
action.

**Applies to:** All engineers using AI-assisted tools for file creation in this
repository.

---

### Lesson 2 — Session transcripts should be preserved for high-stakes sessions

**Before this incident:**
No practice existed for preserving AI session transcripts. Sessions were ephemeral.

**After this incident:**
For sessions that produce primary engineering artifacts (specifications, ADRs, design
documents), the session log is committed to the repository alongside the artifact.
The session log records: the prompt intent, the tool and model used, the artifacts
created, and the verification gates run. This provides the minimum context to reconstruct
what happened if an artifact is later found to be missing or incorrect.

**Applies to:** All supervised AI-assisted sessions producing primary engineering
artifacts.

---

### Lesson 3 — Plan documents must reference concrete artifact paths

**Before this incident:**
The implementation plan (`changes/rate-limiting-v2/plan.md`) referenced the specification
by path (`specs/ledger/rate-limiting/v1.0.md`) without verifying that the file existed.
This created a broken reference that was only detected during PR review.

**After this incident:**
Implementation plans must verify that all referenced artifacts exist in the repository
before the plan is committed. A plan that references a file that does not exist is
not a complete plan — it is a plan with an open dependency. Open dependencies must be
explicitly marked as `[TODO: create this artifact]` until resolved.

**Applies to:** All engineers authoring implementation plans and change records.

---

## Related Artefacts

| Artefact | Path | Relationship |
|---|---|---|
| Graduated rate-limiting specification | `specs/ledger/rate-limiting/v1.0.md` | The artifact that was missing; created in the corrective session |
| Rate-limiting brownfield delta | `changes/rate-limiting-v2/delta.md` | Change record that motivated the original session |
| Implementation plan | `changes/rate-limiting-v2/plan.md` | Plan that contained the broken specification reference |
| PR #312 | (repository pull request) | The PR where the gap was detected |

---

## Summary

### Files Created by the Corrective Action

| File | Path |
|---|---|
| `v1.0.md` | `specs/ledger/rate-limiting/v1.0.md` |

### Directories Created by the Corrective Action

| Directory | Path |
|---|---|
| `rate-limiting/` | `specs/ledger/rate-limiting/` |

### Engineering Practices Updated Because of This Incident

1. All repository-modification prompts must include explicit output paths and a
   persistence instruction — generation and persistence are distinct actions.
2. All repository-modification prompts must request a file creation summary at session
   end as a human-verifiable gate.
3. Session logs for primary artifact creation are committed alongside the artifact.
4. Implementation plan references to future artifacts are explicitly marked as open
   dependencies until the artifacts are created.
