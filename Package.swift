// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Requester",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "Requester",
            targets: ["Requester"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Requester",
            dependencies: []),
    ]
)
