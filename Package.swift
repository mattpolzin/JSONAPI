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
			targets: ["JSONAPITesting"])
    ],
    dependencies: [
		.package(url: "https://github.com/mattpolzin/Poly.git", from: "1.0.0"),
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
  	swiftLanguageVersions: [.v4_2]
)
