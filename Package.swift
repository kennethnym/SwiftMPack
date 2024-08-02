// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftMPack",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftMPack",
            targets: ["SwiftMPack"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CMPack",
            path: "Sources/mpack-1.1.1",
            sources: [
                "./src/mpack/mpack.c",
            ],
            publicHeadersPath: "./src/mpack"),
        .target(
            name: "SwiftMPack",
            dependencies: ["CMPack"]),
        .testTarget(
            name: "SwiftMPackTests",
            dependencies: ["SwiftMPack"]),
    ])
