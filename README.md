# RiskGlass

RiskGlass is a local-first macOS portfolio laboratory for exploring allocation,
downside risk, and market scenarios without uploading financial data.

## Product direction

- Native SwiftUI portfolio dashboard
- Reproducible Monte Carlo risk simulation
- Transparent scenario stress testing
- Local market-regime research and Core ML experimentation
- CSV import with no account or cloud service required

RiskGlass is an educational research tool, not financial advice.

## Development

```bash
swift format --in-place --recursive Sources Tests Package.swift
swift build
swift test
```

## License

[MIT](LICENSE)

