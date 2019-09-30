# JSONAPI
[![MIT license](http://img.shields.io/badge/license-MIT-lightgrey.svg)](http://opensource.org/licenses/MIT) [![Swift 5.1](http://img.shields.io/badge/Swift-5.1-blue.svg)](https://swift.org) [![Build Status](https://app.bitrise.io/app/c8295b9589aa401e/status.svg?token=vzcyqWD5bQ4xqQfZsaVzNw&branch=master)](https://app.bitrise.io/app/c8295b9589aa401e)

A Swift package for encoding to- and decoding from **JSON API** compliant requests and responses.

See the JSON API Spec here: https://jsonapi.org/format/

:warning: This library provides well-tested type safety when working with JSON:API 1.0. However, the Swift compiler can sometimes have difficulty tracking down small typos when initializing `ResourceObjects`. Once the code is written correctly, it will compile, but tracking down the source of programmer errors can be an annoyance. This is mostly a concern when creating resource objects in-code (servers and test cases must do this). Writing a client that uses this framework to ingest JSON API Compliant API responses is much less painful.

## Quick Start

:warning: The following Google Colab examples have correct code, but there appears to be an bug in the branch of the Swift compiler currently being used by the Google Colab Swift notebooks such that the `JSONAPI` package cannot be pulled in and you cannot run the examples in-browser.

### Clientside
- [Basic Example](https://colab.research.google.com/drive/1IS7lRSBGoiW02Vd1nN_rfdDbZvTDj6Te)
- [Compound Example](https://colab.research.google.com/drive/1BdF0Kc7l2ixDfBZEL16FY6palweDszQU)
- [Metadata Example](https://colab.research.google.com/drive/10dEESwiE9I3YoyfzVeOVwOKUTEgLT3qr)
- [Custom Errors Example](https://colab.research.google.com/drive/1TIv6STzlHrkTf_-9Eu8sv8NoaxhZcFZH)

### Serverside
- [GET Example](https://colab.research.google.com/drive/1krbhzSfz8mwkBTQQnKUZJLEtYsJKSfYX)
- [POST Example](https://colab.research.google.com/drive/1z3n70LwRY7vLIgbsMghvnfHA67QiuqpQ)

### Combined
This library works well when used by both the server responsible for serialization and the client responsible for deserialization. Check out the [example](#example) further down in this README.

## Table of Contents

- [JSONAPI](#jsonapi)
	- [Primary Goals](#primary-goals)
		- [Caveat](#caveat)
	- [Dev Environment](#dev-environment)
		- [Prerequisites](#prerequisites)
		- [Swift Package Manager](#swift-package-manager)
		- [CocoaPods](#cocoapods)
		- [Xcode project](#xcode-project)
		- [Running the Playground](#running-the-playground)
	- [Project Status](#project-status)
		- [JSON:API](#jsonapi)
			- [Document](#document)
			- [Resource Object](#resource-object)
			- [Relationship Object](#relationship-object)
			- [Links Object](#links-object)
		- [Misc](#misc)
		- [Testing](#testing)
			- [Resource Object Validator](#resource-object-validator)
		- [Potential Improvements](#potential-improvements)
	- [Usage](#usage)
		- [`JSONAPI.ResourceObjectDescription`](#jsonapiresourceobjectdescription)
		- [`JSONAPI.ResourceObject`](#jsonapiresourceobject)
			- [`Meta`](#meta)
			- [`Links`](#links)
			- [`MaybeRawId`](#mayberawid)
				- [`RawIdType`](#rawidtype)
			- [Convenient `typealiases`](#convenient-typealiases)
		- [`JSONAPI.Relationships`](#jsonapirelationships)
		- [`JSONAPI.Attributes`](#jsonapiattributes)
			- [`Transformer`](#transformer)
			- [`Validator`](#validator)
			- [Computed `Attribute`](#computed-attribute)
		- [Copying/Mutating `ResourceObjects`](#copyingmutating-resourceobjects)
		- [`JSONAPI.Document`](#jsonapidocument)
			- [`ResourceBody`](#resourcebody)
				- [nullable `PrimaryResource`](#nullable-primaryresource)
			- [`MetaType`](#metatype)
			- [`LinksType`](#linkstype)
			- [`IncludeType`](#includetype)
			- [`APIDescriptionType`](#apidescriptiontype)
			- [`Error`](#error)
				- [`UnknownJSONAPIError`](#unknownjsonapierror)
				- [`BasicJSONAPIError`](#basicjsonapierror)
				- [`GenericJSONAPIError`](#genericjsonapierror)
		- [`JSONAPI.Meta`](#jsonapimeta)
		- [`JSONAPI.Links`](#jsonapilinks)
		- [`JSONAPI.RawIdType`](#jsonapirawidtype)
		- [Sparse Fieldsets](#sparse-fieldsets)
			- [Supporting Sparse Fieldset Encoding](#supporting-sparse-fieldset-encoding)
			- [Sparse Fieldset `typealias` comparisons](#sparse-fieldset-typealias-comparisons)
		- [Custom Attribute or Relationship Key Mapping](#custom-attribute-or-relationship-key-mapping)
		- [Custom Attribute Encode/Decode](#custom-attribute-encodedecode)
		- [Meta-Attributes](#meta-attributes)
		- [Meta-Relationships](#meta-relationships)
	- [Example](#example)
		- [Preamble (Setup shared by server and client)](#preamble-setup-shared-by-server-and-client)
		- [Server Pseudo-example](#server-pseudo-example)
		- [Client Pseudo-example](#client-pseudo-example)
- [JSONAPI+Testing](#jsonapitesting)
- [JSONAPI+Arbitrary](#jsonapiarbitrary)
- [JSONAPI+OpenAPI](#jsonapiopenapi)

## Primary Goals

The primary goals of this framework are:
1. Allow creation of Swift types that are easy to use in code but also can be encoded to- or decoded from **JSON API v1.0 Spec** compliant payloads without lots of boilerplate code.
2. Leverage `Codable` to avoid additional outside dependencies and get operability with non-JSON encoders/decoders for free.
3. Do not sacrifice type safety.
4. Be platform agnostic so that Swift code can be written once and used by both the client and the server.

### Caveat
The big caveat is that, although the aim is to support the JSON API spec, this framework ends up being _naturally_ opinionated about certain things that the API Spec does not specify. These caveats are largely a side effect of attempting to write the library in a "Swifty" way.

If you find something wrong with this library and it isn't already mentioned under **Project Status**, let me know! I want to keep working towards a library implementation that is useful in any application.

## Dev Environment
### Prerequisites
1. Swift 5.1+
2. Swift Package Manager *OR* Cocoapods

### Swift Package Manager
Just include the following in your package's dependencies and add `JSONAPI` to the dependencies for any of your targets.
```
	.package(url: "https://github.com/mattpolzin/JSONAPI.git", .upToNextMajor(from: "2.2.0"))
```

### CocoaPods
To use this framework in your project via Cocoapods, add the following dependencies to your Podfile.
```
	pod 'Poly', :git => 'https://github.com/mattpolzin/Poly.git'
	pod 'MP-JSONAPI', :git => 'https://github.com/mattpolzin/JSONAPI.git'
```

### Xcode project
To create an Xcode project for JSONAPI, run
`swift package generate-xcodeproj`

With Xcode 11+ you can also just open the folder containing your clone of this repository and begin working.

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

## Usage

In this documentation, in order to draw attention to the difference between the `JSONAPI` framework (this Swift library) and the **JSON API Spec** (the specification this library helps you follow), the specification will consistently be referred to below as simply the **SPEC**.

### `JSONAPI.ResourceObjectDescription`

A `ResourceObjectDescription` is the `JSONAPI` framework's representation of what the **SPEC** calls a *Resource Object*. You might create the following `ResourceObjectDescription` to represent a person in a network of friends:

```swift
enum PersonDescription: IdentifiedResourceObjectDescription {
	static var jsonType: String { return "people" }

	struct Attributes: JSONAPI.Attributes {
		let name: Attribute<[String]>
		let favoriteColor: Attribute<String>
	}

	struct Relationships: JSONAPI.Relationships {
		let friends: ToManyRelationship<Person>
	}
}
```

The requirements of a `ResourceObjectDescription` are:
1. A static `var` "jsonType" that matches the JSON type; The **SPEC** requires every *Resource Object* to have a "type".
2. A `struct` of `Attributes` **- OR -** `typealias Attributes = NoAttributes`
3. A `struct` of `Relationships` **- OR -** `typealias Relationships = NoRelationships`

Note that an `enum` type is used here for the `ResourceObjectDescription`; it could have been a `struct`, but `ResourceObjectDescription`s do not ever need to be created so an `enum` with no `case`s is a nice fit for the job.

This readme doesn't go into detail on the **SPEC**, but the following *Resource Object* would be described by the above `PersonDescription`:

```json
{
  "type": "people",
  "id": "9",
  "attributes": {
    "name": [
      "Jane",
      "Doe"
    ],
    "favoriteColor": "Green"
  },
  "relationships": {
    "friends": {
      "data": [
        {
          "id": "7",
          "type": "people"
        },
        {
          "id": "8",
          "type": "people"
        }
      ]
    }
  }
}
```

### `JSONAPI.ResourceObject`

Once you have a `ResourceObjectDescription`, you _create_, _encode_, and _decode_ `ResourceObjects` that "fit the description". If you have a `CreatableRawIdType` (see the section on `RawIdType`s below) then you can create new `ResourceObjects` that will automatically be given unique Ids, but even without a `CreatableRawIdType` you can encode, decode and work with resource objects.

The `ResourceObject` and `ResourceObjectDescription` together with a `JSONAPI.Meta` type and a `JSONAPI.Links` type embody the rules and properties of a JSON API *Resource Object*.

A `ResourceObject` needs to be specialized on four generic types. The first is the `ResourceObjectDescription` described above. The others are a `Meta`, `Links`, and `MaybeRawId`.

#### `Meta`

The second generic specialization on `ResourceObject` is `Meta`. This is described in its own section [below](#jsonapimeta). All `Meta` at any level of a JSON API Document follow the same rules. You can use `NoMetadata` if you do not need to package any metadata with the `ResourceObject`.

#### `Links`

The third generic specialization on `ResourceObject` is `Links`. This is described in its own section [below](#jsonnapilinks). All `Links` at any level of a JSON API Document follow the same rules, although the **SPEC** makes different suggestions as to what types of links might live on which parts of the Document. You can use `NoLinks` if you do not need to package any links with the `ResourceObject`.

#### `MaybeRawId`

The last generic specialization on `ResourceObject` is `MaybeRawId`. This is either a `RawIdType` that can be used to uniquely identify `ResourceObjects` or it is `Unidentified` which is used to indicate a `ResourceObject` does not have an `Id` (which is useful when a client is requesting that the server create a `ResourceObject` and assign it a new `Id`).

##### `RawIdType`

The raw type of `Id` to use for the `ResourceObject`. The actual `Id` of the `ResourceObject` will not be a `RawIdType`, though. The `Id` will package a value of `RawIdType` with a specialized reference back to the `ResourceObject` type it identifies. This just looks like `Id<RawIdType, ResourceObject<ResourceObjectDescription, Meta, Links, RawIdType>>`.

Having the `ResourceObject` type associated with the `Id` makes it easy to store all of your resource objects in a hash broken out by `ResourceObject` type; You can pass `Ids` around and always know where to look for the `ResourceObject` to which the `Id` refers. This encapsulation provides some type safety because the Ids of two `ResourceObjects` with the "raw ID" of `"1"` but different types will not compare as equal.

A `RawIdType` is the underlying type that uniquely identifies a `ResourceObject`. This is often a `String` or a `UUID`.

#### Convenient `typealiases`

Often you can use one `RawIdType` for many if not all of your `ResourceObjects`. That means you can save yourself some boilerplate by using `typealias`es like the following:
```swift
public typealias ResourceObject<Description: JSONAPI.ResourceObjectDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.ResourceObject<Description, Meta, Links, String>

public typealias NewResourceObject<Description: JSONAPI.ResourceObjectDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.ResourceObject<Description, Meta, Links, Unidentified>
```

It can also be nice to create a `typealias` for each type of resource object you want to work with:
```swift
typealias Person = ResourceObject<PersonDescription, NoMetadata, NoLinks>

typealias NewPerson = NewResourceObject<PersonDescription, NoMetadata, NoLinks>
```

Note that I am assuming an unidentified person is a "new" person. I suspect that is generally an acceptable conflation because the only time the **SPEC** allows a *Resource Object* to be encoded without an `Id` is when a client is requesting the given *Resource Object* be created by the server and the client wants the server to create the `Id` for that object.

### `JSONAPI.Relationships`

There are two types of `Relationships`: `ToOneRelationship` and `ToManyRelationship`. A `ResourceObjectDescription`'s `Relationships` type can contain any number of `Relationship` properties of either of these types. Do not store anything other than `Relationship` properties in the `Relationships` struct of a `ResourceObjectDescription`.

In addition to identifying resource objects by Id and type, `Relationships` can contain `Meta` or `Links` that follow the same rules as [`Meta`](#jsonapimeta) and [`Links`](#jsonapilinks) elsewhere in the JSON API Document.

To describe a relationship that may be omitted (i.e. the key is not even present in the JSON object), you make the entire `ToOneRelationship` or `ToManyRelationship` optional. However, this is not recommended because you can also represent optional relationships as nullable which means the key is always present. A `ToManyRelationship` can naturally represent the absence of related values with an empty array, so `ToManyRelationship` does not support nullability at all. A `ToOneRelationship` can be marked as nullable (i.e. the value could be either `null` or a resource identifier) like this:
```swift
let nullableRelative: ToOneRelationship<Person?, NoMetadata, NoLinks>
```

A `ResourceObject` that does not have relationships can be described by adding the following to a `ResourceObjectDescription`:
```swift
typealias Relationships = NoRelationships
```

`Relationship` values boil down to `Ids` of other resource objects. To access the `Id` of a related `ResourceObject`, you can use the custom `~>` operator with the `KeyPath` of the `Relationship` from which you want the `Id`. The friends of the above `Person` `ResourceObject` can be accessed as follows (type annotations for clarity):
```swift
let friendIds: [Person.Identifier] = person ~> \.friends
```

### `JSONAPI.Attributes`

The `Attributes` of a `ResourceObjectDescription` can contain any JSON encodable/decodable types as long as they are wrapped in an `Attribute`, `ValidatedAttribute`, or `TransformedAttribute` `struct`.

To describe an attribute that may be omitted (i.e. the key might not even be in the JSON object), you make the entire `Attribute` optional:
```swift
let optionalAttribute: Attribute<String>?
```

To describe an attribute that is expected to exist but might have a `null` value, you make the value within the `Attribute` optional:
```swift
let nullableAttribute: Attribute<String?>
```

A resource object that does not have attributes can be described by adding the following to an `ResourceObjectDescription`:
```swift
typealias Attributes = NoAttributes
```

As of Swift 5.1, `Attributes` can be accessed via dynamic member keypath lookup as follows:
```swift
let favoriteColor: String = person.favoriteColor
```

🗒 `Attributes` can also be accessed via the older `subscript` operator as follows:
```swift
let favoriteColor: String = person[\.favoriteColor]
```

In both cases you retain type-safety. It is best practice to pick an attribute access syntax and stick with it. At some point in the future the syntax deemed less desirable may be deprecated.

#### `Transformer`

Sometimes you need to use a type that does not encode or decode itself in the way you need to represent it as a serialized JSON object. For example, the Swift `Foundation` type `Date` can encode/decode itself to `Double` out of the box, but you might want to represent dates as ISO 8601 compliant `String`s instead. The Foundation library `JSONDecoder` has a setting to make this adjustment, but for the sake of an example, you could create a `Transformer`.

A `Transformer` just provides one static function that transforms one type to another. You might define one for an ISO 8601 compliant `Date` like this:
```swift
enum ISODateTransformer: Transformer {
	public static func transform(_ value: String) throws -> Date {
		// parse Date out of input and return
	}
}
```

Then you define the attribute as a `TransformedAttribute` instead of an `Attribute`:
```swift
let date: TransformedAttribute<String, ISODateTransformer>
```

Note that the first generic parameter of `TransformAttribute` is the type you expect to decode from JSON, not the type you want to end up with after transformation.

If you make your `Transformer` a `ReversibleTransformer` then your life will be a bit easier when you construct `TransformedAttributes` because you have access to initializers for both the pre- and post-transformed value types. Continuing with the above example of a `ISODateTransformer`:
```swift
extension ISODateTransformer: ReversibleTransformer {
	public static func reverse(_ value: Date) throws -> String {
		// serialize Date to a String
	}
}

let exampleAttribute = try? TransformedAttribute<String, ISODateTransformer>(transformedValue: Date())
let otherAttribute = try? TransformedAttribute<String, ISODateTransformer>(rawValue: "2018-12-01 09:06:41 +0000")
```

#### `Validator`

You can also creator `Validators` and `ValidatedAttribute`s. A `Validator` is just a `Transformer` that by convention does not perform a transformation. It simply `throws` if an attribute value is invalid.

#### Computed `Attribute`

You can add computed properties to your `ResourceObjectDescription.Attributes` struct if you would like to expose attributes that are not explicitly represented by the JSON. These computed properties do not have to be wrapped in `Attribute`, `ValidatedAttribute`, or `TransformedAttribute`. This allows computed attributes to be of types that are not `Codable`. Here's an example of how you might take the `person.name` attribute from the example above and create a `fullName` computed property.

```swift
public var fullName: Attribute<String> {
	return name.map { $0.joined(separator: " ") }
}
```

If your computed property is wrapped in a `AttributeType` then you can still use the default subscript operator to access it (as would be the case with the `person.fullName` example above). However, if you add a property to the `Attributes` `struct` that is not wrapped in an `AttributeType`, you must either access it from its full path (`person.attributes.newThing`) or with the "direct" subscript accessor (`person[direct: \.newThing]`). This keeps the subscript access unambiguous enough for the compiler to be helpful prior to explicitly casting, comparing, or storing the result.

### Copying/Mutating `ResourceObjects`
`ResourceObject` is a value type, so copying is its default behavior. There are two common mutations you might want to make when copying a `ResourceObject`:
1. Assigning a new `Identifier` to the copy of an identified `ResourceObject`.
2. Assigning a new `Identifier` to the copy of an unidentified `ResourceObject`.

The above can be accomplished with code like the following:

```swift
// use case 1
let person1 = person.withNewIdentifier()

// use case 2
let newlyIdentifiedPerson1 = unidentifiedPerson.identified(byType: String.self)

let newlyIdentifiedPerson2 = unidentifiedPerson.identified(by: "2232")
```

### `JSONAPI.Document`

The entirety of a JSON API request or response is encoded or decoded from- or to a `Document`. As an example, a JSON API response containing one `Person` and no included resource objects could be decoded as follows:
```swift
let decoder = JSONDecoder()

let responseStructure = JSONAPI.Document<SingleResourceBody<Person>, NoMetadata, NoLinks, NoIncludes, BasicJSONAPIError<String>>.self

let document = try decoder.decode(responseStructure, from: data)
```

A JSON API Document is guaranteed by the **SPEC** to be "data", "metadata", or "errors." If it is "data", it may also contain "metadata" and/or other "included" resources. If it is "errors," it may also contain "metadata."

#### `ResourceBody`

The first generic type of a `JSONAPIDocument` is a `ResourceBody`. This can either be a `SingleResourceBody<PrimaryResource>` or a `ManyResourceBody<PrimaryResource>`. You will find zero or one `PrimaryResource` values in a JSON API document that has a `SingleResourceBody` and you will find zero or more `PrimaryResource` values in a JSON API document that has a `ManyResourceBody`. You can use the `Poly` types (`Poly1` through `Poly6`) to specify that a `ResourceBody` will be one of a few different types of `ResourceObject`. These `Poly` types work in the same way as the `Include` types described below.

If you expect a response to not have a "data" top-level key at all, then use `NoResourceBody` instead.

##### nullable `PrimaryResource`

If you expect a `SingleResourceBody` to sometimes come back `null`, you should make your `PrimaryResource` optional. If you do not make your `PrimaryResource` optional then a `null` primary resource will be considered an error when parsing the JSON.

You cannot, however, use an optional `PrimaryResource` with a `ManyResourceBody` because the **SPEC** requires that an empty document in that case be represented by an empty array rather than `null`.

#### `MetaType`

The second generic type of a `JSONAPIDocument` is a `Meta`. This `Meta` follows the same rules as `Meta` at any other part of a JSON API Document. It is described below in its own section, but as an example, the JSON API document could contain the following pagination info in its meta entry:
```json
{
	"meta": {
		"total": 100,
		"limit": 50,
		"offset": 50
	}
}
```

You would then create the following `Meta` type:
```swift
struct PageMetadata: JSONAPI.Meta {
	let total: Int
	let limit: Int
	let offset: Int
}
```

You can always use `NoMetadata` if this JSON API feature is not needed.

#### `LinksType`

The third generic type of a `JSONAPIDocument` is a `Links` struct. `Links` are described in their own section [below](#jsonapilinks).

#### `IncludeType`

The fourth generic type of a `JSONAPIDocument` is an `Include`. This type controls which types of `ResourceObject` are looked for when decoding the "included" part of the JSON API document. If you do not expect any included resource objects to be in the document, `NoIncludes` is the way to go. The `JSONAPI` framework provides `Include`s for up to 10 types of included resource objects. These are named `Include1`, `Include2`, `Include3`, and so on.

**IMPORTANT**: The number trailing "Include" in these type names does not indicate a number of included resource objects, it indicates a number of _types_ of included resource objects. `Include1` can be used to decode any number of included resource objects as long as all the resource objects are of the same _type_.

To specify that we expect friends of a person to be included in the above example `JSONAPIDocument`, we would use `Include1<Person>` instead of `NoIncludes`.

#### `APIDescriptionType`

The fifth generic type of a `JSONAPIDocument` is an `APIDescription`. The type represents the "JSON:API Object" described by the **SPEC**. This type describes the highest version of the **SPEC** supported and can carry additional metadata to describe the API.

You can specify this is not part of the document by using the `NoAPIDescription` type.

You can describe the API by a version with no metadata by using `APIDescription<NoMetadata>`.

You can supply any `JSONAPI.Meta` type as the metadata type of the API description.

#### `Error`

The final generic type of a `JSONAPIDocument` is the `Error`.

You can either create an error type that can handle all the errors you expect your `JSONAPIDocument` to be able to encode/decode or use an out-of-box error type described here. As prescribed by the **SPEC**, these errors will be found under the root document key `errors`.

##### `UnknownJSONAPIError`
The `UnknownJSONAPIError` type will always succeed in parsing errors but it will not give you any information about what error occurred. You will generally get more bang for your buck out of the next error type described.

##### `BasicJSONAPIError`
The `BasicJSONAPIError` type will always succeed unless it is faced with an `id` field of an unexpected type, although it still "succeeds" in falling back to its `.unknown` case when that happens. This type extracts _most_ of the fields the **SPEC** describes [here](https://jsonapi.org/format/#error-objects). Because all of these fields are optional in the **SPEC**, they are optional on the `BasicJSONAPIError` type. You will have to create your own error type if you want to define certain fields as non-optional or parse metadata or links out of error objects.

🗒Metadata and links are supported at the Document level for error responses, the are just not supported hanging off of the individual errors in the `errors` array of the response when using this error type.

The `BasicJSONAPIError` type is generic on one thing: The type it expects for the `id` field. If you expect integer `ids` back, you use `BasicJSONAPIError<Int>`. The same can be done for `String` or any other type that is both `Codable` and `Equatable`. You can even employ something like `AnyCodable` from *Flight-School* as your id field type. If you only need to handle a small subset of possible `id` field types, you can also use the `Poly` library that is already a dependency of `JSONAPI`. For example, you might expect a mix of `String` and `Int` ids for some reason: `BasicJSONAPIError<Either<Int, String>>`.

The two easiest ways to access the available properties of an error response are under the `payload` property of the error (this property is `nil` if the error was parsed as `.unknown`) or by asking the error for its `definedFields` dictionary.

As an example, let's say you have the following `Document` type that is destined for errors:
```swift
typealias ErrorDoc = JSONAPI.Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, BasicJSONAPIError<String>>
```
And you've parsed an error response
```swift
let errorResponse = try! JSONDecoder().decode(ErrorDoc.self, from: mockErrorData)
```
You can get at the `Document` body and errors in a couple of different ways, but for one you can switch on the body:
```swift
switch errorResponse.body {
case .data:
    print("cool, data!")

case .errors(let errors, let meta, let links):
    let errorDetails = errors.compactMap { $0.payload?.detail }

    print("error details: \(errorDetails)")
}
```

##### `GenericJSONAPIError`
This type makes it simple to use your own error payload structures as `JSONAPIError` types. Simply define a `Codable` and `Equatable` struct and then use `GenericJSONAPIError<YourType>` as the error type for a `Document`.

### `JSONAPI.Meta`

A `Meta` struct is totally open-ended. It is described by the **SPEC** as a place to put any information that does not fit into the standard JSON API Document structure anywhere else.

You can specify `NoMetadata` if the part of the document being described should not contain any `Meta`.

If you need to support metadata with structure that is not pre-determined, consider an "Any Codable" type such as that found at https://github.com/Flight-School/AnyCodable.

### `JSONAPI.Links`

A `Links` struct must contain only `Link` properties. Each `Link` property can either be a `URL` or a `URL` and some `Meta`. Each part of the document has some suggested common `Links` to include but generally any link can be included.

You can specify `NoLinks` if the part of the document being described should not contain any `Links`.

### `JSONAPI.RawIdType`

If you want to create new `JSONAPI.ResourceObject` values and assign them Ids then you will need to conform at least one type to `CreatableRawIdType`. Doing so is easy; here are two example conformances for `UUID` and `String` (via `UUID`):
```swift
extension UUID: CreatableRawIdType {
	public static func unique() -> UUID {
		return UUID()
	}
}

extension String: CreatableRawIdType {
	public static func unique() -> String {
		return UUID().uuidString
	}
}
```

### Sparse Fieldsets
Sparse Fieldsets are currently supported when encoding only. When decoding, Sparse Fieldsets become tricker to support under the current types this library uses and it is assumed that clients will request one or maybe two sparse fieldset combinations for any given model at most so it can simply define the `JSONAPI` models needed to decode those subsets of all possible fields. A server, on the other hand, likely needs to support arbitrary combinations of sparse fieldsets and this library provides a mechanism for encoding those sparse fieldsets without too much extra footwork.

You can use sparse fieldsets on the primary resources(s) _and_ includes of a `JSONAPI.Document`.

There is a sparse fieldsets example included with this repository as a Playground page.

#### Supporting Sparse Fieldset Encoding
1. The `JSONAPI` `ResourceObjectDescription`'s `Attributes` struct must conform to `JSONAPI.SparsableAttributes` rather than `JSONAPI.Attributes`.
2. The `JSONAPI` `ResourceObjectDescription`'s `Attributes` struct must contain a `CodingKeys` enum that conforms to `JSONAPI.SparsableCodingKey` instead of `Swift.CodingKey`.
3. `typealiases` you may have created for `JSONAPI.Document` that allow you to decode Documents will not support the "encode-only" nature of sparse fieldsets. See the next section for `typealias` comparisons.
4. To create a sparse fieldset from a `ResourceObject` just call its `sparse(with: fields)` method and pass an array of `Attributes.CodingKeys` values you would like included in the encoding.
5. Initialize and encode a `Document` containing one or more sparse or full primary resource(s) and any number of sparse or full includes.

#### Sparse Fieldset `typealias` comparisons
You might have found a `typealias` like the following for encoding/decoding `JSONAPI.Document`s (note the primary resource body is a `JSONAPI.ResourceBody`):
```swift
typealias Document<PrimaryResourceBody: JSONAPI.ResourceBody, IncludeType: JSONAPI.Include> = JSONAPI.Document<PrimaryResourceBody, NoMetadata, NoLinks, IncludeType, NoAPIDescription, BasicJSONAPIError<String>>
```

In order to support sparse fieldsets (which are encode-only), the following companion `typealias` would be useful (note the primary resource body is a `JSONAPI.EncodableResourceBody`):
```swift
typealias SparseDocument<PrimaryResourceBody: JSONAPI.EncodableResourceBody, IncludeType: JSONAPI.Include> = JSONAPI.Document<PrimaryResourceBody, NoMetadata, NoLinks, IncludeType, NoAPIDescription, BasicJSONAPIError<String>>
```

### Custom Attribute or Relationship Key Mapping
There is not anything special going on at the `JSONAPI.Attributes` and `JSONAPI.Relationships` levels, so you can easily provide custom key mappings by taking advantage of `Codable`'s `CodingKeys` pattern. Here are two models that will encode/decode equivalently but offer different naming in your codebase:
```swift
public enum ResourceObjectDescription1: JSONAPI.ResourceObjectDescription {
	public static var jsonType: String { return "entity" }

	public struct Attributes: JSONAPI.Attributes {
		public let coolProperty: Attribute<String>
	}

	public typealias Relationships = NoRelationships
}

public enum ResourceObjectDescription2: JSONAPI.ResourceObjectDescription {
	public static var jsonType: String { return "entity" }

	public struct Attributes: JSONAPI.Attributes {
		public let wholeOtherThing: Attribute<String>

		enum CodingKeys: String, CodingKey {
			case wholeOtherThing = "coolProperty"
		}
	}

    public typealias Relationships = NoRelationships
}
```

### Custom Attribute Encode/Decode
You can safely provide your own encoding or decoding functions for your Attributes struct if you need to as long as you are careful that your encode operation correctly reverses your decode operation. Although this is generally not necessary, `AttributeType` provides a convenience method to make your decoding a bit less boilerplate ridden. This is what it looks like:
```swift
public enum ResourceObjectDescription1: JSONAPI.ResourceObjectDescription {
	public static var jsonType: String { return "entity" }

	public struct Attributes: JSONAPI.Attributes {
		public let property1: Attribute<String>
		public let property2: Attribute<Int>
		public let property3: Attribute<String>

		public let weirdThing: Attribute<String>

		enum CodingKeys: String, CodingKey {
			case property1
			case property2
			case property3
		}
	}

	public typealias Relationships = NoRelationships
}

extension ResourceObjectDescription1.Attributes {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		property1 = try .defaultDecoding(from: container, forKey: .property1)
		property2 = try .defaultDecoding(from: container, forKey: .property2)
		property3 = try .defaultDecoding(from: container, forKey: .property3)

		weirdThing = .init(value: "hello world")
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(property1, forKey: .property1)
		try container.encode(property2, forKey: .property2)
		try container.encode(property3, forKey: .property3)
	}
}
```

### Meta-Attributes
This advanced feature may not ever be useful, but if you find yourself in the situation of dealing with an API that does not 100% follow the **SPEC** then you might find meta-attributes are just the thing to make your resource objects more natural to work with.

Suppose, for example, you are presented with the unfortunate situation where a piece of information you need is only available as part of the `Id` of a resource object. Perhaps a user's `Id` is formatted "{integer}-{createdAt}" where "createdAt" is the unix timestamp when the user account was created. The following `UserDescription` will expose what you need as an attribute. Realistically, the following example code is still terrible for its error handling. Using a `Result` type and/or invariants would clean things up substantially.

```swift
enum UserDescription: ResourceObjectDescription {
	public static var jsonType: String { return "users" }

	struct Attributes: JSONAPI.Attributes {
		var createdAt: (User) -> Date {
			return { user in
				let components = user.id.rawValue.split(separator: "-")

				guard components.count == 2 else {
					assertionFailure()
					return Date()
				}

				let timestamp = TimeInterval(components[1])

				guard let date = timestamp.map(Date.init(timeIntervalSince1970:)) else {
					assertionFailure()
					return Date()
				}

				return date
			}
		}
	}

	typealias Relationships = NoRelationships
}

typealias User = JSONAPI.ResourceObject<UserDescription, NoMetadata, NoLinks, String>
```

Given a value `user` of the above resource object type, you can access the `createdAt` attribute just like you would any other:

```swift
let createdAt = user.createdAt
```

This works because `createdAt` is defined in the form: `var {name}: ({ResourceObject}) -> {Value}` where `{ResourceObject}` is the `JSONAPI.ResourceObject` described by the `ResourceObjectDescription` containing the meta-attribute.

### Meta-Relationships
This advanced feature may not ever be useful, but if you find yourself in the situation of dealing with an API that does not 100% follow the **SPEC** then you might find meta-relationships are just the thing to make your resource objects more natural to work with.

Similarly to Meta-Attributes, Meta-Relationships allow you to represent non-compliant relationships as computed relationship properties. In the following example, a relationship is created from some attributes on the JSON model.

```swift
enum UserDescription: ResourceObjectDescription {
	public static var jsonType: String { return "users" }

	struct Attributes: JSONAPI.Attributes {
		let friend_id: Attribute<String>
	}

	struct Relationships: JSONAPI.Relationships {
		public var friend: (User) -> User.Identifier {
			return { user in
				return User.Identifier(rawValue: user.friend_id)
			}
		}
	}
}

typealias User = JSONAPI.ResourceObject<UserDescription, NoMetadata, NoLinks, String>
```

Given a value `user` of the above resource object type, you can access the `friend` relationship just like you would any other:

```swift
let friendId = user ~> \.friend
```

This works because `friend` is defined in the form: `var {name}: ({ResourceObject}) -> {Identifier}` where `{ResourceObject}` is the `JSONAPI.ResourceObject` described by the `ResourceObjectDescription` containing the meta-relationship.

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
typealias Document<PrimaryResourceBody: JSONAPI.ResourceBody, IncludeType: JSONAPI.Include> = JSONAPI.Document<PrimaryResourceBody, NoMetadata, NoLinks, IncludeType, NoAPIDescription, BasicJSONAPIError<String>>

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

# JSONAPI+Testing
The `JSONAPI` framework is packaged with a test library to help you test your `JSONAPI` integration.

The test library is called `JSONAPITesting`. It provides literal expressibility for `Attribute`, `ToOneRelationship`, and `Id` in many situations so that you can easily write test `ResourceObject` values into your unit tests. It also provides a `check()` function for each `ResourceObject` type that can be used to catch problems with your `JSONAPI` structures that are not caught by Swift's type system.

You can see the `JSONAPITesting` in action in the Playground included with the `JSONAPI` repository.

# JSONAPI+Arbitrary
This library has moved into its own Package. See https://github.com/mattpolzin/JSONAPI-Arbitrary for more information.

# JSONAPI+OpenAPI
The `JSONAPI+OpenAPI` library generates OpenAPI compliant JSON Schema for models built with the `JSONAPI` library. If your Swift code is your preferred source of truth for API information, this is an easy way to document the response schemas of your API.

`JSONAPI+OpenAPI` also has experimental support for generating `JSONAPI` Swift code from Open API documentation (this currently lives on the `feature/gen-swift` branch).

See https://github.com/mattpolzin/JSONAPI-OpenAPI for more information.
