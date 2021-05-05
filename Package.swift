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
        .package(name: "MMAPI", url: "https://github.com/LambdaDigamma/mmapi-ios", .branch("master")),
        .package(name: "MMUI", url: "https://github.com/LambdaDigamma/mmui-ios", .branch("master")),
        .package(name: "MMCommon", url: "https://github.com/lambdadigamma/mmcommon-ios", .branch("master")),
        .package(name: "MMPages", url: "https://github.com/lambdadigamma/mmpages-ios", .branch("main")),
        .package(name: "ModernNetworking", url: "https://github.com/lambdadigamma/modernnetworking", .branch("main")),
        .package(name: "Gestalt", url: "https://github.com/regexident/Gestalt", from: "2.1.0"),
        .package(url: "https://github.com/DeclarativeHub/Bond.git", .upToNextMajor(from: "7.8.0")),
        .package(url: "https://github.com/DeclarativeHub/ReactiveKit.git", .upToNextMajor(from: "3.18.0")),
//        .package(name: "MMPlaces", url: "https://github.com/lambdadigamma/mmpages-ios", .branch("main")),
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
