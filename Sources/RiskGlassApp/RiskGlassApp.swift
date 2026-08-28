import SwiftUI

@main
struct RiskGlassApp: App {
  var body: some Scene {
    WindowGroup {
      ContentUnavailableView(
        "RiskGlass",
        systemImage: "chart.xyaxis.line",
        description: Text("A local-first portfolio laboratory is taking shape.")
      )
      .frame(minWidth: 900, minHeight: 620)
    }
  }
}
