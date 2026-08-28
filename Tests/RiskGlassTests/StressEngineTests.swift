import Testing

@testable import RiskGlassApp

@Suite("Stress engine")
struct StressEngineTests {
  private let portfolio = Portfolio(
    name: "Test",
    holdings: [
      Holding(
        symbol: "TECH",
        name: "Technology",
        sector: .technology,
        shares: 10,
        averageCost: 100,
        currentPrice: 100
      ),
      Holding(
        symbol: "BANK",
        name: "Finance",
        sector: .finance,
        shares: 10,
        averageCost: 100,
        currentPrice: 100
      ),
    ]
  )

  @Test("combines market and sector shocks multiplicatively")
  func combinesShocks() {
    let scenario = StressScenario(
      id: "test",
      name: "Test",
      summary: "Test",
      marketShock: -0.10,
      sectorShocks: [.technology: -0.20]
    )

    let result = StressEngine().apply(scenario, to: portfolio)

    #expect(abs(result.impacts[0].shockedValue - 720) < 0.001)
    #expect(abs(result.impacts[1].shockedValue - 900) < 0.001)
    #expect(abs(result.stressedValue - 1_620) < 0.001)
    #expect(abs(result.percentageChange + 0.19) < 0.001)
  }

  @Test("floors values at zero under extreme shocks")
  func floorsValues() {
    let scenario = StressScenario(
      id: "wipeout",
      name: "Wipeout",
      summary: "Test",
      marketShock: -2,
      sectorShocks: [:]
    )

    let result = StressEngine().apply(scenario, to: portfolio)

    #expect(result.stressedValue == 0)
    #expect(result.valueChange == -2_000)
  }
}
