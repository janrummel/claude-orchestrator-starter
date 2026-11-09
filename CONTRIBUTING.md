# Contributing

The most useful contribution to this kit is not a feature. It is evidence.

## What is wanted most

**Friction from real use.** If you ran the core on a harness and something needed
manual repair, that one line is worth more than a proposed improvement, because
it tells us which rules survive without enforcement and which do not. Add it to
[`VALIDATION.md`](VALIDATION.md) in the format used there, or open an issue with
the same wording.

**A new adapter, after you have used it.** Not before. An adapter's value is its
"what this harness cannot do" section, and that section is only honest if it comes
from observation. If you have used the core on a harness for real work, an adapter
following the shape of [`adapters/codex/README.md`](adapters/codex/README.md) is
very welcome.

**Disagreement with a rule.** [`docs/rationale.md`](docs/rationale.md) states the
reason behind every hard rule and number. If a reason does not hold in your
context, that is a finding about the rule, not about you.

## House rules

- **The spec is the contract.** [`docs/specs/`](docs/specs/) governs; if a change
  contradicts it, change the spec first and say why, in the same commit.
- **No speculative building.** Each build phase is used for real before the next
  starts. See the phases in the spec.
- **Guards must be proven, not written.** If you add a check, break the thing it
  protects on purpose and show that the check went red. A guard that has never
  failed is a guard nobody has tested.
- **Fail closed.** A check whose own machinery breaks must report failure, never a
  reassuring OK.
- **No personal data, in files or history.** Examples use neutral placeholders.
  `bash scripts/check-depersonalized.sh` must pass; it reads its blocklist from
  outside the repo.
- **Plain prose, no em-dashes.** Explain the why, not only the what.

## Before you open a pull request

```bash
bash scripts/check-kit.sh            # required files exist, links resolve
bash scripts/check-depersonalized.sh # no personal identifiers
```

If you added a required file, add it to the `REQUIRED` array in
`scripts/check-kit.sh` in the same commit.
