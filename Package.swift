// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MMEvents",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(
            name: "MMEvents",
            targets: ["MMEvents"]),
    ],
    dependencies: [
        .package(url: "https://github.com/lambdadigamma/mmcommon-ios", .branch("master")),
    ],
    targets: [
        .target(
            name: "MMEvents",
            dependencies: []),
        .testTarget(
            name: "MMEventsTests",
            dependencies: ["MMEvents"]),
    ]
)
