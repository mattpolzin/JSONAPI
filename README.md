# JSONAPI
[![MIT license](http://img.shields.io/badge/license-MIT-lightgrey.svg)](http://opensource.org/licenses/MIT) [![Swift 5.2+](http://img.shields.io/badge/Swift-5.2/5.3-blue.svg)](https://swift.org) [![Build Status](https://app.bitrise.io/app/c8295b9589aa401e/status.svg?token=vzcyqWD5bQ4xqQfZsaVzNw&branch=master)](https://app.bitrise.io/app/c8295b9589aa401e)

A Swift package for encoding to- and decoding from **JSON API** compliant requests and responses.

See the JSON API Spec here: https://jsonapi.org/format/

## Quick Start

:warning: The following Google Colab examples have correct code, but from time to time the Google Colab Swift compiler may be buggy and claim it cannot build the JSONAPI library.

### Clientside
- [Basic Example](https://colab.research.google.com/drive/1IS7lRSBGoiW02Vd1nN_rfdDbZvTDj6Te)
- [Compound Example](https://colab.research.google.com/drive/1BdF0Kc7l2ixDfBZEL16FY6palweDszQU)
- [Metadata Example](https://colab.research.google.com/drive/10dEESwiE9I3YoyfzVeOVwOKUTEgLT3qr)
- [Custom Errors Example](https://colab.research.google.com/drive/1TIv6STzlHrkTf_-9Eu8sv8NoaxhZcFZH)
- [PATCH Example](https://colab.research.google.com/drive/16KY-0BoLQKiSUh9G7nYmHzB8b2vhXA2U)
- [Resource Storage Example](https://colab.research.google.com/drive/196eCnBlf2xz8pT4lW--ur6eWSVAjpF6b?usp=sharing) (using [JSONAPI-ResourceStorage](#jsonapi-resourcestorage))

### Serverside
- [GET Example](https://colab.research.google.com/drive/1krbhzSfz8mwkBTQQnKUZJLEtYsJKSfYX)
- [POST Example](https://colab.research.google.com/drive/1z3n70LwRY7vLIgbsMghvnfHA67QiuqpQ)

### Client+Server
This library works well when used by both the server responsible for serialization and the client responsible for deserialization. Check out the [example](./documentation/client-server-example.md).

## Table of Contents
- JSONAPI
	- [Primary Goals](#primary-goals)
	- [Dev Environment](#dev-environment)
		- [Prerequisites](#prerequisites)
		- [Swift Package Manager](#swift-package-manager)
		- [Xcode project](#xcode-project)
		- [CocoaPods](#cocoapods)
		- [Running the Playground](#running-the-playground)
	- [Project Status](./documentation/project-status.md)
	- [Server & Client Example](./documentation/client-server-example.md)
	- [Usage](./documentation/usage.md)
- [JSONAPI+Testing](#jsonapitesting)
	- [Literal Expressibility](#literal-expressibility)
	- [Resource Object `check()`](#resource-object-check)
	- [Comparisons](#comparisons)
- [JSONAPI-Arbitrary](#jsonapi-arbitrary)
- [JSONAPI-OpenAPI](#jsonapi-openapi)
- [JSONAPI-ResourceStorage](#jsonapi-resourcestorage)

## Primary Goals

The primary goals of this framework are:
1. Allow creation of Swift types that are easy to use in code but also can be encoded to- or decoded from **JSON API v1.0 Spec** compliant payloads without lots of boilerplate code.
2. Leverage `Codable` to avoid additional outside dependencies and get operability with non-JSON encoders/decoders for free.
3. Do not sacrifice type safety.
4. Be platform agnostic so that Swift code can be written once and used by both the client and the server.
5. Provide _human readable_ error output. The errors thrown when decoding an API response and the results of the `JSONAPITesting` framework's `compare(to:)` functions all have digestible human readable descriptions (just use `String(describing:)`).

### Caveat
The big caveat is that, although the aim is to support the JSON API spec, this framework ends up being _naturally_ opinionated about certain things that the API Spec does not specify. These caveats are largely a side effect of attempting to write the library in a "Swifty" way.

If you find something wrong with this library and it isn't already mentioned under **Project Status**, let me know! I want to keep working towards a library implementation that is useful in any application.

## Dev Environment
### Prerequisites
1. Swift 5.2+
2. Swift Package Manager, Xcode 11+, or Cocoapods

### Swift Package Manager
Just include the following in your package's dependencies and add `JSONAPI` to the dependencies for any of your targets.
```swift
.package(url: "https://github.com/mattpolzin/JSONAPI.git", from: "5.0.0")
```

### Xcode project
With Xcode 11+, you can open the folder containing this repository. There is no need for an Xcode project, but you can generate one with `swift package generate-xcodeproj`.

### CocoaPods
To use this framework in your project via Cocoapods, add the following dependencies to your Podfile.
```ruby
pod 'Poly', :git => 'https://github.com/mattpolzin/Poly.git'
pod 'MP-JSONAPI', :git => 'https://github.com/mattpolzin/JSONAPI.git'
```

### Carthage
This library does not support the Carthage package manager. This is intentional to avoid an additional dependency on Xcode and the Xcode's project files as their format changes throughout versions (in addition to the complexity of maintaining different shared schemes for each supported operating system). 

The difference between supporting and not supporting Carthage is the difference between maintaining an Xcode project with at least one shared build scheme; I encourage those that need Carthage support to fork this repository and add support to their fork by committing an Xcode project (you can generate one as described in the [Xcode project](#xcode-project) section above). Once an Xcode project is generated, you need to mark at least one scheme as [shared](https://github.com/Carthage/Carthage#share-your-xcode-schemes).

### Running the Playground
To run the included Playground files, create an Xcode project using Swift Package Manager, then create an Xcode Workspace in the root of the repository and add both the generated Xcode project and the playground to the Workspace.

Note that Playground support for importing non-system Frameworks is still a bit touchy as of Swift 4.2. Sometimes building, cleaning and building, or commenting out and then uncommenting import statements (especially in the` Entities.swift` Playground Source file) can get things working for me when I am getting an error about `JSONAPI` not being found.

## Deeper Dive
- [Project Status](./documentation/project-status.md)
- [Server & Client Example](./documentation/client-server-example.md)
- [Usage Documentation](./documentation/usage.md)

# JSONAPI+Testing
The `JSONAPI` framework is packaged with a test library to help you test your `JSONAPI` integration. The test library is called `JSONAPITesting`. You can see `JSONAPITesting` in action in the Playground included with the `JSONAPI` repository.

## Literal Expressibility
Literal expressibility for `Attribute`, `ToOneRelationship`, and `Id` are provided so that you can easily write test `ResourceObject` values into your unit tests.

For example, you could create a mock `Author` (from the above example) as follows
```swift
let author = Author(
	id: "1234", // You can just use a String directly as an Id
	attributes: .init(name: "Janice Bluff"), // The name Attribute does not need to be initialized, you just use a String directly.
	relationships: .none,
	meta: .none,
	links: .none
)
```

## Resource Object `check()`
The `ResourceObject` gets a `check()` function that can be used to catch problems with your `JSONAPI` structures that are not caught by Swift's type system.

To catch malformed `JSONAPI.Attributes` and `JSONAPI.Relationships`, just call `check()` in your unit test functions:
```swift
func test_initAuthor() {
	let author = Author(...)
	Author.check(author)
}
```

## Comparisons
You can compare `Documents`, `ResourceObjects`, `Attributes`, etc. and get human-readable output using the `compare(to:)` methods included with `JSONAPITesting`.

```swift
func test_articleResponse() {
	let endToEndAPITestResponse: SingleArticleDocumentWithIncludes = ...

	let expectedResponse: SingleArticleDocumentWithIncludes = ...

	let comparison = endToEndAPITestResponse.compare(to: expectedResponse)

	XCTAssert(comparison.isSame, String(describing: comparison))
}
```

# JSONAPI-Arbitrary
The `JSONAPI-Arbitrary` library provides `SwiftCheck` `Arbitrary` conformance for many of the `JSONAPI` types.

See https://github.com/mattpolzin/JSONAPI-Arbitrary for more information.

# JSONAPI-OpenAPI
The `JSONAPI-OpenAPI` library generates OpenAPI compliant JSON Schema for models built with the `JSONAPI` library. If your Swift code is your preferred source of truth for API information, this is an easy way to document the response schemas of your API.

`JSONAPI-OpenAPI` also has experimental support for generating `JSONAPI` Swift code from Open API documentation (this currently lives on the `feature/gen-swift` branch).

See https://github.com/mattpolzin/JSONAPI-OpenAPI for more information.

# JSONAPI-ResourceStorage
The `JSONAPI-ResourceStorage` package has two _very_ early stage modules supporting storage and retrieval of `JSONAPI.ResourceObjects`. Please consider these modules to be more of examples of two directions you could head in than anything else.

https://github.com/mattpolzin/JSONAPI-ResourceStorage
