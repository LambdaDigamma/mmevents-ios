// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MMEvents",
    defaultLocalization: "en",
    platforms: [.iOS(.v14), .macOS(.v11), .watchOS(.v7), .tvOS(.v14)],
    products: [
        .library(
            name: "MMEvents",
            targets: ["MMEvents"]),
    ],
    dependencies: [
        .package(name: "MMCommon", url: "https://github.com/lambdadigamma/mmcommon-ios", .branch("master")),
        .package(name: "ModernNetworking", url: "https://github.com/lambdadigamma/modernnetworking", .branch("main"))
    ],
    targets: [
        .target(
            name: "MMEvents",
            dependencies: ["MMCommon", "ModernNetworking"]),
        .testTarget(
            name: "MMEventsTests",
            dependencies: ["MMEvents"]),
    ]
)
