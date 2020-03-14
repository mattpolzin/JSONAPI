# JSONAPI
[![MIT license](http://img.shields.io/badge/license-MIT-lightgrey.svg)](http://opensource.org/licenses/MIT) [![Swift 5.1](http://img.shields.io/badge/Swift-5.1-blue.svg)](https://swift.org) [![Build Status](https://app.bitrise.io/app/c8295b9589aa401e/status.svg?token=vzcyqWD5bQ4xqQfZsaVzNw&branch=master)](https://app.bitrise.io/app/c8295b9589aa401e)

A Swift package for encoding to- and decoding from **JSON API** compliant requests and responses.

See the JSON API Spec here: https://jsonapi.org/format/

:warning: This library provides well-tested type safety when working with JSON:API 1.0. However, the Swift compiler can sometimes have difficulty tracking down small typos when initializing `ResourceObjects`. Correct code will always compile, but tracking down the source of programmer errors can be an annoyance. This is mostly a concern when creating resource objects in-code (i.e. declaratively) like you might for unit testing. Writing a client that uses this framework to ingest and decode JSON API Compliant API responses is much less painful.

## Quick Start

:warning: The following Google Colab examples have correct code, but from time to time the Google Colab Swift compiler may be buggy and produce incorrect or erroneous results. Just keep that in mind if you run the code as you read through the Colab examples.

### Clientside
- [Basic Example](https://colab.research.google.com/drive/1IS7lRSBGoiW02Vd1nN_rfdDbZvTDj6Te)
- [Compound Example](https://colab.research.google.com/drive/1BdF0Kc7l2ixDfBZEL16FY6palweDszQU)
- [Metadata Example](https://colab.research.google.com/drive/10dEESwiE9I3YoyfzVeOVwOKUTEgLT3qr)
- [Custom Errors Example](https://colab.research.google.com/drive/1TIv6STzlHrkTf_-9Eu8sv8NoaxhZcFZH)
- [PATCH Example](https://colab.research.google.com/drive/16KY-0BoLQKiSUh9G7nYmHzB8b2vhXA2U)

### Serverside
- [GET Example](https://colab.research.google.com/drive/1krbhzSfz8mwkBTQQnKUZJLEtYsJKSfYX)
- [POST Example](https://colab.research.google.com/drive/1z3n70LwRY7vLIgbsMghvnfHA67QiuqpQ)

### Client+Server
This library works well when used by both the server responsible for serialization and the client responsible for deserialization. Check out the [example](#example) further down in this README.

## Table of Contents
- JSONAPI
	- [Primary Goals](#primary-goals)
	- [Dev Environment](#dev-environment)
		- [Prerequisites](#prerequisites)
		- [Swift Package Manager](#swift-package-manager)
		- [Xcode project](#xcode-project)
		- [CocoaPods](#cocoapods)
		- [Running the Playground](#running-the-playground)
	- [Project Status](#project-status)
	- [Example](#example)
	- [Usage](./documentation/usage.md)
- [JSONAPI+Testing](#jsonapitesting)
	- [Literal Expressibility](#literal-expressibility)
	- [Resource Object `check()`](#resource-object-check)
	- [Comparisons](#comparisons)
- [JSONAPI+Arbitrary](#jsonapiarbitrary)
- [JSONAPI+OpenAPI](#jsonapiopenapi)

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
1. Swift 5.1+
2. Swift Package Manager, Xcode 11+, or Cocoapods

### Swift Package Manager
Just include the following in your package's dependencies and add `JSONAPI` to the dependencies for any of your targets.
```swift
.package(url: "https://github.com/mattpolzin/JSONAPI.git", .upToNextMajor(from: "3.0.0"))
```

### Xcode project
To create an Xcode project for JSONAPI, run
`swift package generate-xcodeproj`

With Xcode 11+ you can also just open the folder containing your clone of this repository and begin working.

### CocoaPods
To use this framework in your project via Cocoapods, add the following dependencies to your Podfile.
```ruby
pod 'Poly', :git => 'https://github.com/mattpolzin/Poly.git'
pod 'MP-JSONAPI', :git => 'https://github.com/mattpolzin/JSONAPI.git'
```

### Running the Playground
To run the included Playground files, create an Xcode project using Swift Package Manager, then create an Xcode Workspace in the root of the repository and add both the generated Xcode project and the playground to the Workspace.

Note that Playground support for importing non-system Frameworks is still a bit touchy as of Swift 4.2. Sometimes building, cleaning and building, or commenting out and then uncommenting import statements (especially in the Entities.swift Playground Source file) can get things working for me when I am getting an error about `JSONAPI` not being found.

## Project Status

### JSON:API
#### Document
- [x] `data`
- [x] `included`
- [x] `errors`
- [x] `meta`
- [x] `jsonapi` (i.e. API Information)
- [x] `links`

#### Resource Object
- [x] `id`
- [x] `type`
- [x] `attributes`
- [x] `relationships`
- [x] `links`
- [x] `meta`

#### Relationship Object
- [x] `data`
- [x] `links`
- [x] `meta`

#### Links Object
- [x] `href`
- [x] `meta`

### Misc
- [x] Support transforms on `Attributes` values (e.g. to support different representations of `Date`)
- [x] Support validation on `Attributes`.
- [x] Support sparse fieldsets (encoding only). A client can likely just define a new model to represent a sparse population of another model in a very specific use case for decoding purposes. On the server side, sparse fieldsets of Resource Objects can be encoded without creating one model for every possible sparse fieldset.

### Testing
#### Resource Object Validator
- [x] Disallow optional array in `Attribute` (should be empty array, not `null`).
- [x] Only allow `TransformedAttribute` and its derivatives as stored properties within `Attributes` struct. Computed properties can still be any type because they do not get encoded or decoded.
- [x] Only allow `ToManyRelationship` and `ToOneRelationship` within `Relationships` struct.

### Potential Improvements
These ideas could be implemented in future versions.

- [ ] (Maybe) Use `KeyPath` to specify `Includes` thus creating type safety around the relationship between a primary resource type and the types of included resources.
- [ ] (Maybe) Replace `SingleResourceBody` and `ManyResourceBody` with support at the `Document` level to just interpret `PrimaryResource`, `PrimaryResource?`, or `[PrimaryResource]` as the same decoding/encoding strategies.
- [ ] Support sideposting. JSONAPI spec might become opinionated in the future (https://github.com/json-api/json-api/pull/1197, https://github.com/json-api/json-api/issues/1215, https://github.com/json-api/json-api/issues/1216) but there is also an existing implementation to consider (https://jsonapi-suite.github.io/jsonapi_suite/ruby/writes/nested-writes). At this time, any sidepost implementation would be an awesome tertiary library to be used alongside the primary JSONAPI library. Maybe `JSONAPISideloading`.
- [ ] Error or warning if an included resource object is not related to a primary resource object or another included resource object (Turned off or at least not throwing by default).

## Example
The following serves as a sort of pseudo-example. It skips server/client implementation details not related to JSON:API but still gives a more complete picture of what an implementation using this framework might look like. You can play with this example code in the Playground provided with this repo.

### Preamble (Setup shared by server and client)
```swift
// Make String a CreatableRawIdType.
var globalStringId: Int = 0
extension String: CreatableRawIdType {
	public static func unique() -> String {
		globalStringId += 1
		return String(globalStringId)
	}
}

// Create a typealias because we do not expect JSON:API Resource
// Objects for this particular API to have Metadata or Links associated
// with them. We also expect them to have String Identifiers.
typealias JSONEntity<Description: ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, String>

// Similarly, create a typealias for unidentified entities. JSON:API
// only allows unidentified entities (i.e. no "id" field) for client
// requests that create new entities. In these situations, the server
// is expected to assign the new entity a unique ID.
typealias UnidentifiedJSONEntity<Description: ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, Unidentified>

// Create relationship typealiases because we do not expect
// JSON:API Relationships for this particular API to have
// Metadata or Links associated with them.
typealias ToOneRelationship<Entity: Identifiable> = JSONAPI.ToOneRelationship<Entity, NoMetadata, NoLinks>
typealias ToManyRelationship<Entity: Relatable> = JSONAPI.ToManyRelationship<Entity, NoMetadata, NoLinks>

// Create a typealias for a Document because we do not expect
// JSON:API Documents for this particular API to have Metadata, Links,
// useful Errors, or an APIDescription (The *SPEC* calls this
// "API Description" the "JSON:API Object").
typealias Document<PrimaryResourceBody: JSONAPI.CodableResourceBody, IncludeType: JSONAPI.Include> = JSONAPI.Document<PrimaryResourceBody, NoMetadata, NoLinks, IncludeType, NoAPIDescription, BasicJSONAPIError<String>>

// MARK: Entity Definitions

enum AuthorDescription: ResourceObjectDescription {
	public static var jsonType: String { return "authors" }

	public struct Attributes: JSONAPI.Attributes {
		public let name: Attribute<String>
	}

	public typealias Relationships = NoRelationships
}

typealias Author = JSONEntity<AuthorDescription>

enum ArticleDescription: ResourceObjectDescription {
	public static var jsonType: String { return "articles" }

	public struct Attributes: JSONAPI.Attributes {
		public let title: Attribute<String>
		public let abstract: Attribute<String>
	}

	public struct Relationships: JSONAPI.Relationships {
		public let author: ToOneRelationship<Author>
	}
}

typealias Article = JSONEntity<ArticleDescription>

// MARK: Document Definitions

// We create a typealias to represent a document containing one Article
// and including its Author
typealias SingleArticleDocumentWithIncludes = Document<SingleResourceBody<Article>, Include1<Author>>

// ... and a typealias to represent a document containing one Article and
// not including any related entities.
typealias SingleArticleDocument = Document<SingleResourceBody<Article>, NoIncludes>
```

### Server Pseudo-example
```swift
// Skipping over all the API and database stuff, here's a chunk of code
// that creates a document. Note that this document is the entirety
// of a JSON:API response body.
func articleDocument(includeAuthor: Bool) -> Either<SingleArticleDocument, SingleArticleDocumentWithIncludes> {
    // Let's pretend all of this is coming from a database:

    let authorId = Author.Identifier(rawValue: "1234")

    let article = Article(id: .init(rawValue: "5678"),
                          attributes: .init(title: .init(value: "JSON:API in Swift"),
                                            abstract: .init(value: "Not yet written")),
                          relationships: .init(author: .init(id: authorId)),
                          meta: .none,
                          links: .none)

    let document = SingleArticleDocument(apiDescription: .none,
                                         body: .init(resourceObject: article),
                                         includes: .none,
                                         meta: .none,
                                         links: .none)

    switch includeAuthor {
    case false:
        return .init(document)

    case true:
        let author = Author(id: authorId,
                            attributes: .init(name: .init(value: "Janice Bluff")),
                            relationships: .none,
                            meta: .none,
                            links: .none)

        let includes: Includes<SingleArticleDocumentWithIncludes.Include> = .init(values: [.init(author)])

        return .init(document.including(includes))
    }
}

let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase
encoder.outputFormatting = .prettyPrinted

let responseBody = articleDocument(includeAuthor: true)
let responseData = try! encoder.encode(responseBody)

// Next step would be setting the HTTP body of a response.
// We will just print it out instead:
print("-----")
print(String(data: responseData, encoding: .utf8)!)

// ... and if we had received a request for an article without
// including the author:
let otherResponseBody = articleDocument(includeAuthor: false)
let otherResponseData = try! encoder.encode(otherResponseBody)
print("-----")
print(String(data: otherResponseData, encoding: .utf8)!)
```

### Client Pseudo-example
```swift
enum NetworkError: Swift.Error {
    case serverError
    case quantityMismatch
}

// Skipping over all the API stuff, here's a chunk of code that will
// decode a document. We will assume we have made a request for a
// single article including the author.
func docode(articleResponseData: Data) throws -> (article: Article, author: Author) {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let articleDocument = try decoder.decode(SingleArticleDocumentWithIncludes.self, from: articleResponseData)

    switch articleDocument.body {
    case .data(let data):
        let authors = data.includes[Author.self]

        guard authors.count == 1 else {
            throw NetworkError.quantityMismatch
        }

        return (article: data.primary.value, author: authors[0])
    case .errors(let errors, meta: _, links: _):
        throw NetworkError.serverError
    }
}

let response = try! docode(articleResponseData: responseData)

// Next step would be to do something useful with the article and author but we will print them instead.
print("-----")
print(response.article)
print(response.author)
```

## Deeper Dive
See the [usage documentation](./documentation/usage.md).

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

# JSONAPI+Arbitrary
The `JSONAPI+Arbitrary` library provides `SwiftCheck` `Arbitrary` conformance for many of the `JSONAPI` types.

See https://github.com/mattpolzin/JSONAPI-Arbitrary for more information.

# JSONAPI+OpenAPI
The `JSONAPI+OpenAPI` library generates OpenAPI compliant JSON Schema for models built with the `JSONAPI` library. If your Swift code is your preferred source of truth for API information, this is an easy way to document the response schemas of your API.

`JSONAPI+OpenAPI` also has experimental support for generating `JSONAPI` Swift code from Open API documentation (this currently lives on the `feature/gen-swift` branch).

See https://github.com/mattpolzin/JSONAPI-OpenAPI for more information.
