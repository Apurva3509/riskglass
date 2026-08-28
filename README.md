# RiskGlass

RiskGlass is a local-first macOS portfolio laboratory for exploring allocation,
downside risk, and market scenarios without uploading financial data.

## Product direction

- Native SwiftUI portfolio dashboard with allocation analytics
- Reproducible Monte Carlo risk simulation with percentile bands and value-at-risk
- Transparent market and sector stress scenarios with holding-level attribution
- Local market-regime research and Core ML experimentation
- Validated CSV import with no account or cloud service required

RiskGlass is an educational research tool, not financial advice.

## Install

Download the latest macOS archive from
[GitHub Releases](https://github.com/Apurva3509/riskglass/releases), unzip it,
and open `RiskGlass.app`. The current preview is ad-hoc signed and requires
macOS 14 or later. If Gatekeeper blocks the first launch, control-click the app
and choose **Open**.

## Current experience

The dashboard ships with a representative portfolio so the app is useful on
first launch. All calculations run locally and the visual system uses only
native SwiftUI and Swift Charts.

Import a portfolio using the format in
[`Examples/sample-portfolio.csv`](Examples/sample-portfolio.csv). Required
columns are `symbol`, `name`, `sector`, `shares`, `average_cost`, and
`current_price`.

## Development

```bash
swift format --in-place --recursive Sources Tests Package.swift
swift build
swift test
./scripts/package-app.sh
```

Release packages are built from version tags. See [CHANGELOG.md](CHANGELOG.md)
for notable changes and [the release guide](docs/RELEASING.md) for signing and
notarization instructions.

Contributions are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md), the
[security policy](SECURITY.md), and the project's
[AI-assistance disclosure](AI_ASSISTANCE.md) before opening a pull request.

## License

[MIT](LICENSE)
