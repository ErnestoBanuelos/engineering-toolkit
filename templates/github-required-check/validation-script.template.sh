#!/usr/bin/env bash
# =============================================================================
# scripts/ci/{{GATE_SCRIPT_NAME}}.sh
#
# Purpose:
#   {{GATE_PURPOSE}}
#
# Protected assets:
#   - {{PROTECTED_ASSET_1}}
#   - {{PROTECTED_ASSET_N}}
#
# This script is the single source of logic for the {{GATE_NAME}} CI gate.
# The CI/CD trigger file calls this script directly; no logic lives in the
# trigger file.
#
# Exit codes:
#   0  — all checks passed; protected assets are intact
#   1  — one or more checks failed; details printed to stdout
#
# Usage:
#   bash scripts/ci/{{GATE_SCRIPT_NAME}}.sh          # from repository root
#   bash scripts/ci/{{GATE_SCRIPT_NAME}}.sh --help   # print this header
#
# Requirements:
#   bash 4+, awk, grep, head (standard on Linux/macOS)
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration — replace these values for your repository
# ---------------------------------------------------------------------------
# ASSET_FILE_1: path to the first protected asset (relative to repo root)
ASSET_FILE_1="{{PROTECTED_ASSET_1}}"

# ASSET_FILE_2: path to the second protected asset (optional; remove if unused)
ASSET_FILE_2="{{PROTECTED_ASSET_2}}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
FAILURES=0

fail() {
  echo "FAIL: $1"
  FAILURES=$(( FAILURES + 1 ))
}

pass() {
  echo "PASS: $1"
}

# ---------------------------------------------------------------------------
# Handle --help
# ---------------------------------------------------------------------------
if [[ "${1:-}" == "--help" ]]; then
  awk '/^#!/{next} /^#/{print} /^[^#]/{exit}' "$0"
  exit 0
fi

echo "=== {{GATE_DISPLAY_NAME}} ==="
echo "Asset 1: $ASSET_FILE_1"
echo "Asset 2: $ASSET_FILE_2"
echo ""

# ---------------------------------------------------------------------------
# CHECK 1 — {{CONDITION_1_NAME}}
#
# Rule: {{CONDITION_1_RULE}}
# ---------------------------------------------------------------------------
if [[ -f "$ASSET_FILE_1" ]]; then
  pass "{{CONDITION_1_NAME}}: $ASSET_FILE_1 exists"
else
  fail "{{CONDITION_1_NAME}}: $ASSET_FILE_1 not found"
fi

# ---------------------------------------------------------------------------
# CHECK 2 — {{CONDITION_2_NAME}}
#
# Rule: {{CONDITION_2_RULE}}
# ---------------------------------------------------------------------------
if [[ -f "$ASSET_FILE_2" ]]; then
  pass "{{CONDITION_2_NAME}}: $ASSET_FILE_2 exists"
else
  fail "{{CONDITION_2_NAME}}: $ASSET_FILE_2 not found"
fi

# ---------------------------------------------------------------------------
# Dependency guard — stop early if required files are absent.
# Subsequent checks would produce confusing errors on missing files.
# ---------------------------------------------------------------------------
if (( FAILURES > 0 )); then
  echo ""
  echo "=== Result: FAILED ($FAILURES check(s) failed) ==="
  exit 1
fi

# ---------------------------------------------------------------------------
# CHECK 3 — {{CONDITION_3_NAME}}
#
# Rule: {{CONDITION_3_RULE}}
#
# Pattern: Check that ASSET_FILE_1 starts with a YAML frontmatter block.
# Replace this block with your actual structural check.
# ---------------------------------------------------------------------------
first_line=$(head -1 "$ASSET_FILE_1")
if [[ "$first_line" == "---" ]]; then
  pass "{{CONDITION_3_NAME}}: $ASSET_FILE_1 starts with YAML frontmatter"
else
  fail "{{CONDITION_3_NAME}}: $ASSET_FILE_1 does not start with frontmatter (got: '$first_line')"
fi

# Locate the closing frontmatter delimiter (second occurrence of "---")
closing_line=$(awk '/^---/{count++; if(count==2){print NR; exit}}' "$ASSET_FILE_1")
if [[ -n "$closing_line" ]]; then
  pass "{{CONDITION_3_NAME}}: frontmatter closing delimiter found at line $closing_line"
else
  fail "{{CONDITION_3_NAME}}: frontmatter closing delimiter not found — block is unclosed"
fi

# Extract frontmatter for field checks (reused by checks 4, 5, ...)
if [[ -n "$closing_line" ]]; then
  frontmatter=$(awk "NR>1 && NR<${closing_line}" "$ASSET_FILE_1")
else
  frontmatter=""
fi

# ---------------------------------------------------------------------------
# CHECK 4 — {{CONDITION_4_NAME}}
#
# Rule: {{CONDITION_4_RULE}}
#
# Pattern: Assert that a required YAML key is present in the frontmatter.
# Replace the key name with your actual required field.
# ---------------------------------------------------------------------------
if echo "$frontmatter" | grep -qE '^{{REQUIRED_FIELD_1}}:'; then
  pass "{{CONDITION_4_NAME}}: frontmatter contains '{{REQUIRED_FIELD_1}}' field"
else
  fail "{{CONDITION_4_NAME}}: frontmatter missing required field '{{REQUIRED_FIELD_1}}'"
fi

# ---------------------------------------------------------------------------
# CHECK 5 — {{CONDITION_5_NAME}}
#
# Rule: {{CONDITION_5_RULE}}
#
# Pattern: Assert that the document body (after frontmatter) is not empty.
# ---------------------------------------------------------------------------
if [[ -n "$closing_line" ]]; then
  body=$(awk "NR>${closing_line}" "$ASSET_FILE_1")
  if echo "$body" | grep -qE '\S'; then
    pass "{{CONDITION_5_NAME}}: $ASSET_FILE_1 body is not empty"
  else
    fail "{{CONDITION_5_NAME}}: $ASSET_FILE_1 body is empty after frontmatter"
  fi
else
  fail "{{CONDITION_5_NAME}}: body check skipped — frontmatter is malformed"
fi

# ---------------------------------------------------------------------------
# CHECK 6 — {{CONDITION_6_NAME}}
#
# Rule: {{CONDITION_6_RULE}}
#
# Pattern: Assert that a required section heading exists in a document.
# Replace the heading string with your actual required heading.
# ---------------------------------------------------------------------------
if grep -qF "{{SECTION_HEADING}}" "$ASSET_FILE_2"; then
  pass "{{CONDITION_6_NAME}}: $ASSET_FILE_2 contains required section '{{SECTION_HEADING}}'"
else
  fail "{{CONDITION_6_NAME}}: $ASSET_FILE_2 is missing required section '{{SECTION_HEADING}}'"
fi

# ---------------------------------------------------------------------------
# Add further checks following the same pattern:
#
#   # CHECK N — {{CONDITION_N_NAME}}
#   # Rule: {{CONDITION_N_RULE}}
#   if <assertion>; then
#     pass "{{CONDITION_N_NAME}}: <description>"
#   else
#     fail "{{CONDITION_N_NAME}}: <description> — got: '<actual value>'"
#   fi
#
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Final result
# ---------------------------------------------------------------------------
echo ""
if (( FAILURES == 0 )); then
  echo "=== Result: PASSED (all checks passed) ==="
  exit 0
else
  echo "=== Result: FAILED ($FAILURES check(s) failed) ==="
  exit 1
fi
