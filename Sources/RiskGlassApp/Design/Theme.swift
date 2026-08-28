import SwiftUI

enum RiskGlassTheme {
  static let canvas = Color(red: 0.035, green: 0.047, blue: 0.075)
  static let elevated = Color.white.opacity(0.065)
  static let border = Color.white.opacity(0.11)
  static let mint = Color(red: 0.31, green: 0.94, blue: 0.72)
  static let violet = Color(red: 0.61, green: 0.49, blue: 1)
  static let mutedText = Color.white.opacity(0.56)
}

extension Sector {
  var color: Color {
    switch self {
    case .consumer: .orange
    case .energy: .yellow
    case .finance: RiskGlassTheme.violet
    case .healthcare: .pink
    case .technology: RiskGlassTheme.mint
    }
  }
}

struct GlassCard: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(RiskGlassTheme.elevated, in: RoundedRectangle(cornerRadius: 22))
      .overlay {
        RoundedRectangle(cornerRadius: 22)
          .stroke(RiskGlassTheme.border, lineWidth: 1)
      }
  }
}

extension View {
  func glassCard() -> some View {
    modifier(GlassCard())
  }
}
