---
name: research-decision
description: >-
  Evidence-based technical research and architecture decision workflow. Use when
  evaluating libraries, version behavior, architectural trade-offs, or writing
  ADRs.
---

# Workflow: Research and Architecture Decision

## Procedure
1. Frame the decision as a concrete question and define constraints.
2. Establish current versions, environment, workload, compatibility boundaries, and operational capacity.
3. Inspect local code/config/tests before searching externally.
4. Research beyond a fixed source whitelist. Prefer primary/version-specific sources for factual claims, and use community sources to surface hypotheses and edge cases.
5. Check dates, version applicability, source credibility, and whether the cited behavior matches the actual problem.
6. Compare viable options against correctness, compatibility, complexity, operational burden, performance, cost, security, and reversibility.
7. Identify disconfirming evidence and failure scenarios.
8. Validate high-impact claims with a prototype, test, benchmark, or staging experiment where feasible.
9. Recommend one option and explain trade-offs, confidence, and what would change the recommendation.
10. Write an ADR only when the decision is durable and accepted.

## Research notes
- Question and decision drivers:
- Environment/version:
- Local evidence:
- Sources and relevant claims:
- Conflicting evidence:
- Options:
- Recommendation:
- Validation:
- Confidence / open risks:
