---
name: ad-hoc
description: Handles explicitly tagged [ad-hoc] requests that are simple, discrete, on-demand tasks. Executes directly with minimal ceremony, asks only essential clarifying questions, and verifies the result.
---

# Ad-hoc Request Skill

## Purpose

Use this skill for small, self-contained, on-demand requests that do not need the full feature-development workflow.

Typical examples:
- Explain a command, configuration, error, or code snippet.
- Inspect a small part of a repository and answer a focused question.
- Make a narrow code, configuration, documentation, or test change.
- Run a specific diagnostic or verification command.
- Perform a one-off refactor or cleanup with clearly bounded scope.
- Find or summarize a specific piece of project information.

This skill prioritizes speed, directness, and minimal changes. Do not turn a discrete request into a larger project.

## 0. Request tag gate

1. Inspect the user's request.
2. Activate this skill only when the exact tag `[ad-hoc]` is present.
3. If the tag is absent, do not apply this workflow; handle the request normally.
4. If the tag is present, proceed with the steps below.

## 1. Classify the request

Determine whether the request is:
- **Informational:** answer or explain; no project changes are needed.
- **Diagnostic:** inspect state, logs, code, or configuration and report findings.
- **Operational:** run a requested, bounded command or action.
- **Modification:** make a small, clearly scoped change to code, configuration, tests, or documentation.

Choose the lightest workflow that can safely complete the request.

Do not create a task plan for ordinary ad-hoc work. Do not invoke the feature-development workflow unless the user explicitly asks for it or the request is actually a substantial feature and should be handled under `[feature-develop]`.

## 2. Gather only necessary context

1. Read relevant project instructions before making repository changes. Check applicable `AGENTS.md`, `GEMINI.md`, README files, and local conventions.
2. Inspect only the files, logs, configuration, or runtime state needed for the specific request.
3. Check git status before editing. Preserve unrelated user changes and do not overwrite work in progress.
4. Use existing project patterns and available tools.
5. Ask a concise follow-up question only when a missing detail materially affects correctness or safety.
6. If the request is sufficiently clear, do not ask for confirmation merely as a formality.

Do not perform broad repository exploration when a targeted inspection is enough.

## 3. Execute the request directly

### Informational requests

- Answer the question directly.
- Explain relevant assumptions and caveats.
- Use examples or commands when they make the answer actionable.
- Do not modify project files unless requested.

### Diagnostic requests

- Run focused, read-only checks where possible.
- Separate observed facts from likely causes or hypotheses.
- Include the relevant evidence, such as command output, file locations, or log excerpts.
- Recommend the smallest useful next step.

### Operational requests

- Execute only the requested operation and necessary supporting steps.
- Prefer read-only or reversible actions.
- Before a destructive, externally visible, costly, or difficult-to-reverse action, explain the impact and obtain explicit user confirmation unless the user has already clearly authorized that exact action.
- Never claim an operation succeeded until its result has been verified.

### Modification requests

- Make the smallest change that satisfies the request.
- Keep the change within the stated scope.
- Follow established naming, formatting, architecture, and testing conventions.
- Avoid unrelated refactoring, dependency upgrades, formatting churn, or speculative improvements.
- Add or update focused tests when appropriate.
- Do not modify secrets, production data, deployment environments, or perform destructive operations without explicit authorization.
- If the work reveals that the request is materially broader or riskier than it first appeared, stop and explain why. Ask whether the user wants to expand the scope or switch to `[feature-develop]`.

## 4. Verify proportionately

Use verification appropriate to the size and nature of the request:

- For explanations, check technical accuracy and make uncertainty explicit.
- For diagnostics, ensure the reported conclusion follows from the observed evidence.
- For code changes, inspect the diff and run focused tests, linting, type checks, or other relevant checks when available.
- For configuration or documentation changes, inspect the final content and validate syntax where practical.
- For operational actions, inspect the resulting state.

Do not run the entire test suite for a trivial change unless it is necessary. Do not claim checks passed if they were not run. Clearly state any checks that could not be performed and why.

## 5. Report the result and finish

Provide a concise response containing only the details useful to the user:

- **Result:** what was answered, diagnosed, executed, or changed.
- **Changes:** files or resources affected, when applicable.
- **Verification:** checks run and their actual outcomes.
- **Caveats:** unresolved issues, assumptions, or actions requiring the user's attention.

For file changes, identify the relevant paths. For diagnostic work, include the key evidence and the recommended next action when useful.

Once the discrete request is completed and verified, end the task. Do not wait for a separate approval or final acceptance for ordinary ad-hoc work.

If the request cannot be completed safely or lacks essential information, explain the blocker and ask only the most useful question.

## Scope and approval rules

- No task-plan Markdown is required by default.
- No implementation approval gate is required for small, clearly requested changes.
- The user's `[ad-hoc]` request itself authorizes the bounded work described in that request; it does not authorize unrelated changes.
- Ask before taking destructive, costly, externally visible, or difficult-to-reverse actions unless explicitly authorized.
- Ask before expanding the scope beyond the original request.
- Do not silently convert an ad-hoc task into a feature project.

## Relationship to other skills

- `[ad-hoc]` is for simple, discrete, on-demand work.
- `[feature-develop]` is for substantial feature work that benefits from context discovery, a written task plan, explicit implementation approval, independent review, and final user acceptance.
- If a request tagged `[ad-hoc]` turns out to require substantial design, multiple coordinated implementation stages, broad cross-module changes, or significant architectural decisions, pause and recommend switching to `[feature-develop]`. Do not silently bypass that workflow's approval gates.

## Non-negotiable rules

- The exact `[ad-hoc]` tag is required to activate this skill.
- Be direct and minimize ceremony.
- Inspect only what is necessary, but enough to avoid unsafe assumptions.
- Preserve unrelated user changes.
- Keep modifications narrow and reversible where possible.
- Verify results proportionately and report truthfully.
- Obtain confirmation for risky actions or material scope expansion.
- Do not create unnecessary plans, approval steps, or review cycles for simple requests.
