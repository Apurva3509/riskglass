# RiskGlass

RiskGlass is a local-first macOS portfolio laboratory for exploring allocation,
downside risk, and market scenarios without uploading financial data.

## Product direction

- Native SwiftUI portfolio dashboard with allocation analytics
- Reproducible Monte Carlo risk simulation
- Transparent scenario stress testing
- Local market-regime research and Core ML experimentation
- CSV import with no account or cloud service required

RiskGlass is an educational research tool, not financial advice.

## Current experience

The dashboard ships with a representative portfolio so the app is useful on
first launch. All calculations run locally and the visual system uses only
native SwiftUI and Swift Charts.

## Development

```bash
swift format --in-place --recursive Sources Tests Package.swift
swift build
swift test
```

## License

[MIT](LICENSE)
