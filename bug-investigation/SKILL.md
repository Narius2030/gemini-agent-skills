---
name: bug-investigation
description: >-
  Structured root-cause investigation and evidence-driven debugging workflow.
  Use when diagnosing bugs, test failures, regressions, or data pipeline
  anomalies before implementing a fix.
---

# Workflow: Bug Investigation and Root-Cause Analysis

## Objective
Explain the observed failure with evidence and fix the cause rather than only suppressing the symptom.

## Procedure
1. Capture the exact symptom, timestamp/timezone, versions, configuration, scope, and impact. Redact secrets and sensitive data.
2. Reproduce the failure if feasible; otherwise define a reliable failure signature and evidence gaps.
3. Trace the relevant execution/data path from symptom toward its source.
4. Create competing hypotheses when more than one cause is plausible. For each, write expected evidence and a discriminating test.
5. Prefer read-only, low-risk diagnostics first. Change one variable at a time where practical.
6. Consult version-specific docs, source, release notes, and issue trackers when compatibility or known defects may be involved.
7. Establish root cause only when evidence supports it; otherwise state the leading hypothesis and confidence.
8. Design the smallest safe fix. Consider rollback, retries, partial failure, and adjacent behavior.
9. Add a regression test or reproducible verification where feasible.
10. Verify fix and nearby failure paths. Report what remains unverified.

## Evidence ledger
- Observation:
- Verified facts:
- Hypotheses:
- Tests/diagnostics:
- Results:
- Root cause or leading explanation:
- Counterevidence / unknowns:
- Fix and verification:

## Anti-patterns
- Randomly changing versions/configuration without a hypothesis.
- Deleting offsets/checkpoints or state before understanding consequences.
- Treating “the error disappeared” as proof that data correctness is restored.
- Reporting a hypothesis as a confirmed root cause.
