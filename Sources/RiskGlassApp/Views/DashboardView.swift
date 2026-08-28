import Charts
import SwiftUI
import UniformTypeIdentifiers

struct DashboardView: View {
  @State private var portfolio: Portfolio
  @State private var isImporting = false
  @State private var importStatus: String?

  init(portfolio: Portfolio) {
    _portfolio = State(initialValue: portfolio)
  }

  var body: some View {
    ZStack {
      background
      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          header
          metrics
          HStack(alignment: .top, spacing: 18) {
            allocationCard
            HoldingsCard(portfolio: portfolio)
          }
          RiskLabCard(portfolio: portfolio)
          StressTestCard(portfolio: portfolio)
        }
        .padding(32)
      }
    }
    .preferredColorScheme(.dark)
    .fileImporter(
      isPresented: $isImporting,
      allowedContentTypes: [.commaSeparatedText, .plainText],
      allowsMultipleSelection: false,
      onCompletion: importPortfolio
    )
  }

  private var background: some View {
    ZStack {
      RiskGlassTheme.canvas
      RadialGradient(
        colors: [RiskGlassTheme.violet.opacity(0.18), .clear],
        center: .topTrailing,
        startRadius: 20,
        endRadius: 620
      )
      RadialGradient(
        colors: [RiskGlassTheme.mint.opacity(0.08), .clear],
        center: .bottomLeading,
        startRadius: 30,
        endRadius: 520
      )
    }
    .ignoresSafeArea()
  }

  private var header: some View {
    HStack {
      VStack(alignment: .leading, spacing: 6) {
        Label("RISKGLASS", systemImage: "circle.hexagongrid.fill")
          .font(.system(size: 13, weight: .bold, design: .rounded))
          .foregroundStyle(RiskGlassTheme.mint)
        Text(portfolio.name)
          .font(.system(size: 34, weight: .semibold, design: .rounded))
        Text("Local portfolio intelligence · Updated just now")
          .foregroundStyle(RiskGlassTheme.mutedText)
      }
      Spacer()
      VStack(alignment: .trailing, spacing: 7) {
        HStack {
          Button("Import CSV", systemImage: "square.and.arrow.down") {
            isImporting = true
          }
          .buttonStyle(.bordered)
          Button("Run analysis", systemImage: "sparkles") {}
            .buttonStyle(.borderedProminent)
            .tint(RiskGlassTheme.violet)
        }
        if let importStatus {
          Text(importStatus)
            .font(.caption)
            .foregroundStyle(RiskGlassTheme.mutedText)
        }
      }
      .controlSize(.large)
    }
  }

  private func importPortfolio(_ result: Result<[URL], Error>) {
    do {
      guard let url = try result.get().first else { return }
      let canAccess = url.startAccessingSecurityScopedResource()
      defer {
        if canAccess { url.stopAccessingSecurityScopedResource() }
      }
      let content = try String(contentsOf: url, encoding: .utf8)
      portfolio = try PortfolioCSVImporter().importPortfolio(
        from: content,
        name: url.deletingPathExtension().lastPathComponent
      )
      importStatus = "Imported \(portfolio.holdings.count) positions locally"
    } catch {
      importStatus = error.localizedDescription
    }
  }

  private var metrics: some View {
    HStack(spacing: 14) {
      MetricCard(
        label: "Portfolio value",
        value: portfolio.marketValue.formatted(.currency(code: "USD")),
        detail: "Across \(portfolio.holdings.count) positions",
        icon: "chart.pie.fill",
        color: RiskGlassTheme.mint
      )
      MetricCard(
        label: "Unrealized gain",
        value: portfolio.unrealizedGain.formatted(.currency(code: "USD")),
        detail: portfolio.returnPercentage.formatted(.percent.precision(.fractionLength(1))),
        icon: "arrow.up.right",
        color: .green
      )
      MetricCard(
        label: "Diversification",
        value: "\(portfolio.diversificationScore)",
        detail: "100 is broadly distributed",
        icon: "square.grid.3x3.fill",
        color: RiskGlassTheme.violet
      )
    }
  }

  private var allocationCard: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("Allocation")
        .font(.title3.weight(.semibold))
      Chart(portfolio.holdings) { holding in
        SectorMark(
          angle: .value("Value", holding.marketValue),
          innerRadius: .ratio(0.68),
          angularInset: 2
        )
        .cornerRadius(4)
        .foregroundStyle(holding.sector.color)
      }
      .chartLegend(.hidden)
      .frame(height: 220)
      .overlay {
        VStack(spacing: 3) {
          Text(portfolio.marketValue, format: .currency(code: "USD").precision(.fractionLength(0)))
            .font(.title3.weight(.bold))
          Text("invested")
            .font(.caption)
            .foregroundStyle(RiskGlassTheme.mutedText)
        }
      }
      VStack(spacing: 10) {
        ForEach(portfolio.holdings) { holding in
          HStack {
            Circle().fill(holding.sector.color).frame(width: 8, height: 8)
            Text(holding.symbol).font(.caption.weight(.semibold))
            Spacer()
            Text(portfolio.allocation(for: holding), format: .percent.precision(.fractionLength(1)))
              .font(.caption.monospacedDigit())
              .foregroundStyle(RiskGlassTheme.mutedText)
          }
        }
      }
    }
    .padding(22)
    .frame(width: 300)
    .glassCard()
  }
}
