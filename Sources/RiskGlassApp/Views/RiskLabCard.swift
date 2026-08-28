import Charts
import SwiftUI

struct RiskLabCard: View {
  let portfolio: Portfolio
  let result: MonteCarloResult

  init(portfolio: Portfolio) {
    self.portfolio = portfolio
    result = MonteCarloEngine().simulate(
      startingValue: portfolio.marketValue,
      annualReturn: 0.08,
      annualVolatility: 0.22
    )
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 5) {
          Label("MONTE CARLO LAB", systemImage: "waveform.path.ecg")
            .font(.caption.weight(.bold))
            .foregroundStyle(RiskGlassTheme.mint)
          Text("Six-month probability field")
            .font(.title3.weight(.semibold))
          Text("800 seeded paths · 8% return · 22% volatility")
            .font(.caption)
            .foregroundStyle(RiskGlassTheme.mutedText)
        }
        Spacer()
        probabilityBadge
      }

      Chart(result.bands) { band in
        AreaMark(
          x: .value("Trading day", band.day),
          yStart: .value("Downside", band.downside),
          yEnd: .value("Upside", band.upside)
        )
        .foregroundStyle(
          .linearGradient(
            colors: [
              RiskGlassTheme.violet.opacity(0.05),
              RiskGlassTheme.violet.opacity(0.3),
            ],
            startPoint: .bottom,
            endPoint: .top
          )
        )
        LineMark(
          x: .value("Trading day", band.day),
          y: .value("Median", band.median)
        )
        .foregroundStyle(RiskGlassTheme.mint)
        .lineStyle(StrokeStyle(lineWidth: 2.5))
      }
      .chartYAxis {
        AxisMarks(position: .leading) { value in
          AxisGridLine().foregroundStyle(Color.white.opacity(0.06))
          AxisValueLabel {
            if let amount = value.as(Double.self) {
              Text(amount, format: .currency(code: "USD").precision(.fractionLength(0)))
            }
          }
          .foregroundStyle(RiskGlassTheme.mutedText)
        }
      }
      .chartXAxis {
        AxisMarks(values: [0, 21, 63, 126]) { value in
          AxisGridLine().foregroundStyle(Color.white.opacity(0.05))
          AxisValueLabel {
            if let day = value.as(Int.self) {
              Text(day == 0 ? "Now" : "Day \(day)")
            }
          }
          .foregroundStyle(RiskGlassTheme.mutedText)
        }
      }
      .frame(height: 270)

      HStack(spacing: 28) {
        summary(
          label: "Expected value",
          value: result.expectedEndingValue.formatted(.currency(code: "USD")),
          color: RiskGlassTheme.mint
        )
        summary(
          label: "95% value at risk",
          value: result.valueAtRisk.formatted(.currency(code: "USD")),
          color: .orange
        )
        summary(
          label: "Downside paths",
          value: result.lossProbability.formatted(.percent.precision(.fractionLength(1))),
          color: RiskGlassTheme.violet
        )
      }
    }
    .padding(24)
    .glassCard()
  }

  private var probabilityBadge: some View {
    VStack(alignment: .trailing, spacing: 3) {
      Text("P10–P90 RANGE")
        .font(.caption2.weight(.bold))
        .foregroundStyle(RiskGlassTheme.mutedText)
      if let finalBand = result.bands.last {
        Text(
          "\(finalBand.downside.formatted(.currency(code: "USD").precision(.fractionLength(0)))) – \(finalBand.upside.formatted(.currency(code: "USD").precision(.fractionLength(0))))"
        )
        .font(.subheadline.weight(.semibold).monospacedDigit())
      }
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 10)
    .background(Color.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 12))
  }

  private func summary(label: String, value: String, color: Color) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(label.uppercased())
        .font(.caption2.weight(.bold))
        .foregroundStyle(RiskGlassTheme.mutedText)
      Text(value)
        .font(.headline.monospacedDigit())
        .foregroundStyle(color)
    }
  }
}
