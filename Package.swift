// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MMEvents",
    defaultLocalization: "en",
    platforms: [.iOS(.v14), .macOS(.v11), .watchOS(.v7), .tvOS(.v14)],
    products: [
        .library(
            name: "MMEvents",
            targets: ["MMEvents"]
        ),
    ],
    dependencies: [
        .package(name: "Core", path: "./../Core"),
        .package(name: "MMPages", url: "https://github.com/lambdadigamma/mmpages-ios", from: "0.0.2"),
        .package(name: "ModernNetworking", url: "https://github.com/lambdadigamma/modernnetworking", from: "0.1.1"),
    ],
    targets: [
        .target(
            name: "MMEvents",
            dependencies: [
                "Core",
                "MMPages",
                "ModernNetworking",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "MMEventsTests",
            dependencies: ["MMEvents"]
        ),
    ]
)
