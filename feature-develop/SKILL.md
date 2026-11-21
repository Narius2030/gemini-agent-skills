---
name: feature-develop
description: Runs a gated feature-development workflow when a user request is explicitly tagged [feature-develop]. Collects context, writes a feature task plan, waits for approval before coding, implements, reviews against the plan, applies review fixes, and waits for the user's final acceptance.
---

# Feature Development Skill

## Purpose

Use this skill to deliver a feature through a controlled, auditable workflow. Follow the stages below **in order**. Do not skip approval gates, silently change scope, or declare the task complete before the user's final review.

## 0. Request tag gate — Gemini Flash 3.8

1. Inspect the user's request before doing any feature-development work.
2. Activate this workflow only when the request contains the exact tag `[feature-develop]`.
3. If the tag is absent:
   - Do not execute this workflow.
   - Respond normally to the request, or ask the user to add `[feature-develop]` if they intended to invoke this skill.
4. If the tag is present, continue to Stage 1.

**Preferred model:** `gemini-flash3.8`

## 1. Understand the request and collect context — Gemini Neon / Gemini Argon 4 / Claude Opus 5.5

**Preferred model:** `gemini-neon` or `gemini-argon4` or `claude-opus5.5`

Before planning or editing files, establish enough context to implement the requested feature correctly.

1. Read the relevant project guidance first, including applicable `AGENTS.md`, `GEMINI.md`, README files, architecture documents, coding standards, and nearby implementation patterns.
2. Inspect the relevant source files, tests, configuration, dependencies, and git status. Do not overwrite or discard unrelated user changes.
3. Identify:
   - The user-visible behavior and intended outcome.
   - Scope, non-goals, constraints, and assumptions.
   - Relevant modules, interfaces, data models, APIs, and dependencies.
   - Compatibility, security, performance, and migration considerations.
   - Expected error handling and edge cases.
   - Required tests and acceptance criteria.
4. Ask concise, focused follow-up questions when a material requirement is ambiguous or missing. Ask only for information that cannot be safely inferred from the repository or request.
5. Do not invent requirements. Clearly distinguish confirmed facts, assumptions, and open questions.
6. Do not start implementation during this stage.

**Exit condition:** The feature is sufficiently understood to write a concrete, verifiable plan. If essential questions remain unanswered, stay in this stage.

## 2. Create the feature task plan — Gemini Neon / Gemini Argon 4 / Claude Opus 5.5

**Preferred model:** `gemini-neon` or `gemini-argon4` or `claude-opus5.5`

Create one Markdown task-plan file for each feature before making implementation changes.

### Plan file location

Use the following precedence:

1. **Preferred, project-local:** `<project-root>/.task-plans/<feature-slug>.md`
2. **Fallback, global:** `~/.gemini/config/task-plans/<project-slug>/<feature-slug>.md`

Use the project-local location when the repository is writable. Use the global fallback only when the project-local location is unavailable, excluded by project policy, or the user asks for a global plan. Do not put project-specific plans in a global location by default.

Create the parent directory if needed. Never overwrite an existing plan for a different or unfinished feature. If a matching plan already exists, inspect it and update it deliberately, preserving useful history where appropriate.

### Required task-plan sections

The plan must contain:

- **Feature:** concise name and description.
- **Request:** the user's requested outcome, summarized without changing its meaning.
- **Status:** `DRAFT`, `AWAITING_APPROVAL`, `APPROVED`, `IMPLEMENTING`, `IN_REVIEW`, `AWAITING_USER_FINAL_REVIEW`, or `ACCEPTED`.
- **Context:** relevant repository findings and existing behavior.
- **Scope:** included work and explicit non-goals.
- **Assumptions and open questions:** mark unresolved items clearly.
- **Proposed design:** approach, affected components/files, interfaces, data flow, and important trade-offs.
- **Implementation steps:** ordered, actionable steps.
- **Test plan:** unit, integration, regression, static-analysis, and/or manual checks as applicable.
- **Acceptance criteria:** observable, verifiable conditions for completion.
- **Risks and mitigations:** include compatibility, security, data, and operational risks where relevant.
- **Review checklist:** criteria the reviewer will use after implementation.
- **Execution log:** concise record of approvals, implementation progress, review findings, fixes, and test outcomes.

