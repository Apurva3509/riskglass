import SwiftUI

@main
struct RiskGlassApp: App {
  var body: some Scene {
    WindowGroup {
      DashboardView(portfolio: .sample)
        .frame(minWidth: 1_080, minHeight: 720)
    }
    .windowStyle(.hiddenTitleBar)
  }
}
