// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameApp",
    products: [
        .executable(name: "GameApp", targets: ["GameApp"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../Controller"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "GameApp",
            dependencies: ["ControllerLibrary"]),
        .testTarget(
            name: "GameAppTests",
            dependencies: ["GameApp"]),
    ]
)
