import Testing

@testable import RiskGlassApp

@Suite("Monte Carlo engine")
struct MonteCarloEngineTests {
  @Test("produces deterministic projections for a seed")
  func deterministicSimulation() {
    let engine = MonteCarloEngine()

    let first = engine.simulate(
      startingValue: 10_000,
      annualReturn: 0.08,
      annualVolatility: 0.2,
      tradingDays: 30,
      paths: 100,
      seed: 7
    )
    let second = engine.simulate(
      startingValue: 10_000,
      annualReturn: 0.08,
      annualVolatility: 0.2,
      tradingDays: 30,
      paths: 100,
      seed: 7
    )

    #expect(first == second)
    #expect(first.bands.count == 31)
  }

  @Test("keeps percentile bands ordered")
  func orderedBands() {
    let result = MonteCarloEngine().simulate(
      startingValue: 25_000,
      annualReturn: 0.06,
      annualVolatility: 0.3,
      tradingDays: 20,
      paths: 120
    )

    #expect(
      result.bands.allSatisfy { band in
        band.downside <= band.median && band.median <= band.upside
      }
    )
    #expect(result.lossProbability >= 0 && result.lossProbability <= 1)
    #expect(result.valueAtRisk >= 0)
  }

  @Test("returns a deterministic path at zero volatility")
  func zeroVolatility() {
    let result = MonteCarloEngine().simulate(
      startingValue: 5_000,
      annualReturn: 0,
      annualVolatility: 0,
      tradingDays: 10,
      paths: 20
    )

    #expect(result.bands.last?.median == 5_000)
    #expect(result.valueAtRisk == 0)
    #expect(result.lossProbability == 0)
  }
}
