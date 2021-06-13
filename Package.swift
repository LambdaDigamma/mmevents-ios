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
        .package(name: "MMAPI", url: "https://github.com/LambdaDigamma/mmapi-ios", from: "0.2.0"),
        .package(name: "MMUI", url: "https://github.com/LambdaDigamma/mmui-ios", from: "0.2.1"),
        .package(name: "MMCommon", url: "https://github.com/lambdadigamma/mmcommon-ios", from: "0.0.1"),
        .package(name: "MMPages", url: "https://github.com/lambdadigamma/mmpages-ios", from: "0.0.2"),
        .package(name: "ModernNetworking", url: "https://github.com/lambdadigamma/modernnetworking", from: "0.1.1"),
        .package(name: "Gestalt", url: "https://github.com/regexident/Gestalt", from: "2.1.0"),
        .package(url: "https://github.com/DeclarativeHub/Bond.git", from: "7.8.0"),
        .package(url: "https://github.com/DeclarativeHub/ReactiveKit.git", from: "3.18.0"),
//        .package(name: "MMPlaces", url: "https://github.com/lambdadigamma/mmplaces-ios", .branch("main")),
    ],
    targets: [
        .target(
            name: "MMEvents",
            dependencies: [
                "MMAPI",
                "MMUI",
                "MMCommon",
                "MMPages",
                "ModernNetworking",
                "Gestalt",
                "Bond",
                "ReactiveKit"
            ]),
        .testTarget(
            name: "MMEventsTests",
            dependencies: ["MMEvents"]),
    ]
)
