// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "RiskGlass",
  platforms: [.macOS(.v14)],
  products: [
    .executable(name: "RiskGlass", targets: ["RiskGlassApp"])
  ],
  targets: [
    .executableTarget(name: "RiskGlassApp")
  ]
)
