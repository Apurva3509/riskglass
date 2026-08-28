import Foundation

enum PortfolioImportError: Error, Equatable, LocalizedError {
  case emptyFile
  case missingColumn(String)
  case invalidValue(line: Int, column: String, value: String)
  case unsupportedSector(line: Int, value: String)

  var errorDescription: String? {
    switch self {
    case .emptyFile:
      "The CSV file is empty."
    case .missingColumn(let column):
      "The required column \"\(column)\" is missing."
    case .invalidValue(let line, let column, let value):
      "Line \(line) has an invalid \(column) value: \"\(value)\"."
    case .unsupportedSector(let line, let value):
      "Line \(line) uses an unsupported sector: \"\(value)\"."
    }
  }
}

struct PortfolioCSVImporter: Sendable {
  private let requiredColumns = [
    "symbol", "name", "sector", "shares", "average_cost", "current_price",
  ]

  func importPortfolio(from content: String, name: String) throws -> Portfolio {
    let rows = parseRows(content)
    guard let header = rows.first, !header.allSatisfy({ $0.isEmpty }) else {
      throw PortfolioImportError.emptyFile
    }

    let normalizedHeader = header.map(normalize)
    var columns: [String: Int] = [:]
    for column in requiredColumns {
      guard let index = normalizedHeader.firstIndex(of: column) else {
        throw PortfolioImportError.missingColumn(column)
      }
      columns[column] = index
    }

    let holdings: [Holding] = try rows.dropFirst().enumerated().compactMap { offset, row in
      guard !row.allSatisfy({ normalize($0).isEmpty }) else { return nil }
      let line = offset + 2
      let symbol = value("symbol", in: row, columns: columns).uppercased()
      let holdingName = value("name", in: row, columns: columns)
      let sectorValue = value("sector", in: row, columns: columns)
      guard
        let sector = Sector.allCases.first(where: {
          normalize($0.rawValue) == normalize(sectorValue)
        })
      else {
        throw PortfolioImportError.unsupportedSector(line: line, value: sectorValue)
      }

      return Holding(
        symbol: symbol,
        name: holdingName,
        sector: sector,
        shares: try number("shares", in: row, columns: columns, line: line),
        averageCost: try number(
          "average_cost",
          in: row,
          columns: columns,
          line: line
        ),
        currentPrice: try number(
          "current_price",
          in: row,
          columns: columns,
          line: line
        )
      )
    }

    return Portfolio(name: name, holdings: holdings)
  }

  private func number(
    _ column: String,
    in row: [String],
    columns: [String: Int],
    line: Int
  ) throws -> Double {
    let rawValue = value(column, in: row, columns: columns)
    guard let number = Double(rawValue), number >= 0 else {
      throw PortfolioImportError.invalidValue(
        line: line,
        column: column,
        value: rawValue
      )
    }
    return number
  }

  private func value(
    _ column: String,
    in row: [String],
    columns: [String: Int]
  ) -> String {
    guard let index = columns[column], row.indices.contains(index) else { return "" }
    return row[index].trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private func normalize(_ value: String) -> String {
    value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
  }

  private func parseRows(_ content: String) -> [[String]] {
    let characters = Array(content)
    var rows: [[String]] = []
    var row: [String] = []
    var field = ""
    var insideQuotes = false
    var index = 0

    while index < characters.count {
      let character = characters[index]
      if character == "\"" {
        if insideQuotes, index + 1 < characters.count, characters[index + 1] == "\"" {
          field.append("\"")
          index += 1
        } else {
          insideQuotes.toggle()
        }
      } else if character == ",", !insideQuotes {
        row.append(field)
        field = ""
      } else if character == "\n", !insideQuotes {
        row.append(field.trimmingCharacters(in: CharacterSet(charactersIn: "\r")))
        rows.append(row)
        row = []
        field = ""
      } else {
        field.append(character)
      }
      index += 1
    }

    if !field.isEmpty || !row.isEmpty {
      row.append(field.trimmingCharacters(in: CharacterSet(charactersIn: "\r")))
      rows.append(row)
    }
    return rows
  }
}
