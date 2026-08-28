import Foundation

struct StressScenario: Identifiable, Hashable, Sendable {
  let id: String
  let name: String
  let summary: String
  let marketShock: Double
  let sectorShocks: [Sector: Double]
}

struct HoldingStressImpact: Identifiable, Equatable, Sendable {
  let holding: Holding
  let shockedValue: Double

  var id: UUID { holding.id }
  var valueChange: Double { shockedValue - holding.marketValue }
  var percentageChange: Double {
    guard holding.marketValue > 0 else { return 0 }
    return valueChange / holding.marketValue
  }
}

struct StressResult: Equatable, Sendable {
  let scenario: StressScenario
  let startingValue: Double
  let stressedValue: Double
  let impacts: [HoldingStressImpact]

  var valueChange: Double { stressedValue - startingValue }
  var percentageChange: Double {
    guard startingValue > 0 else { return 0 }
    return valueChange / startingValue
  }
}

extension StressScenario {
  static let presets = [
    StressScenario(
      id: "liquidity-crunch",
      name: "Liquidity crunch",
      summary: "Broad deleveraging with pressure concentrated in finance and growth.",
      marketShock: -0.18,
      sectorShocks: [.finance: -0.12, .technology: -0.08]
    ),
    StressScenario(
      id: "rate-shock",
      name: "Rate shock",
      summary: "A sudden repricing of long-duration assets as yields move higher.",
      marketShock: -0.08,
      sectorShocks: [.finance: 0.04, .technology: -0.09, .consumer: -0.06]
    ),
    StressScenario(
      id: "ai-reset",
      name: "AI reset",
      summary: "AI expectations normalize while defensive and real-asset sectors hold up.",
      marketShock: -0.06,
      sectorShocks: [.technology: -0.28, .energy: 0.03, .healthcare: 0.02]
    ),
  ]
}
