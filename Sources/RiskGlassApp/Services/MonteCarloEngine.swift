import Foundation

struct MonteCarloEngine: Sendable {
  func simulate(
    startingValue: Double,
    annualReturn: Double,
    annualVolatility: Double,
    tradingDays: Int = 126,
    paths: Int = 800,
    seed: UInt64 = 42
  ) -> MonteCarloResult {
    guard startingValue > 0, tradingDays > 0, paths > 0 else {
      return MonteCarloResult(
        bands: [],
        expectedEndingValue: startingValue,
        valueAtRisk: 0,
        lossProbability: 0
      )
    }

    var generator = SeededGenerator(seed: seed)
    let dailyDrift = (annualReturn - 0.5 * annualVolatility * annualVolatility) / 252
    let dailyVolatility = annualVolatility / sqrt(252)
    var valuesByDay = Array(
      repeating: [Double](),
      count: tradingDays + 1
    )
    valuesByDay[0] = Array(repeating: startingValue, count: paths)

    for _ in 0..<paths {
      var value = startingValue
      for day in 1...tradingDays {
        let shock = standardNormal(using: &generator)
        value *= exp(dailyDrift + dailyVolatility * shock)
        valuesByDay[day].append(value)
      }
    }

    let bands = valuesByDay.enumerated().map { day, values in
      let sorted = values.sorted()
      return ProjectionBand(
        day: day,
        downside: percentile(0.10, in: sorted),
        median: percentile(0.50, in: sorted),
        upside: percentile(0.90, in: sorted)
      )
    }
    let endingValues = valuesByDay[tradingDays]
    let expectedEndingValue = endingValues.reduce(0, +) / Double(paths)
    let sortedEndingValues = endingValues.sorted()
    let fifthPercentile = percentile(0.05, in: sortedEndingValues)
    let losses = endingValues.filter { $0 < startingValue }.count

    return MonteCarloResult(
      bands: bands,
      expectedEndingValue: expectedEndingValue,
      valueAtRisk: max(0, startingValue - fifthPercentile),
      lossProbability: Double(losses) / Double(paths)
    )
  }

  private func percentile(_ percentile: Double, in sortedValues: [Double]) -> Double {
    guard let first = sortedValues.first else { return 0 }
    let index = Int((Double(sortedValues.count - 1) * percentile).rounded())
    return sortedValues.indices.contains(index) ? sortedValues[index] : first
  }

  private func standardNormal(using generator: inout SeededGenerator) -> Double {
    let first = max(Double.random(in: 0..<1, using: &generator), .leastNonzeroMagnitude)
    let second = Double.random(in: 0..<1, using: &generator)
    return sqrt(-2 * log(first)) * cos(2 * .pi * second)
  }
}

private struct SeededGenerator: RandomNumberGenerator {
  private var state: UInt64

  init(seed: UInt64) {
    state = seed == 0 ? 0x9E37_79B9_7F4A_7C15 : seed
  }

  mutating func next() -> UInt64 {
    state ^= state >> 12
    state ^= state << 25
    state ^= state >> 27
    return state &* 0x2545_F491_4F6C_DD1D
  }
}
