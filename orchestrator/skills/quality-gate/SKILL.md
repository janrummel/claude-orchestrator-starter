---
name: quality-gate
description: Orchestrates automatic and manual output quality checks. Coordinates signal-check, challenge, and external verification based on risk triage. Trigger via /quality-gate, /qg, or automatically for risk outputs (numbers, forecasts, causal claims, consequential recommendations).
autonomy_level: in_the_loop
---

# Quality-Gate — Output Quality Orchestration

You orchestrate output quality checks. You do NOT replace signal-check or challenge — you coordinate them and add external verification + a quality score.

## Architecture

```
Output created
    │
    ▼
[Trigger Check] ──→ Level 0: No check needed → Deliver output
    │
    ▼
[Classifier] ──→ Determines review perspectives + level (1/2/3)
    │
    ├─ Level 1: Quick Check ──→ /signal-check
    │
    ├─ Level 2: Deep Check ──→ /signal-check + External Verification + QS calculation
    │
    └─ Level 3: Full Review ──→ Multi-perspective review + External Verification + /challenge
    │
    ▼
[Synthesis] ──→ Consolidate findings → Calculate QS → Report
```

## Quick Reference

| Command | Level | What happens |
|---------|-------|-------------|
| (automatic) | 0-2 | Trigger check → appropriate level |
| `/qg` or `/quality-gate` | 2 | Deep Check (default for manual invocation) |
| `/qg-full` | 3 | Full Review with everything |
| `/qg-score` | — | Calculate QS only, no review |

## Trigger Check

Scan the output for risk indicators:

| Indicator | Example | Weight |
|-----------|---------|--------|
| Quantitative claims | "Market will grow 40%" | High |
| Forecasts / predictions | "By 2030, there will be..." | High |
| Causal claims | "X causes Y", "leads to" | Medium |
| Recommendations with consequences | "You should switch to..." | Medium |
| Regulatory / legal statements | "This complies with..." | High |
| Domain-specific technical claims | Standards, specifications | Medium |

**Triage logic:**
- 0 indicators → Level 0 (no check)
- 1 low indicator → Level 1
- 2+ indicators or manual `/qg` → Level 2
- `/qg-full` or gate recommendation → Level 3

## Workflow

### Level 1 (Quick Check)
1. Run `/signal-check` on the output
2. Calculate Quality Score (QS)
3. Report findings

### Level 2 (Deep Check)
1. Run `/signal-check` on the output
2. External verification for quantitative claims (web search, known sources)
3. Consistency check against memory/project state
4. Calculate QS
5. Report with verification table

### Level 3 (Full Review)
1. Generate 2-4 review perspectives based on the output's domain
2. Each perspective reviews the output
3. External verification for all checkable claims
4. Run `/challenge` as adversarial stress-test
5. Synthesize all findings
6. Calculate QS

## Quality Score (QS)

The QS combines 5 sub-metrics:

| Metric | Weight | What it measures |
|--------|--------|-----------------|
| Source Coverage | 30% | % of quantitative claims backed by sources |
| Consistency | 25% | Contradictions with prior statements (memory, project state) |
| Confidence Marking | 20% | % of forecasts with explicit uncertainty ranges |
| Causality Transparency | 15% | % of causal claims with evidence or qualification |
| Domain Transparency | 10% | Are knowledge boundaries explicitly stated for specialized topics? |

**When a metric is n/a** (e.g., no numbers in output): redistribute its weight to remaining metrics.

### Thresholds

| QS | Verdict | Meaning |
|----|---------|---------|
| > 80% | Release | Output is reliable |
| 50-80% | Revise | Output has weaknesses, address findings |
| < 50% | Unreliable | Fundamental revision needed |

**Special rule:** QS > 80% + at least one critical finding → Verdict stays "Revise".

## Output Format

```markdown
## Quality-Gate: [Output Topic]

> **Level:** [1/2/3] | **QS:** [Score]% | **Verdict:** [Release/Revise/Unreliable]

### Findings

🔴 **Critical**
- [Finding + correction suggestion]

🟡 **Questionable**
- [Finding + verification recommendation]

🟢 **Note**
- [Improvement potential]

### Verification
| Claim | Status | Source |
|-------|--------|--------|
| [Claim] | ✅ Verified / ⚠️ Unverifiable / ❌ Contradiction | [Source] |

### Quality Score
| Metric | Value |
|--------|-------|
| Source Coverage | X% |
| Consistency | X% |
| Confidence Marking | X% |
| Causality Transparency | X% |
| Domain Transparency | X% |
| **Total QS** | **X%** |

### Recommendation
[What should be revised and how]
```

## Skill Chain Integration

```
/express → create output
  → (automatic) Quality-Gate trigger check
  → if findings: recommend revision

/analyze → create analysis
  → /qg → Deep Check
  → if QS < 80%: implement findings → /qg-score again

/strategy → design strategy
  → /qg-full → Full Review including /challenge
  → create hardened version
```

## Limitations

What the quality-gate cannot do:

1. **Detect its own blind spots:** An LLM checking its own output cannot catch systematic errors from training data. External verification mitigates but doesn't fully solve this.
2. **Simulate domain expertise:** Review perspectives are limited to training knowledge. For highly specialized topics (specific regulations, proprietary standards), the gate is NOT reliable.
3. **Guarantee completeness:** The gate checks what IS there, but cannot reliably identify what's MISSING — especially with domain blindness.
4. **Measure objective quality:** The QS is a heuristic, not ground truth. It improves over time (calibration) but remains an approximation.

## Rules

- **Quality-gate does NOT replace signal-check or challenge** — it orchestrates them
- **Automatic trigger only at Level 1-2** — Level 3 is always manual or gate-recommended
- **No self-review of same context** — the gate checks the OUTPUT, not the process
- **Token awareness** — Level 1 costs ~500 extra tokens, Level 2 ~2000, Level 3 ~5000+
- **QS is a signal, not truth** — it reveals trends, doesn't replace human judgment