Make the plan specific enough that another model or engineer can implement and review the feature without guessing.

After writing the plan:
1. Summarize the proposed approach, affected areas, risks, tests, and plan-file path to the user.
2. Set status to `AWAITING_APPROVAL`.
3. Ask the user explicitly whether they approve starting implementation.
4. **Stop. Do not edit implementation files, run code generators that modify the project, or make feature changes until explicit approval is received.**

## 3. Approval gate and implementation — Gemini Hydrogen / Claude Sonnet 5.5

**Preferred model:** `gemini-hydrogen` or `claude-sonnet5.5`

Proceed only after the user clearly approves the proposed plan. Approval must refer to starting implementation; silence, an unrelated message, or ambiguous feedback is not approval.

If the user requests changes to the plan:
1. Return to Stage 2.
2. Update the plan and explain the changes.
3. Ask for approval again.
4. Do not implement until the revised plan is approved.

After approval:

1. Record the approval and date/time in the plan's execution log; set status to `APPROVED`, then `IMPLEMENTING`.
2. Implement only the approved scope.
3. Follow existing project conventions and reuse established abstractions.
4. Keep changes focused. Avoid unrelated refactoring, dependency upgrades, formatting churn, or opportunistic cleanup unless the approved plan includes them.
5. Add or update tests alongside the implementation.
6. Do not modify secrets, production data, deployment environments, or perform destructive operations unless specifically authorized.
7. Run the checks that are relevant and available. Record exact commands and outcomes. If a check cannot be run, state why; never claim it passed.
8. If implementation reveals a material change in scope, architecture, risk, or acceptance criteria, stop and ask the user to approve an updated plan before proceeding with that change.
9. Update the task plan as implementation progresses, including deviations and decisions.

When implementation is ready, set status to `IN_REVIEW` and hand off to Stage 4.

## 4. Review implementation against the plan — Gemini Neon / Gemini Argon 4 / Claude Opus 5.5

**Preferred model:** `gemini-neon` or `gemini-argon4` or `claude-opus5.5`

Perform an independent review of the actual diff and resulting behavior against the approved task plan.

Review in this order:

1. **Acceptance criteria:** verify each criterion against the implementation and available evidence.
2. **Correctness:** identify logic errors, missing cases, incorrect assumptions, and regressions.
3. **Plan compliance:** identify missing steps, unapproved scope changes, or design inconsistencies.
4. **Tests:** inspect test quality and coverage; run relevant tests and checks where possible.
5. **Security and data safety:** inspect authorization, validation, injection risks, secrets, sensitive data, and destructive behavior as applicable.
6. **Reliability and operations:** inspect error handling, retries, observability, migrations, rollback implications, and performance as applicable.
7. **Maintainability:** inspect readability, consistency with repository patterns, and unnecessary complexity.

Classify findings as:
- `BLOCKER` — must be fixed before user review.
- `MAJOR` — significant defect or unmet acceptance criterion; must be fixed.
- `MINOR` — limited issue that should be fixed when safely in scope.
- `NOTE` — optional observation or follow-up recommendation.

### Automatic review-fix loop

After the review:

1. If findings require changes, update the task plan's review findings and action items.
2. Automatically fix findings that are within the approved scope and can be corrected safely without changing the agreed behavior or architecture.
3. Add or adjust tests for the fixes.
4. Re-run the relevant checks.
5. Review the new diff again against the full task plan.
6. Repeat this loop until there are no unresolved `BLOCKER` or `MAJOR` findings and all acceptance criteria are met, or until a decision from the user is required.

Do not silently make a change that expands scope, changes a user-facing contract, introduces a material dependency, changes data semantics, or carries significant operational risk. For such a finding, explain the issue and ask the user whether to amend the plan. Wait for approval before making that change.

Record all findings, fixes, test results, and any accepted limitations in the task plan. Do not mark a failed or unrun test as passed.

## 5. Prepare the final review package and wait for the user

When the review-fix loop is complete:

1. Update the plan status to `AWAITING_USER_FINAL_REVIEW`.
2. Ensure the plan includes:
   - Summary of implemented behavior.
   - Files/components changed.
   - Acceptance-criteria checklist with evidence.
   - Review findings and how they were resolved.
   - Tests/checks run and their actual results.
   - Known limitations, skipped checks, and follow-up items.
   - Any deviation from the approved plan.
