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
            name: "JSONAPIOpenAPI",
            targets: ["JSONAPIOpenAPI"])
    ],
    dependencies: [
		    .package(url: "https://github.com/mattpolzin/Poly.git", .branch("master")),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "JSONAPI",
            dependencies: ["Poly"]),
    		.target(
            name: "JSONAPITesting",
            dependencies: ["JSONAPI"]),
        .target(
            name: "JSONAPIOpenAPI",
            dependencies: ["JSONAPI", "AnyCodable"]),
        .testTarget(
            name: "JSONAPITests",
            dependencies: ["JSONAPI", "JSONAPITesting"]),
        .testTarget(
            name: "JSONAPITestingTests",
            dependencies: ["JSONAPI", "JSONAPITesting"]),
        .testTarget(
            name: "JSONAPIOpenAPITests",
            dependencies: ["JSONAPI", "JSONAPIOpenAPI"])
    ],
  	swiftLanguageVersions: [.v4_2]
)
