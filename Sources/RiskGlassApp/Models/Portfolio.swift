import Foundation

struct Portfolio: Sendable {
  let name: String
  let holdings: [Holding]

  var marketValue: Double {
    holdings.reduce(0) { $0 + $1.marketValue }
  }

  var costBasis: Double {
    holdings.reduce(0) { $0 + $1.costBasis }
  }

  var unrealizedGain: Double { marketValue - costBasis }

  var returnPercentage: Double {
    guard costBasis != 0 else { return 0 }
    return unrealizedGain / costBasis
  }

  var diversificationScore: Int {
    guard marketValue > 0 else { return 0 }
    let concentration = holdings.reduce(0.0) { result, holding in
      let weight = holding.marketValue / marketValue
      return result + weight * weight
    }
    return Int(((1 - concentration) * 100).rounded())
  }

  func allocation(for holding: Holding) -> Double {
    guard marketValue > 0 else { return 0 }
    return holding.marketValue / marketValue
  }
}

extension Portfolio {
  static let sample = Portfolio(
    name: "North Star",
    holdings: [
      Holding(
        symbol: "NVDA",
        name: "NVIDIA",
        sector: .technology,
        shares: 34,
        averageCost: 118.40,
        currentPrice: 176.92
      ),
      Holding(
        symbol: "MSFT",
        name: "Microsoft",
        sector: .technology,
        shares: 18,
        averageCost: 412.15,
        currentPrice: 506.31
      ),
      Holding(
        symbol: "JPM",
        name: "JPMorgan Chase",
        sector: .finance,
        shares: 24,
        averageCost: 201.75,
        currentPrice: 298.24
      ),
      Holding(
        symbol: "LLY",
        name: "Eli Lilly",
        sector: .healthcare,
        shares: 8,
        averageCost: 781.20,
        currentPrice: 946.50
      ),
      Holding(
        symbol: "XOM",
        name: "Exxon Mobil",
        sector: .energy,
        shares: 41,
        averageCost: 109.40,
        currentPrice: 117.82
      ),
    ]
  )
}
