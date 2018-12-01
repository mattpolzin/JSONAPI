# JSONAPI
[![MIT license](http://img.shields.io/badge/license-MIT-lightgrey.svg)](http://opensource.org/licenses/MIT) [![Swift 4.2](http://img.shields.io/badge/Swift-4.2-blue.svg)](https://swift.org) [![Build Status](https://app.bitrise.io/app/c8295b9589aa401e/status.svg?token=vzcyqWD5bQ4xqQfZsaVzNw&branch=master)](https://app.bitrise.io/app/c8295b9589aa401e)

A Swift package for encoding to- and decoding from **JSON API** compliant requests and responses.

See the JSON API Spec here: https://jsonapi.org/format/

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
1. Swift 4.2+ and Swift Package Manager

### Xcode project
To create an Xcode project for JSONAPI, run
`swift package generate-xcodeproj`

### Running the Playground
To run the included Playground files, create an Xcode project using Swift Package Manager, then create an Xcode Workspace in the root of the repository and add both the generated Xcode project and the playground to the Workspace.

Note that Playground support for importing non-system Frameworks is still a bit touchy as of Swift 4.2. Sometimes building, cleaning and building, or commenting out and then uncommenting import statements (especially in the Entities.swift Playground Source file) can get things working for me when I am getting an error about JSONAPI not being found.

## Project Status

### Decoding
#### Document
- [x] `data`
- [x] `included`
- [x] `errors`
- [x] `meta`
- [ ] `jsonapi`
- [x] `links`

#### Resource Object
- [x] `id`
- [x] `type`
- [x] `attributes`
- [x] `relationships`
- [ ] `links`
- [ ] `meta`

#### Relationship Object
- [x] `data`
- [ ] `links`
- [ ] `meta`

#### Links Object
- [x] `href`
- [x] `meta`

### Encoding
#### Document
- [x] `data`
- [x] `included`
- [x] `errors`
- [x] `meta`
- [ ] `jsonapi`
- [x] `links`

#### Resource Object
- [x] `id`
- [x] `type`
- [x] `attributes`
- [x] `relationships`
- [ ] `links`
- [ ] `meta`

#### Relationship Object
- [x] `data`
- [ ] `links`
- [ ] `meta`

#### Links Object
- [x] `href`
- [x] `meta`

### Entity Validator (using reflection)
- [x] Disallow optional array in `Attribute` (should be empty array, not `null`).
- [x] Only allow `TransformedAttribute` and its derivatives within `Attributes` struct.
- [x] Only allow `ToManyRelationship` and `ToOneRelationship` within `Relationships` struct.

### Strict Decoding/Encoding Settings
- [ ] Error (potentially while still encoding/decoding successfully) if an included entity is not related to a primary entity (Turned off by default).

### Misc
- [x] Support transforms on `Attributes` values (e.g. to support different representations of `Date`)
- [x] Support ability to distinguish between `Attributes` fields that are optional (i.e. the key might not be there) and `Attributes` values that are optional (i.e. the key is guaranteed to be there but it might be `null`).
- [x] Fix `ToOneRelationship` so that it is possible to specify an optional relationship where the value is `null` rather than the key being omitted.
- [x] Conform to `CustomStringConvertible`
- [x] More tests around failing to decode improperly structured JSON (not bad JSON, but JSON that is not to spec)
- [ ] Use `KeyPath` to specify `Includes` thus creating type safety around the relationship between a primary resource type and the types of included resources????
- [x] For `NoIncludes`, do not even loop over the "included" JSON API section if it exists.
- [ ] Property-based testing (using `SwiftCheck`)
- [x] Roll my own `Result` or find an alternative that doesn't use `Foundation`.
- [ ] Create more descriptive errors that are easier to use for troubleshooting.
- [x] Make it easier to construct `Attributes` and `Relationships` values in test cases (literal expressibility).
- [x] Make `TransformedAttribute` a Functor.

## Usage

In this documentation, in order to draw attention to the difference between the `JSONAPI` framework (this Swift library) and the **JSON API Spec** (the specification this library helps you follow), the specification will consistently be referred to below as simply the **SPEC**.

### `EntityDescription`

An `EntityDescription` is the `JSONAPI` framework's representation of what the **SPEC** calls a *Resource Object*. You might create the following `EntityDescription` to represent a person in a network of friends:

```
enum PersonDescription: IdentifiedEntityDescription {
	static var type: String { return "people" }

	struct Attributes: JSONAPI.Attributes {
		let name: Attribute<[String]>
		let favoriteColor: Attribute<String>
	}

	struct Relationships: JSONAPI.Relationships {
		let friends: ToManyRelationship<Person>
	}
}
```

The requirements of an `EntityDescription` are:
1. A static `var` "type" that matches the JSON type; The **SPEC** requires every *Resource Object* to have a "type".
2. A `struct` of `Attributes` **- OR -** `typealias Attributes = NoAttributes`
3. A `struct` of `Relationships` **- OR -** `typealias Relationships = NoRelationships`

Note that an `enum` type is used here for the `EntityDescription`; it could have been a `struct`, but `EntityDescription`s do not ever need to be created so an `enum` with no `case`s is a nice fit for the job.

This readme doesn't go into detail on the **SPEC**, but the following *Resource Object* would be described by the above `PersonDescription`:

```
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

### `Entity`

Once you have an `EntityDescription`, you _create_, _encode_, and _decode_ `Entities` that "fit the description". If you have a `CreatableRawIdType` (see the section on `RawIdType`s below) then you can create new `Entities` that will automatically be given unique Ids, but even without a `CreatableRawIdType` you can encode, decode and work with entities.

The `Entity` and `EntityDescription` together embody the rules and properties of a JSON API *Resource Object*.

#### `IdType`

An `Entity` needs to be specialized on two generic types. The first is the `EntityDescription` described above. The second is the raw type of `Id` to use for the `Entity`. The actual `Id` of the `Entity` will not be a `RawIdType`, though. The `Id` will package a value of `RawIdType` with a specialized reference back to the `Entity` type it identifies. This just looks like `Id<RawIdType, Entity<EntityDescription, RawIdType>>`.

Having the `Entity` type associated with the `Id` makes it easy to store all of your entities in a hash broken out by `Entity` type; You can pass `Ids` around and always know where to look for the `Entity` to which the `Id` refers.

A `RawIdType` is the underlying type that uniquely identifies an `Entity`. This is often a `String` or a `UUID`.

#### Convenient `typealiases`

Often you can use one `RawIdType` for many if not all of your `Entities`. That means you can save yourself some boilerplate by using `typealias`es like the following:
```
public typealias Entity<Description: JSONAPI.EntityDescription> = JSONAPI.Entity<Description, String>

public typealias NewEntity<Description: JSONAPI.EntityDescription> = JSONAPI.Entity<Description, Unidentified>
```

It can also be nice to create a `typealias` for each type of entity you want to work with:
```
typealias Person = Entity<PersonDescription>

typealias NewPerson = NewEntity<PersonDescription>
```

Note that I am assuming an unidentified person is a "new" person. I suspect that is generally an acceptable conflation because the only time the **SPEC** allows a *Resource Object* to be encoded without an `Id` is when a client is requesting the given *Resource Object* be created by the server and the client wants the server to create the `Id` for that object.

### `Relationships`

There are two types of `Relationships`: `ToOneRelationship` and `ToManyRelationship`. An `EntityDescription`'s `Relationships` type can contain any number of `Relationship` properties of either of these types. Do not store anything other than `Relationship` properties in the `Relationships` struct of an `EntityDescription`.

To describe a relationship that may be omitted (i.e. the key is not even present in the JSON object), you make the entire `ToOneRelationship` or `ToManyRelationship` optional. However, this is not recommended because you can also represent optional relationships as nullable which means the key is always present. A `ToManyRelationship` can naturally represent the absence of related values with an empty array, so `ToManyRelationship` does not support nullability at all. A `ToOneRelationship` can be marked as nullable (i.e. the value might be `null` or it might be a resource identifier) like this:
```
let nullableRelative: ToOneRelationship<Person?>
```

An entity that does not have relationships can be described by adding the following to an `EntityDescription`:
```
typealias Relationships = NoRelationships
```

`Relationship` values boil down to `Ids` of other entities. To access the `Id` of a related `Entity`, you can use the custom `~>` operator with the `KeyPath` of the `Relationship` from which you want the `Id`. The friends of the above `Person` `Entity` can be accessed as follows (type annotations for clarity):
```
let friendIds: [Person.Identifier] = person ~> \.friends
```

### `Attributes`

The `Attributes` of an `EntityDescription` can contain any JSON encodable/decodable types as long as they are wrapped in an `Attribute`, `ValidatedAttribute`, or `TransformedAttribute` `struct`.

To describe an attribute that may be omitted (i.e. the key might not even be in the JSON object), you make the entire `Attribute` optional:
```
let optionalAttribute: Attribute<String>?
```

To describe an attribute that is expected to exist but might have a `null` value, you make the value within the `Attribute` optional:
```
let nullableAttribute: Attribute<String?>
```

An entity that does not have attributes can be described by adding the following to an `EntityDescription`:
```
typealias Attributes = NoAttributes
```

`Attributes` can be accessed via the `subscript` operator of the `Entity` type as follows:
```
let favoriteColor: String = person[\.favoriteColor]
```

#### `Transformer`

Sometimes you need to use a type that does not encode or decode itself in the way you need to represent it as a serialized JSON object. For example, the Swift `Foundation` type `Date` can encode/decode itself to `Double` out of the box, but you might want to represent dates as ISO 8601 compliant `String`s instead. The Foundation library `JSONDecoder` has a setting to make this adjustment, but for the sake of an example, you could create a `Transformer`.

A `Transformer` just provides one static function that transforms one type to another. You might define one for an ISO 8601 compliant `Date` like this:
```
enum ISODateTransformer: Transformer {
	public static func transform(_ value: String) throws -> Date {
		// parse Date out of input and return
	}
}
```

Then you define the attribute as a `TransformedAttribute` instead of an `Attribute`:
```
let date: TransformedAttribute<String, ISODateTransformer>
```

Note that the first generic parameter of `TransformAttribute` is the type you expect to decode from JSON, not the type you want to end up with after transformation.

If you make your `Transformer` a `ReversibleTransformer` then your life will be a bit easier when you construct `TransformedAttributes` because you have access to initializers for both the pre- and post-transformed value types. Continuing with the above example of a `ISODateTransformer`:
```
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

You can add computed properties to your `EntityDescription.Attributes` struct if you would like to expose attributes that are not explicitly represented by the JSON. These computed properties should still have the type `Attribute` because that way you can take advantage of the quick access provided by `Entity`'s subscript operator. Here's an example of how you might take the `Person[\.name]` attribute from the example above and create a `fullName` computed property.

```
public var fullName: Attribute<String> {
	return name.map { $0.joined(separator: " ") }
}
```

### `JSONAPIDocument`

The entirety of a JSON API request or response is encoded or decoded from- or to a `JSONAPIDocument`. As an example, a JSON API response containing one `Person` and no included entities could be decoded as follows:
```
let decoder = JSONDecoder()

let responseStructure = JSONAPIDocument<SingleResourceBody<Person>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self

let document = try decoder.decode(responseStructure, from: data)
```

A JSON API Document is guaranteed by the **SPEC** to be "data", "metadata", or "errors." If it is "data", it may also contain "metadata" and/or other "included" resources. If it is "errors," it may also contain "metadata."

#### `ResourceBody`

The first generic type of a `JSONAPIDocument` is a `ResourceBody`. This can either be a `SingleResourceBody<PrimaryResource>` or a `ManyResourceBody<PrimaryResource>`. You will find zero or one `PrimaryResource` values in a JSON API document that has a `SingleResourceBody` and you will find zero or more `PrimaryResource` values in a JSON API document that has a `ManyResourceBody`. You can use the `Poly` types (`Poly1` through `Poly6`) to specify that a `ResourceBody` will be one of a few different types of `Entity`. These `Poly` types work in the same way as the `Include` types described below.

If you expect a response to not have a "data" top-level key at all, then use `NoResourceBody` instead.

##### nullable `PrimaryResource`

If you expect a `SingleResourceBody` to sometimes come back `null`, you should make your `PrimaryResource` optional. If you do not make your `PrimaryResource` optional then a `null` primary resource will be considered an error when parsing the JSON.

You cannot, however, use an optional `PrimaryResource` with a `ManyResourceBody` because the **SPEC** requires that an empty document in that case be represented by an empty array rather than `null`.

#### `MetaType`

The second generic type of a `JSONAPIDocument` is a `Meta`. This structure is entirely open-ended. As an example, the JSON API document could, as an example, contain the following pagination info in its meta entry:
```
{
	"meta": {
		"total": 100,
		"limit": 50,
		"offset": 50
	}
}
```

You would then create the following `Meta` type:
```
struct PageMetadata: JSONAPI.Meta {
	let total: Int
	let limit: Int
	let offset: Int
}
```

You can always use `NoMetadata` if this JSON API feature is not needed.

#### `LinksType`

The third generic type of a `JSONAPIDocument` is a `Links` struct. A `Links` struct must contain only `Link` properties. Each `Link` property can either be a `URL` or a `URL` and some `Meta`.

You can specify `NoLinks` if the document should not contain any links.

#### `IncludeType`

The fourth generic type of a `JSONAPIDocument` is an `Include`. This type controls which types of `Entity` are looked for when decoding the "included" part of the JSON API document. If you do not expect any included entities to be in the document, `NoIncludes` is the way to go. The `JSONAPI` framework provides `Include`s for up to six types of included entities. These are named `Include1`, `Include2`, `Include3`, and so on.

**IMPORTANT**: The number trailing "Include" in these type names does not indicate a number of included entities, it indicates a number of _types_ of included entities. `Include1` can be used to decode any number of included entities as long as all the entities are of the same _type_.

To specify that we expect friends of a person to be included in the above example `JSONAPIDocument`, we would use `Include1<Person>` instead of `NoIncludes`.

#### `Error`

The final generic type of a `JSONAPIDocument` is the `Error`. You should create an error type that can decode all the errors you expect your `JSONAPIDocument` to be able to decode. As prescribed by the **SPEC**, these errors will be found in the root document member `errors`.

### `RawIdType`

If you want to create new `JSONAPI.Entity` values and assign them Ids then you will need to conform at least one type to `CreatableRawIdType`. Doing so is easy; here are two example conformances for `UUID` and `String` (via `UUID`):
```
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

# JSONAPITestLib
The `JSONAPI` framework is packaged with a test library to help you test your `JSONAPI` integration. The test library is called `JSONAPITestLib`. It provides literal expressibility for `Attribute`, `ToOneRelationship`, and `Id` in many situations so that you can easily write test `Entity` values into your unit tests. It also provides a `check()` function for each `Entity` type that can be used to catch problems with your `JSONAPI` structures that are not caught by Swift's type system. You can see the `JSONAPITestLib` in action in the Playground included with the `JSONAPI` repository.
