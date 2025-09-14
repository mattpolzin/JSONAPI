// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "JSONAPI",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "JSONAPI",
            targets: ["JSONAPI"]),
        .library(
            name: "JSONAPITesting",
            targets: ["JSONAPITesting"])
    ],
    dependencies: [
        .package(url: "https://github.com/mattpolzin/Poly.git", .upToNextMajor(from: "3.0.0")),
    ],
    targets: [
        .target(
            name: "JSONAPI",
            dependencies: ["Poly"]),
        .target(
            name: "JSONAPITesting",
            dependencies: ["JSONAPI"]),
        .testTarget(
            name: "JSONAPITests",
            dependencies: ["JSONAPI", "JSONAPITesting"]),
        .testTarget(
            name: "JSONAPITestingTests",
            dependencies: ["JSONAPI", "JSONAPITesting"])
    ],
    swiftLanguageModes: [.v5, .v6]
)
