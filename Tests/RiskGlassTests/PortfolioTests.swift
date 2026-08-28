import Testing

@testable import RiskGlassApp

@Suite("Portfolio analytics")
struct PortfolioTests {
  @Test("aggregates market value and gain")
  func aggregatesValue() {
    let portfolio = Portfolio(
      name: "Test",
      holdings: [
        Holding(
          symbol: "ONE",
          name: "One",
          sector: .technology,
          shares: 10,
          averageCost: 8,
          currentPrice: 10
        ),
        Holding(
          symbol: "TWO",
          name: "Two",
          sector: .finance,
          shares: 5,
          averageCost: 15,
          currentPrice: 20
        ),
      ]
    )

    #expect(portfolio.marketValue == 200)
    #expect(portfolio.costBasis == 155)
    #expect(portfolio.unrealizedGain == 45)
    #expect(portfolio.returnPercentage == 45.0 / 155.0)
  }

  @Test("calculates concentration-aware diversification")
  func diversificationScore() {
    let equalPortfolio = Portfolio(
      name: "Balanced",
      holdings: [
        Holding(
          symbol: "ONE",
          name: "One",
          sector: .technology,
          shares: 1,
          averageCost: 100,
          currentPrice: 100
        ),
        Holding(
          symbol: "TWO",
          name: "Two",
          sector: .finance,
          shares: 1,
          averageCost: 100,
          currentPrice: 100
        ),
      ]
    )

    #expect(equalPortfolio.diversificationScore == 50)
    #expect(equalPortfolio.allocation(for: equalPortfolio.holdings[0]) == 0.5)
  }
}
