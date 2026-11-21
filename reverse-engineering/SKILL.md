---
name: reverse-engineering
description: >-
  Context recovery and reverse-engineering workflow for unfamiliar codebases or
  pipelines. Use when tracing entry points, call graphs, configuration, data
  flow, and runtime behavior of an unknown system.
---

# Workflow: Reverse Engineering and Context Recovery

## Objective
Reconstruct the smallest reliable model of how an unfamiliar system behaves.

## Procedure
1. Define the question: what behavior, failure, data path, or component must be understood?
2. Find entry points: API routes, CLI commands, schedulers, event consumers, jobs, and process startup.
3. Trace call graph and data flow across interfaces, transformations, persistence, and side effects.
4. Inspect configuration resolution, dependency injection, environment variables, feature flags, migrations, and deployment manifests.
5. Read tests and use them as behavioral evidence; check whether they actually cover the question.
6. Use Git history/blame when historical intent or a regression window matters.
7. Compare code-derived behavior with logs, runtime state, metrics, and docs where authorized.
8. Draw a simple sequence/data-flow diagram only when it helps answer the question.
9. Record verified facts separately from inferences and unknowns.
10. Recommend the next highest-value diagnostic instead of pretending the entire architecture is understood.

## Output shape
- Scope/question:
- Relevant entry points:
- Execution/data flow:
- State and side effects:
- Failure/retry semantics:
- Verified facts:
- Unknowns and next checks:
