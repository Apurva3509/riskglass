# Contributing to RiskGlass

RiskGlass welcomes focused contributions to portfolio analytics, native macOS
design, local data handling, and reproducible financial research.

Start with an issue that describes the user problem and proposed validation.
For larger changes, agree on the model or interface before implementing the UI.

## Development workflow

```bash
swift format --in-place --recursive Sources Tests Package.swift
swift format lint --recursive Sources Tests Package.swift
swift build
swift test
```

Every behavioral change should include a deterministic test. Financial models
must expose their assumptions, avoid unexplained constants, and distinguish
research output from financial advice.

## Pull requests

- Keep each pull request independently useful and reviewable.
- Describe user impact, assumptions, and failure behavior.
- Do not commit market-data credentials or proprietary datasets.
- Credit actual co-authors using their verified GitHub email only when they
  materially contributed to the commit.
- Disclose substantial AI assistance according to [AI_ASSISTANCE.md](AI_ASSISTANCE.md).

