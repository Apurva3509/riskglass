import SwiftUI

struct HoldingsCard: View {
  let portfolio: Portfolio

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      HStack {
        Text("Holdings")
          .font(.title3.weight(.semibold))
        Spacer()
        Text("UNREALIZED RETURN")
          .font(.caption2.weight(.bold))
          .foregroundStyle(RiskGlassTheme.mutedText)
      }
      ForEach(portfolio.holdings) { holding in
        HStack(spacing: 14) {
          Text(holding.symbol.prefix(1))
            .font(.subheadline.weight(.bold))
            .frame(width: 36, height: 36)
            .background(holding.sector.color.opacity(0.14), in: Circle())
            .foregroundStyle(holding.sector.color)
          VStack(alignment: .leading, spacing: 3) {
            Text(holding.symbol).font(.subheadline.weight(.semibold))
            Text(holding.name)
              .font(.caption)
              .foregroundStyle(RiskGlassTheme.mutedText)
          }
          Spacer()
          VStack(alignment: .trailing, spacing: 3) {
            Text(holding.marketValue, format: .currency(code: "USD"))
              .font(.subheadline.monospacedDigit())
            Text(holding.returnPercentage, format: .percent.precision(.fractionLength(1)))
              .font(.caption.weight(.semibold).monospacedDigit())
              .foregroundStyle(holding.returnPercentage >= 0 ? .green : .red)
          }
        }
        if holding.id != portfolio.holdings.last?.id {
          Divider().overlay(Color.white.opacity(0.06))
        }
      }
    }
    .padding(22)
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .glassCard()
  }
}
