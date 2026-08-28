import Foundation

struct StressEngine: Sendable {
  func apply(_ scenario: StressScenario, to portfolio: Portfolio) -> StressResult {
    let impacts = portfolio.holdings.map { holding in
      let sectorShock = scenario.sectorShocks[holding.sector, default: 0]
      let combinedMultiplier = (1 + scenario.marketShock) * (1 + sectorShock)
      return HoldingStressImpact(
        holding: holding,
        shockedValue: max(0, holding.marketValue * combinedMultiplier)
      )
    }

    return StressResult(
      scenario: scenario,
      startingValue: portfolio.marketValue,
      stressedValue: impacts.reduce(0) { $0 + $1.shockedValue },
      impacts: impacts
    )
  }
}
