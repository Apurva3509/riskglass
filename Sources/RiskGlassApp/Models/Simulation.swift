import Foundation

struct ProjectionBand: Identifiable, Equatable, Sendable {
  let day: Int
  let downside: Double
  let median: Double
  let upside: Double

  var id: Int { day }
}

struct MonteCarloResult: Equatable, Sendable {
  let bands: [ProjectionBand]
  let expectedEndingValue: Double
  let valueAtRisk: Double
  let lossProbability: Double
}
