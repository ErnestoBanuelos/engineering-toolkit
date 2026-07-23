# Redaction Review Checklist

<!--
USAGE
  Complete this checklist before publishing any Pull Request provenance document,
  PR description, or engineering artefact to a shared or public repository.
  Every category must receive an explicit result.
  Delete HTML comments before publishing.
-->

## Why redaction review is required

A Pull Request description is a permanent, searchable, and often public record.

Most version control platforms do not support editing or removing content from published
PR descriptions without trace. A secret committed or a customer name published in a PR
description is effectively permanent — it will appear in search results, audit logs, and
repository clones.

The redaction checklist takes approximately two minutes to complete. It is required
before every publication because:

1. **Provenance documents aggregate information.** A provenance document collects session
   logs, tool outputs, file paths, and engineering decisions into one place. Individually
   harmless details may become sensitive when aggregated.

2. **AI-assisted engineering produces verbose output.** AI assistants often reproduce
   the content of their context window verbatim. If the context included credentials,
   customer data, or internal configuration, that material may appear in generated text.

3. **Engineering artefacts travel.** PR descriptions are copied into changelogs, release
   notes, incident reports, and onboarding documentation. A sensitive item published in
   a PR description propagates to every downstream consumer.

---

## Checklist

### Category 1 — Secrets and Credentials

Review all content for the following:

- [ ] API keys or tokens (look for patterns like `sk-`, `Bearer `, `ghp_`, key strings
      that appear to be random alphanumeric sequences of 20+ characters)
- [ ] Database connection strings containing usernames or passwords
- [ ] Private keys or certificates (PEM headers, `-----BEGIN`, base64 blocks)
- [ ] OAuth client secrets or refresh tokens
- [ ] SSH keys or passphrases
- [ ] Signing keys or HMAC secrets
- [ ] Service account credentials
- [ ] Cloud provider access keys (AWS, GCP, Azure, etc.)

**Result:** `[ ] PASS — No secrets or credentials found` / `[ ] FINDING — See notes below`

---

### Category 2 — Customer Data

Review all content for the following:

- [ ] Customer names, company names, or organisation names (real production entities,
      not fictional examples)
- [ ] Customer identifiers, account numbers, or subscription IDs
- [ ] Customer infrastructure details (domain names, IP ranges, cluster names)
- [ ] Data derived from customer usage, behaviour, or transactions
- [ ] Customer-specific configuration values

**Result:** `[ ] PASS — No customer data found` / `[ ] FINDING — See notes below`

---

### Category 3 — Personal Information (PII)

Review all content for the following:

- [ ] Personal email addresses (non-corporate, non-example)
- [ ] Personal names associated with real individuals (engineer, user, operator)
      beyond standard git commit attribution
- [ ] Phone numbers
- [ ] Physical or postal addresses
- [ ] Government or national identification numbers
- [ ] Financial account numbers or payment card data
- [ ] Health or biometric data

**Result:** `[ ] PASS — No PII found` / `[ ] FINDING — See notes below`

---

### Category 4 — Internal Infrastructure

Review all content for the following:

- [ ] Internal DNS names or hostnames not intended for public disclosure
- [ ] Internal IP address ranges or VPC/subnet configurations
- [ ] Internal service endpoints, gRPC addresses, or GraphQL URLs
- [ ] Internal Kubernetes cluster names, namespaces, or context names
- [ ] Internal container registry paths or image references with private hostnames
- [ ] Internal CI/CD pipeline names, runner labels, or agent configurations
- [ ] Internal Terraform state backend paths or workspace names

**Result:** `[ ] PASS — No internal infrastructure details found` / `[ ] FINDING — See notes below`

---

### Category 5 — Confidential and Proprietary Information

Review all content for the following:

- [ ] Unreleased product names, features, or roadmap items
- [ ] Pricing structures, contract terms, or financial arrangements not publicly disclosed
- [ ] Intellectual property, patents, or trade secrets
- [ ] Internal project codenames, initiative names, or programme names
- [ ] Vendor relationships, supplier names, or procurement details not publicly known
- [ ] Internal cost figures, budget allocations, or revenue data
- [ ] Security vulnerability details for systems not yet patched

**Result:** `[ ] PASS — No confidential information found` / `[ ] FINDING — See notes below`

---

### Category 6 — Employee Information

Review all content for the following:

- [ ] Employee names appearing in roles or decision records (beyond standard commit
      authorship) where the individual has not consented to public attribution
- [ ] Employee job titles, team names, or reporting relationships
- [ ] Employee contact details (email, Slack handle, phone)
- [ ] Performance-related references to named individuals
- [ ] Organizational chart information or headcount details

**Result:** `[ ] PASS — No employee information found` / `[ ] FINDING — See notes below`

---

### Category 7 — Synthetic vs. Real Data Verification

If the artefact includes data used for testing or examples, verify:

- [ ] All service names, user identifiers, and domain names used in examples are
      explicitly fictional (e.g., `example.com`, `fictional-service`, synthetic IDs)
- [ ] No production database record identifiers appear in test data or session logs
- [ ] No real usernames, real email addresses, or real API responses appear in
      fixtures or examples
- [ ] Data that appears to be real but is claimed to be synthetic is explicitly labelled
      as fictional in the document

**Result:** `[ ] PASS — All data confirmed synthetic or clearly labelled` / `[ ] FINDING — See notes below`

---

## Findings (complete if any category returned FINDING)

<!--
  For each finding:
  - State the category.
  - State the specific item found.
  - State the action taken (removed, redacted, replaced with synthetic equivalent).
  - Confirm the action has been applied before publication.
-->

| # | Category | Item found | Action taken | Confirmed |
|---|---|---|---|---|
| 1 | {{CATEGORY}} | {{ITEM}} | {{ACTION}} | [ ] |

---

## Review Outcome

<!--
  Choose exactly one. Delete the other.
-->

**PASS**

All seven categories reviewed. No sensitive material identified. The document is cleared
for publication.

---

**PASS WITH REDACTIONS**

All seven categories reviewed. The following items were found and removed:

{{REDACTION_SUMMARY}}

The document is cleared for publication after the redactions listed above have been
applied and confirmed.

---

**BLOCKED**

One or more findings could not be resolved by redaction. The document must not be
published until the finding is addressed.

Finding requiring resolution: {{BLOCKING_FINDING}}

---

## Reviewer

**Reviewed by:** {{REVIEWER_NAME_OR_ROLE}}

**Date:** {{REVIEW_DATE}}
