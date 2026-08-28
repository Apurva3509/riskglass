import Testing

@testable import RiskGlassApp

@Suite("Portfolio CSV importer")
struct PortfolioCSVImporterTests {
  private let importer = PortfolioCSVImporter()

  @Test("imports quoted fields and normalizes symbols")
  func importsQuotedFields() throws {
    let content = """
      symbol,name,sector,shares,average_cost,current_price
      aapl,"Apple, Inc.",Technology,12.5,180.25,205.40
      jpm,JPMorgan Chase,finance,8,210,298.24
      """

    let portfolio = try importer.importPortfolio(from: content, name: "Imported")

    #expect(portfolio.name == "Imported")
    #expect(portfolio.holdings.count == 2)
    #expect(portfolio.holdings[0].symbol == "AAPL")
    #expect(portfolio.holdings[0].name == "Apple, Inc.")
    #expect(portfolio.holdings[0].shares == 12.5)
    #expect(portfolio.holdings[1].sector == .finance)
  }

  @Test("reports missing required columns")
  func missingColumn() {
    let content = "symbol,name\nAAPL,Apple"

    #expect(throws: PortfolioImportError.missingColumn("sector")) {
      try importer.importPortfolio(from: content, name: "Broken")
    }
  }

  @Test("reports invalid numeric values with a line number")
  func invalidNumber() {
    let content = """
      symbol,name,sector,shares,average_cost,current_price
      AAPL,Apple,Technology,many,180,205
      """

    #expect(
      throws: PortfolioImportError.invalidValue(
        line: 2,
        column: "shares",
        value: "many"
      )
    ) {
      try importer.importPortfolio(from: content, name: "Broken")
    }
  }

  @Test("reports unsupported sectors")
  func unsupportedSector() {
    let content = """
      symbol,name,sector,shares,average_cost,current_price
      ACME,Acme,Industrials,1,10,12
      """

    #expect(
      throws: PortfolioImportError.unsupportedSector(
        line: 2,
        value: "Industrials"
      )
    ) {
      try importer.importPortfolio(from: content, name: "Broken")
    }
  }
}