3. Present the user with a concise final review summary and the task-plan path.
4. Ask the user to perform the final review and explicitly accept the result.

**Do not end the task as completed before the user responds.** Keep the task in `AWAITING_USER_FINAL_REVIEW`.

### User final-review response

- **If accepted:** record the user's acceptance in the plan and set status to `ACCEPTED`. Then report completion.
- **If changes are requested:** clarify only what is necessary, update the plan and execution log, and implement the requested in-scope changes. For material scope changes, obtain approval for the revised plan first. Repeat Stage 4 and Stage 5, then wait for final acceptance again.
- **If rejected:** ask what should change and keep the task open. Do not mark it accepted.

## Model routing summary

| Workflow stage | Preferred model |
|---|---|
| 0. Detect `[feature-develop]` tag | Gemini Flash 3.8 (`gemini-flash3.8`) |
| 1. Gather context and clarify requirements | Gemini Argon 4 (`gemini-argon4`) / Claude Opus 5.5 (`claude-opus5.5`) |
| 2. Create and refine task plan | Gemini Argon 4 (`gemini-argon4`) / Claude Opus 5.5 (`claude-opus5.5`) |
| 3. Implement after explicit approval | Gemini Hydrogen (`gemini-hydrogen`) / Claude Sonnet 5.5 (`claude-sonnet5.5`) |
| 4. Review, fix, and re-review | Gemini Argon 4 (`gemini-argon4`) / Claude Opus 5.5 (`claude-opus5.5`) |
| 5. Present final review and wait for acceptance | Gemini Argon 4 (`gemini-argon4`) / Claude Opus 5.5 (`claude-opus5.5`) |

Model names are routing preferences, not guarantees that a given model is available in every Antigravity installation. If a preferred model is unavailable, use the closest available model with the same role and disclose the substitution. Never skip a workflow gate because a model is unavailable.

## Non-negotiable rules

- The exact `[feature-develop]` tag is required to activate this workflow.
- Context gathering and task planning happen before implementation.
- Explicit user approval is required before implementation begins.
- Review is performed against the approved task plan, not merely against coding style.
- Safe, in-scope review fixes are applied automatically, followed by re-testing and re-review.
- Material scope changes require renewed user approval.
- The user's final review and acceptance are mandatory before the task can be marked `ACCEPTED`.
- Keep the task plan accurate throughout the entire lifecycle.
- Never claim that code, tests, reviews, or file operations succeeded unless they actually did.


## Model Handoff Protocol

IMPORTANT:
Skills cannot directly change the active model in Antigravity.
Model assignments are routing preferences, not executable
model-switching commands.

### Required behavior

At each workflow stage:

1. Check whether the active model matches the preferred model.
2. If it does, continue normally.
3. If it does not:
   - Stop before executing that stage.
   - Tell the user which model should be selected.
   - Explain the next action.
   - Preserve the current workflow state.
   - Wait for the user to switch models and explicitly resume.

### Model assignments

| Stage | Preferred model |
|---|---|
| Request detection | Gemini Flash 3.8 |
| Context discovery | Gemini Neon / Gemini Argon 4 / Claude Opus 5.5 |
| Task planning | Gemini Neon / Gemini Argon 4 / Claude Opus 5.5 |
| Implementation | Gemini Hydrogen / Claude Sonnet 5.5 |
| Independent review | Gemini Neon / Gemini Argon 4 / Claude Opus 5.5 |
| Final acceptance | User |

### Handoff messages

Context discovery:
"Please switch to Gemini Neon or Gemini Argon 4 or Claude Opus 5.5 if I'm not using Orchestror(Neon/Argon).
Resume context discovery when ready."

Implementation:
"Implementation plan approved.
Please switch to Gemini Hydrogen or Claude Sonnet 5.5.
Resume implementation when ready."

Independent review:
"Implementation completed.
Please switch to Gemini Neon or Gemini Argon 4 or Claude Opus 5.5.
Resume independent review when ready."

### Important constraints

- Never claim that the model was switched automatically.
- Never assume the model changed because the user was asked to switch.
- Do not restart completed workflow stages unnecessarily.
- Preserve task-plan state between model handoffs.
- If the preferred model is unavailable, ask the user
  to choose an available alternative.

