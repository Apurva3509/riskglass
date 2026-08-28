import Charts
import SwiftUI

struct StressTestCard: View {
  let portfolio: Portfolio
  @State private var selectedScenarioID = StressScenario.presets[0].id

  private var scenario: StressScenario {
    StressScenario.presets.first { $0.id == selectedScenarioID }
      ?? StressScenario.presets[0]
  }

  private var result: StressResult {
    StressEngine().apply(scenario, to: portfolio)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 5) {
          Label("STRESS STUDIO", systemImage: "bolt.horizontal.circle.fill")
            .font(.caption.weight(.bold))
            .foregroundStyle(.orange)
          Text("Break the portfolio before the market does")
            .font(.title3.weight(.semibold))
          Text(scenario.summary)
            .font(.caption)
            .foregroundStyle(RiskGlassTheme.mutedText)
            .frame(maxWidth: 520, alignment: .leading)
        }
        Spacer()
        impactSummary
      }

      Picker("Scenario", selection: $selectedScenarioID) {
        ForEach(StressScenario.presets) { scenario in
          Text(scenario.name).tag(scenario.id)
        }
      }
      .pickerStyle(.segmented)

      Chart(result.impacts) { impact in
        BarMark(
          x: .value("Holding", impact.holding.symbol),
          y: .value("Value change", impact.valueChange)
        )
        .foregroundStyle(
          .linearGradient(
            colors: [.red.opacity(0.55), .orange],
            startPoint: .bottom,
            endPoint: .top
          )
        )
        .cornerRadius(5)
        .annotation(position: .bottom, alignment: .center) {
          Text(
            impact.percentageChange,
            format: .percent.precision(.fractionLength(0))
          )
          .font(.caption2.weight(.bold).monospacedDigit())
          .foregroundStyle(Color.white.opacity(0.72))
        }
      }
      .chartYAxis {
        AxisMarks(position: .leading) { value in
          AxisGridLine().foregroundStyle(Color.white.opacity(0.06))
          AxisValueLabel {
            if let amount = value.as(Double.self) {
              Text(
                amount,
                format: .currency(code: "USD").precision(.fractionLength(0))
              )
            }
          }
          .foregroundStyle(RiskGlassTheme.mutedText)
        }
      }
      .frame(height: 230)

      HStack {
        Label(
          "Market \(scenario.marketShock.formatted(.percent.precision(.fractionLength(0))))",
          systemImage: "globe.americas.fill"
        )
        Spacer()
        ForEach(
          scenario.sectorShocks.sorted { $0.key.rawValue < $1.key.rawValue },
          id: \.key
        ) { entry in
          Text(
            "\(entry.key.rawValue) \(entry.value.formatted(.percent.precision(.fractionLength(0))))"
          )
        }
      }
      .font(.caption.weight(.medium))
      .foregroundStyle(RiskGlassTheme.mutedText)
    }
    .padding(24)
    .glassCard()
  }

  private var impactSummary: some View {
    VStack(alignment: .trailing, spacing: 3) {
      Text("ESTIMATED IMPACT")
        .font(.caption2.weight(.bold))
        .foregroundStyle(RiskGlassTheme.mutedText)
      Text(result.valueChange, format: .currency(code: "USD"))
        .font(.title3.weight(.bold).monospacedDigit())
        .foregroundStyle(.red)
      Text(result.percentageChange, format: .percent.precision(.fractionLength(1)))
        .font(.caption.weight(.semibold).monospacedDigit())
        .foregroundStyle(.orange)
    }
  }
}
