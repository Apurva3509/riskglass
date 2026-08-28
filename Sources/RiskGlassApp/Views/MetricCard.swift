import SwiftUI

struct MetricCard: View {
  let label: String
  let value: String
  let detail: String
  let icon: String
  let color: Color

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      Image(systemName: icon)
        .font(.system(size: 15, weight: .semibold))
        .foregroundStyle(color)
        .frame(width: 36, height: 36)
        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 11))
      VStack(alignment: .leading, spacing: 5) {
        Text(label)
          .font(.caption.weight(.medium))
          .foregroundStyle(RiskGlassTheme.mutedText)
        Text(value)
          .font(.system(size: 22, weight: .semibold, design: .rounded))
          .monospacedDigit()
        Text(detail)
          .font(.caption)
          .foregroundStyle(color.opacity(0.9))
      }
      Spacer(minLength: 0)
    }
    .padding(18)
    .frame(maxWidth: .infinity, alignment: .leading)
    .glassCard()
  }
}
