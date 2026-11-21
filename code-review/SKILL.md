---
name: code-review
description: >-
  Structured code and data-pipeline review workflow focused on correctness, data
  integrity, security, operability, and regression risks. Use when reviewing
  diffs, pull/merge requests, or patches.
---

# Workflow: Code Review

Review for defects and risks, not stylistic preference alone.

## Inspect
- Correctness against requirements and contracts.
- Boundary conditions, error handling, concurrency, retries, and partial failure.
- Data integrity, idempotency, ordering, temporal semantics, and schema compatibility.
- Security, authorization, secrets, injection, and unsafe operations.
- Performance/resource use when materially affected.
- Observability, operability, migrations, rollback, and documentation.
- Test quality: whether tests detect realistic regressions, not merely execute lines.
- Scope creep and accidental changes.

## Findings format
For each finding:
- Severity: Critical / High / Medium / Low / Informational.
- Location: file and relevant line/function.
- Scenario and impact.
- Evidence and why current behavior is incorrect/risky.
- Recommended fix or question.

Prioritize actionable findings. Do not invent issues to fill a quota. State what was not reviewed or tested.
