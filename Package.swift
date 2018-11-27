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
			name: "JSONAPITestLib",
			targets: ["JSONAPITestLib"])
    ],
    dependencies: [
		// antitypical/Result without the Foundation requirement:
        .package(url: "https://github.com/mattpolzin/Result", .branch("master"))
    ],
    targets: [
        .target(
            name: "JSONAPI",
            dependencies: ["Result"]),
		.target(
			name: "JSONAPITestLib",
			dependencies: ["JSONAPI"]),
        .testTarget(
            name: "JSONAPITests",
            dependencies: ["JSONAPITestLib"])
    ],
  	swiftLanguageVersions: [.v4_2]
)
