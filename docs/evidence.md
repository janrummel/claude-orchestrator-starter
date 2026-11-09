# Evidence: measured findings behind this kit's central claim

The claim is that **a rule that exists is not a rule that works**. This page holds the
figures that back it.

**Where the numbers come from:** the audit logs are private, so the figures below are
reported by the maintainer and cannot be checked from outside. **Provenance rule, non-negotiable:** every number here was measured on a real harness in a
recorded audit, and carries where it came from. No illustrative figures. If a number
cannot be traced, it does not belong on the page, because evidence over belief is the
entire point.

**Depersonalization:** findings are described by mechanism type, never by file name, path
or project. The audited object is referred to as "a maintained personal harness".

---

## A. Mechanisms that existed and did nothing

| Finding | Figure | How it was found | Recorded |
|---|---|---|---|
| A delivery gate ran without effect because its marker was satisfied by every session's own preamble | **8 days silent** while its test suite was green (5 of 5) | mutation: the guarded condition was violated on purpose | private audit log, 2026-07-25 |
| A schema lint had **no invocation path at all**: warn-only, always exit 0, strict mode documented as unused, referenced by no hook, setting or scheduled job | **0 callers**, while producing 304 warnings when run by hand | cross-vendor audit, then verified by grep across all hooks and settings | private audit log, 2026-08-08 |
| A written post-compaction instruction file was read by no mechanism | **0 readers** | same audit | private audit log, 2026-08-08 |
| Skill discovery links pointing into a directory that no longer existed | **4 of 39 dead** (10%) | same audit, verified by resolving every link | private audit log, 2026-08-08 |
| A daily backup whose failure path was silent: exit code plus one line in a log nobody reads, no alert | failure invisible; the **Sunday snapshot branch had never once executed** | mutation: the target host was made unreachable | private audit log, 2026-08-08 |
| A critic logger fired reliably but its parser guessed at prose, so most rounds persisted empty | **20 of 28 rounds** content-free (71%), all five per-dimension score columns empty across every row | audit, verified against the log | private audit log, 2026-08-08 |

**The pattern in one line:** six mechanisms, all present, all configured, all believed to
work. Four of them were found by an audit rather than by their own tests.

## B. What a guard is worth before and after it is broken on purpose

| | Before mutation | After |
|---|---|---|
| A command guard, five independent rounds of deliberate breaking | looked correct | **four of the first five rounds each tore a new hole**, created by the previous round's fix |
| A repo self-check | reported OK | reported OK **even when its own temp-file machinery failed** (fail-open); now fails closed, proven in both states |
| A critic-log parser test suite | 12 of 12 green | **19 of 27** once the parser was disabled on purpose, which is what proved the new tests actually guard anything |

**Usable line for the page:** a suite that has never been red has never been tested.

## C. Two raters, two vendors, one rubric

A harness was scored twice on the same day against the same 18-check rubric, by two
isolated raters on different vendors, with prompts identical except the output filename.

| Measure | Result |
|---|---|
| Exact agreement per check | **10 of 18** |
| Largest disagreement | **±1**, none larger |
| Totals | 42 of 54 versus 46 of 54 |
| Enforced-count reached independently | **3 and 3**, from partly different check sets |
| Checks where both found the same dead surface without seeing each other | 1, aged **~157 days** |

**Why this matters for the kit:** the aggregate score moved by four points between raters
while the enforcement count did not. The gradient is stable, the sum is not. Which is why
this kit reports what is enforced rather than a single score.

## D. The instruction-versus-mechanism gap, measured on this side too

| Finding | Figure | Source |
|---|---|---|
| Two procedures for presenting results existed in the setup and were essentially never used | **2 uses each in total**, against 44 for the procedure that reviews results critically | private usage log, 2026-08-08 |
| A standing rule against a formal hand-over step at session end, plus a reminder at session start | the step was used **76 times in total, none in the last five months** | audit, 2026-08-08 |

The second row is the interesting one: the rule held, **consistent with something checking it**,
and the telemetry shows the behaviour actually stopped.
