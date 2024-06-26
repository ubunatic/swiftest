// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftest",
    // require macOS 14+
    platforms: [.macOS(.v14)],
    // platforms: [.macOS(.v12), .macOS(.v13), .macOS(.v14)],
    products: [
        .library(name: "Swiftest", targets: ["Swiftest"]),
        // .executable(name: "swiftest", targets: ["Cmd"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.1"),
    ],
    targets: [
        .target(name: "Swiftest"),
        .target(name: "TestSuites", dependencies: ["Swiftest"]),
        .executableTarget(name: "TestMain", dependencies: ["TestSuites"]),
        .executableTarget(
            name: "Cmd",
            dependencies: [
                "Swiftest",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "Info.plist"
                ], .when(platforms: [.macOS]))
            ]
        ),
    ]
)
