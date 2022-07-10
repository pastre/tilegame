// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TileGameLib",
    products: [
        .library(
            name: "TGCore",
            targets: ["TGCore"]
        ),
        .library(
            name: "TGKit",
            targets: ["TGKit"]
        ),
    ],
    targets: [
        .target(
            name: "TGCore",
            dependencies: [],
            path: "Sources/TGCore"
        ),
        .testTarget(
            name: "TGCoreTests",
            dependencies: ["TGCore"],
            path: "Tests/TGCoreTests"
        ),
        
        .target(
            name: "TGKit",
            dependencies: ["TGCore"],
            path: "Sources/TGKit"
        ),
        .testTarget(
            name: "TGKitTests",
            dependencies: ["TGKit"],
            path: "Tests/TGKitTests"
        ),
    ]
)
