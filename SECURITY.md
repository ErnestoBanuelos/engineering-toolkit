# Security Policy

## Scope

This repository contains engineering knowledge assets.

It does not contain executable software, credentials, or production systems.

---

## Sensitive Information Policy

The following must never be committed to this repository:

- Secrets, credentials, or API keys of any kind.
- Customer-identifiable information.
- Internal architecture details of specific organizations.
- Production endpoints, hostnames, or IP addresses.
- Proprietary business logic belonging to a specific project.
- Context Bundles containing confidential project information.

This policy reinforces ADR-000 and ADR-003 Section 12.

---

## Reporting a Vulnerability

If you discover that a committed asset contains sensitive information:

1. Do not open a public issue.
2. Contact the repository owner directly.
3. Provide the file path, line number, and nature of the sensitive information.
4. Allow up to 72 hours for acknowledgment.

The repository owner will remove the sensitive content from history and publish a correction notice.

---

## Asset Security Review

All Engineering Assets submitted for publication should be reviewed for:

- Absence of confidential information.
- Absence of project-specific data.
- Absence of credentials or environment-specific configuration.

This review is part of the standard governance process defined in ADR-007.
