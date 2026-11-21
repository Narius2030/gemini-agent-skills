# gemini-agent-skills

A collection of reusable **agent skills** for Google Antigravity / Gemini-based coding agents. Each skill is a self-contained Markdown workflow (`SKILL.md`) that tells the agent how to handle a specific kind of engineering request — from quick one-off tasks to gated feature development, debugging, code review, and research.

The skills focus on correctness, data integrity, and safety for software and data-platform work. They share a few rules: understand the system before changing it, work from evidence, make focused changes, and never claim a check passed unless it actually ran.

## Skills

| Skill | Folder | Activation | Purpose |
|---|---|---|---|
| `ad-hoc` | [`ad-hoc/`](ad-hoc/SKILL.md) | Exact `[ad-hoc]` tag | Simple, discrete, on-demand tasks (explain, inspect, small edit, run a diagnostic) with minimal ceremony. |
| `feature-develop` | [`feature-develop/`](feature-develop/SKILL.md) | Exact `[feature-develop]` tag | Gated feature workflow: gather context → write a task plan → **wait for approval** → implement → review against the plan → fix loop → **wait for user acceptance**. |
| `bug-investigation` | [`bug-investigation/`](bug-investigation/SKILL.md) | By request type | Evidence-driven root-cause analysis for bugs, test failures, regressions, and data-pipeline anomalies. |
| `code-review` | [`code-review/`](code-review/SKILL.md) | By request type | Reviews diffs and PRs/MRs for correctness, data integrity, security, operability, and regression risk. |
| `research-decision` | [`research-decision/`](research-decision/SKILL.md) | By request type | Technical research, library/version evaluation, architecture trade-offs, and ADRs. |
| `reverse-engineering` | [`reverse-engineering/`](reverse-engineering/SKILL.md) | By request type | Rebuilds a working picture of an unfamiliar codebase or pipeline: entry points, call graphs, config, data flow. |

## Repository layout

```text
.
├── ad-hoc/SKILL.md
├── bug-investigation/SKILL.md
├── code-review/SKILL.md
├── feature-develop/SKILL.md
├── research-decision/SKILL.md
└── reverse-engineering/SKILL.md
```

Each `SKILL.md` starts with YAML frontmatter that the agent uses to discover the skill and decide when to use it:

```markdown
---
name: <skill-name>
description: <when and why the agent should use this skill>
---

# Skill title
...instructions...
```

## Installation

Skills are discovered from the agent's skills directory. To install them globally, copy or symlink each skill folder into `~/.gemini/config/skills/`:

```bash
# Symlink (edits in this repo take effect immediately)
mkdir -p ~/.gemini/config/skills
for d in */; do
  ln -sfn "$PWD/${d%/}" ~/.gemini/config/skills/"${d%/}"
done
```

To pin a snapshot instead, use `cp -R <skill-folder> ~/.gemini/config/skills/`.

Restart or reload the agent so it picks up the new skills, then confirm that they appear in its list of available skills.

## Usage

### Tag-gated skills

`ad-hoc` and `feature-develop` only run when the request contains the exact tag:

```text
[ad-hoc] Explain why this cron expression fires twice a day: 0 */12 * * *
```

```text
[feature-develop] Add idempotent retry handling to the Kafka consumer in ingest/
```

`feature-develop` saves its task plan to `<project-root>/.task-plans/<feature-slug>.md`. If it can't write there, it falls back to `~/.gemini/config/task-plans/<project-slug>/<feature-slug>.md`. It also assigns a preferred model to each stage (planning/review vs. implementation). These preferences are not guarantees. If a model is unavailable, the agent uses the closest available one and says so, but it never skips an approval gate.

### Request-type skills

The other skills are picked by what you ask for, so you don't need a tag:

- "Why does this test fail intermittently?" → `bug-investigation`
- "Review this diff / MR" → `code-review`
- "Should we use Iceberg or Delta for this table?" → `research-decision`
- "How does data flow through this legacy pipeline?" → `reverse-engineering`

### Recommended routing rule

The skills work best with a global instruction file (for example `AGENTS.md` or `GEMINI.md`) that sets up routing:

```markdown
| Skill | When to use |
|---|---|
| `ad-hoc` | Simple, discrete, on-demand requests |
| `feature-develop` | New features and substantial enhancements |
| `bug-investigation` | Debugging, incident analysis, root-cause investigation |
| `code-review` | Reviewing code changes, PRs, and implementation quality |
| `research-decision` | Technical research, technology evaluation, architecture decisions |
| `reverse-engineering` | Understanding undocumented systems, legacy code, and existing behavior |

- Exact `[ad-hoc]` tag activates the ad-hoc skill.
- Exact `[feature-develop]` tag activates the feature-develop skill.
- For other tasks, select a relevant skill based on the request.
```

## Prerequisites

- An agent runtime that supports `SKILL.md` skills (e.g. Google Antigravity).

## Contributing

1. Make a folder named after the skill, with a `SKILL.md` inside.
2. Add `name` and a specific `description` to the frontmatter. The agent decides when to use the skill based on the description.
3. Keep instructions short and actionable. Say what the skill must never do (destructive actions, fabricated results, skipped gates).
4. Add the skill to the table in this README.
