// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONAPI",
    products: [
        .library(
            name: "JSONAPI",
            targets: ["JSONAPI"]),
		.library(
			name: "JSONAPITesting",
			targets: ["JSONAPITesting"]),
		.library(
			name: "JSONAPIArbitrary",
			targets: ["JSONAPIArbitrary"]),
        .library(
            name: "JSONAPIOpenAPI",
            targets: ["JSONAPIOpenAPI"])
    ],
    dependencies: [
		.package(url: "https://github.com/mattpolzin/Poly.git", from: "1.0.0"),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.1.0"),
		.package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.11.0")
    ],
    targets: [
        .target(
            name: "JSONAPI",
            dependencies: ["Poly"]),
		.target(
			name: "JSONAPITesting",
			dependencies: ["JSONAPI"]),
		.target(
			name: "JSONAPIArbitrary",
			dependencies: ["JSONAPI", "SwiftCheck"]),
        .target(
            name: "JSONAPIOpenAPI",
            dependencies: ["JSONAPI", "AnyCodable", "JSONAPIArbitrary"]),
        .testTarget(
            name: "JSONAPITests",
            dependencies: ["JSONAPI", "JSONAPITesting"]),
        .testTarget(
            name: "JSONAPITestingTests",
            dependencies: ["JSONAPI", "JSONAPITesting"]),
		.testTarget(
			name: "JSONAPIArbitraryTests",
			dependencies: ["JSONAPI", "SwiftCheck", "JSONAPIArbitrary"]),
        .testTarget(
            name: "JSONAPIOpenAPITests",
            dependencies: ["JSONAPI", "JSONAPIOpenAPI"])
    ],
  	swiftLanguageVersions: [.v4_2]
)
