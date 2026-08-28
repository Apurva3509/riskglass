import Foundation

struct Holding: Identifiable, Hashable, Sendable {
  let id: UUID
  let symbol: String
  let name: String
  let sector: Sector
  let shares: Double
  let averageCost: Double
  let currentPrice: Double

  init(
    id: UUID = UUID(),
    symbol: String,
    name: String,
    sector: Sector,
    shares: Double,
    averageCost: Double,
    currentPrice: Double
  ) {
    self.id = id
    self.symbol = symbol
    self.name = name
    self.sector = sector
    self.shares = shares
    self.averageCost = averageCost
    self.currentPrice = currentPrice
  }

  var marketValue: Double { shares * currentPrice }
  var costBasis: Double { shares * averageCost }
  var unrealizedGain: Double { marketValue - costBasis }
  var returnPercentage: Double {
    guard costBasis != 0 else { return 0 }
    return unrealizedGain / costBasis
  }
}

enum Sector: String, CaseIterable, Sendable {
  case consumer = "Consumer"
  case energy = "Energy"
  case finance = "Finance"
  case healthcare = "Healthcare"
  case technology = "Technology"
}
