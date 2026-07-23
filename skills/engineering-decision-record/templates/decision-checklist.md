# Decision Checklist — Engineering Decision Record

Use this checklist before committing an Architecture Debate record or a Replay Packet
to the repository.

A `PASS` result for each item is required before the artifact is published.
A `FAIL` must be resolved. A `N/A` requires a written justification.

---

## Part 1 — Architecture Debate Checklist

### Pre-debate

| # | Check | Result | Notes |
|---|---|---|---|
| 1.1 | The problem statement names a specific decision, not a general area of exploration. | PASS / FAIL / N/A | |
| 1.2 | The decision scope boundary is stated (what the decision governs; what it does not). | PASS / FAIL / N/A | |
| 1.3 | The failure mode that the decision is trying to prevent or the opportunity it is trying to capture is stated. | PASS / FAIL / N/A | |
| 1.4 | Decision criteria were defined and agreed before any option was evaluated. | PASS / FAIL / N/A | |
| 1.5 | Every criterion is independently observable or measurable. | PASS / FAIL / N/A | |
| 1.6 | Criteria are ranked or weighted so that tradeoffs can be resolved deterministically. | PASS / FAIL / N/A | |

### Debate quality

| # | Check | Result | Notes |
|---|---|---|---|
| 1.7 | Every option has a defender position grounded in specific evidence. | PASS / FAIL / N/A | |
| 1.8 | Every option has an attacker position at the same level of specificity as the defender position. | PASS / FAIL / N/A | |
| 1.9 | The defender position for each option responds to the attacker's challenge. | PASS / FAIL / N/A | |
| 1.10 | No option was evaluated against criteria that were not in the pre-agreed list. | PASS / FAIL / N/A | |

### Decision record

| # | Check | Result | Notes |
|---|---|---|---|
| 1.11 | The chosen option is named. | PASS / FAIL / N/A | |
| 1.12 | The rationale for the chosen option references specific criteria scores. | PASS / FAIL / N/A | |
| 1.13 | Every rejected option has a specific rejection rationale tied to the defined criteria. | PASS / FAIL / N/A | |
| 1.14 | A reversal trigger is defined — a specific observable condition, not a general reassessment prompt. | PASS / FAIL / N/A | |
| 1.15 | A review date or event is defined. | PASS / FAIL / N/A | |
| 1.16 | A named person or role is designated as the decision owner. | PASS / FAIL / N/A | |
| 1.17 | The debate record is committed to the repository before implementation begins. | PASS / FAIL / N/A | |

---

## Part 2 — Replay Packet Checklist

### Evidence standards

| # | Check | Result | Notes |
|---|---|---|---|
| 2.1 | Every claim in the action log is supported by observable evidence. | PASS / FAIL / N/A | |
| 2.2 | All unavailable or unrecoverable evidence is explicitly flagged as a limitation. | PASS / FAIL / N/A | |
| 2.3 | No reconstructed or inferred reasoning is presented as observable fact. | PASS / FAIL / N/A | |
| 2.4 | Where the original prompt is unavailable, that unavailability is stated. | PASS / FAIL / N/A | |

### Failure analysis

| # | Check | Result | Notes |
|---|---|---|---|
| 2.5 | The failure mode is named using specific vocabulary (not "something went wrong"). | PASS / FAIL / N/A | |
| 2.6 | The trigger condition is specific — a named input, prompt structure, or context condition. | PASS / FAIL / N/A | |
| 2.7 | The detection method is named — human review, automated check, or downstream impact. | PASS / FAIL / N/A | |
| 2.8 | The correction applied is specific — a named action, not "it was fixed". | PASS / FAIL / N/A | |
| 2.9 | The mitigation is stated as a specific engineering practice change. | PASS / FAIL / N/A | |

### Lessons learned

| # | Check | Result | Notes |
|---|---|---|---|
| 2.10 | At least one lesson is stated as a practice change ("after this incident, we do X") not a problem description ("the agent did not Y"). | PASS / FAIL / N/A | |
| 2.11 | Each lesson specifies who or what it applies to (individual, team, workflow). | PASS / FAIL / N/A | |

### Publication

| # | Check | Result | Notes |
|---|---|---|---|
| 2.12 | Sensitivity classification is declared. | PASS / FAIL / N/A | |
| 2.13 | Redaction review result is stated explicitly — "no redactions required" or specific redactions listed. | PASS / FAIL / N/A | |
| 2.14 | The packet is committed to the repository and referenced from at least one other engineering artifact (ADR, PR, session log). | PASS / FAIL / N/A | |
| 2.15 | The packet explicitly states whether it is sufficient for triage. | PASS / FAIL / N/A | |

---

## Part 3 — Relationship Checks

These checks apply when the Architecture Debate or Replay Packet is being published
alongside other engineering artifacts.

| # | Check | Result | Notes |
|---|---|---|---|
| 3.1 | If an ADR will be produced from this debate, it is referenced in the debate record's Related Artifacts section. | PASS / FAIL / N/A | |
| 3.2 | If this decision was involved in a subsequent incident, the relevant Replay Packet is cross-referenced. | PASS / FAIL / N/A | |
| 3.3 | If this Replay Packet identifies a specification ambiguity, the specification owner has been notified. | PASS / FAIL / N/A | |
| 3.4 | If lessons from this packet have been elevated to team or organization policy, the policy document is referenced. | PASS / FAIL / N/A | |

---

## Sign-off

| Role | Name | Date | Result |
|---|---|---|---|
| Author | | | All applicable items PASS |
| Decision owner (Debate) | | | All applicable items PASS |
| Reviewer (Replay) | | | All applicable items PASS |
