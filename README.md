# JSONAPI
[![MIT license](http://img.shields.io/badge/license-MIT-lightgrey.svg)](http://opensource.org/licenses/MIT) [![Swift 4.2](http://img.shields.io/badge/Swift-4.2-blue.svg)](https://swift.org) [![Build Status](https://app.bitrise.io/app/c8295b9589aa401e/status.svg?token=vzcyqWD5bQ4xqQfZsaVzNw&branch=master)](https://app.bitrise.io/app/c8295b9589aa401e)

A Swift package for encoding to- and decoding from *JSON API* compliant requests and responses.

See the JSON API Spec here: https://jsonapi.org/format/

## Primary Goals

The primary goals of this framework are:
1. Allow creation of Swift types that are easy to use in code but also can be encoded to- or decoded from *JSON API* compliant payloads without lots of boilerplate code.
2. Leverage `Codable` to avoid additional outside dependencies and get operability with non-JSON encoders/decoders for free.
3. Do not sacrifice type safety.
4. Be platform agnostic so that Swift code can be written once and used by both the client and the server.

## Project Status

### Decoding
#### Document
- [x] `data`
- [x] `included`
- [x] `errors`
- [x] `meta`
- [ ] `jsonapi`
- [ ] `links`

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

### Encoding
#### Document
- [x] `data`
- [x] `included`
- [x] `errors`
- [x] `meta`
- [ ] `jsonapi`
- [ ] `links`

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

### EntityDescription Validator (using reflection)
- [ ] Disallow optional array in `Attribute` and `Relationship` (should be empty array, not `null`).
- [ ] Only allow `Attribute` and `TransformAttribute` within `Attributes` struct.
- [ ] Only allow `ToManyRelationship` and `ToOneRelationship` within `Relationships` struct.

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

## Usage
### Prerequisites
1. Swift 4.2+ and Swift Package Manager

### `EntityDescription`

An `EntityDescription` is the `JSONAPI` framework's specification for what the JSON API spec calls a *Resource Object*. You might create the following `EntityDescription` to represent a person in a network of friends:

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
1. A static `var` "type" that matches the JSON type; The JSON spec requires every *Resource Object* to have a "type".
2. A `struct` of `Attributes` **- OR -** `typealias Attributes = NoAttributes`
3. A `struct` of `Relationships` **- OR -** `typealias Relationships = NoRelatives`

Note that an `enum` type is used here for the `EntityDescription`; it could have been a `struct`, but `EntityDescription`s do not ever need to be created so an `enum` with no `case`s is a nice fit for the job.

This readme doesn't go into detail on the JSON API Spec, but the following JSON API *Resource Object* would be described by the above `PersonDescription`:

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

Once you have an `EntityDescription`, you _create_, _encode_, and _decode_ `Entity`s that "fit the description". If you have a `CreatableRawIdType` (see the section on `RawIdType`s below) then you can create new `Entity`s that will automatically be given unique Ids, but even without a `CreatableRawIdType` you can encode, decode and work with entities.

The `Entity` and `EntityDescription` together embody the rules and properties of a JSON API *Resource Object*.

An `Entity` needs to be specialized on two generic types. The first is the `EntityDescription` described above. The second is the type of Id to use for the `Entity`.

#### `IdType`

An `IdType` packages up two pieces of information: A unique identifier of a given `RawIdType` and the `EntityDescription` of the type of entity the Id identifies. Having the `EntityDescription` type associated with the Id makes it easy to store all of your entities in a local hash broken out by `EntityDescription`; You can pass Ids around and always know where to look for the `Entity` to which the Id refers. `RawIdType`s are documented below.

#### Convenient `typealiases`

Often you can use one `RawIdType` for many if not all of your `Entities`. That means you can save yourself some boilerplate by using `typealias`es like the following:
```
public typealias Entity<Description: JSONAPI.EntityDescription> = JSONAPI.Entity<Description, Id<String, Description>>

public typealias NewEntity<Description: JSONAPI.EntityDescription> = JSONAPI.Entity<Description, Unidentified>
```

It can also be nice to create a `typealias` for each type of entity you want to work with:
```
typealias Person = Entity<PersonDescription>

typealias NewPerson = NewEntity<PersonDescription>
```

Note that I am assuming an unidentified person is a "new" person. I suspect that is generally an acceptable conflation because the only time JSON API spec allows a *Resource Object* to be encoded without an Id is when a client is requesting the given *Resource Object* be created by the server and the client wants the server to create the Id for that object.

### `Relationships`

There are two types of `Relationship`s: `ToOneRelationship` and `ToManyRelationship`. An `EntityDescription`'s `Relationships` type can contain any number of `Relationship`s of either of these types. Do not store anything other than `Relationship`s in the `Relationships` struct of an `EntityDescription`.

To describe a relationship that may be omitted (i.e. the key is not even present in the JSON object), you make the entire `ToOneRelationship` or `ToManyRelationship` optional. However, this is not recommended because you can also represent optional relationships as nullable which means the key is always present. A `ToManyRelationship` can naturally represent no related objects exist with an empty array, so `ToManyRelationship` does not support nullability at all. A `ToOneRelationship` can be marked as nullable (i.e. the value might be `null` or it might be a resource identifier) like this:
```
let nullableRelative: ToOneRelationship<Person?>
```

An entity that does not have relationships can be described by adding the following to an `EntityDescription`:
```
typealias Relationships = NoRelatives
```

`Relationship`s boil down to Ids of other entities. To access the Id of a related entity, you can use the shorthand `~>` operator with the `KeyPath` of the `Relationship` from which you want the Id. The friends of the above `Person` entity could be accessed as follows (type annotations for clarity):
```
let friendIds: [Person.Identifier] = person ~> \.friends
```

### `Attributes`

The `Attributes` of an `EntityDescription` can contain any JSON encodable/decodable types as long as they are wrapped in an `Attribute` or `TransformAttribute` `struct`. This is the place to store all attributes of an entity.

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

Sometimes you need to use a type that does not encode or decode itself in the way you need to represent it as a serialized JSON object. For example, the Swift `Foundation` type `Date` can encode/decode itself to `Double` out of the box, but you might want to represent dates as ISO 8601 compliant `String`s instead. To do this, you create a `Transformer`.

A `Transformer` just provides one static function that transforms one type to another. You might define one for an ISO 8601 compliant `Date` like this:
```
enum ISODateTransformer: Transformer {
	public static func transform(_ from: String) throws -> Date {
		// parse Date out of input and return
	}
}
```

Then you define the attribute as a `TransformAttribute` instead of an `Attribute`:
```
let date: TransformAttribute<String, ISODateTransformer>
```

Note that the first generic parameter of `TransformAttribute` is the type you expect to decode from JSON, not the type you want to end up with after transformation.

### `JSONAPIDocument`

The entirety of a JSON API request or response is encoded or decoded from- or to a `JSONAPIDocument`. As an example, a JSON API response containing one `Person` and no included entities could be decoded as follows:
```
let decoder = JSONDecoder()

let responseStructure = JSONAPIDocument<SingleResourceBody<Person>, NoMetadata, NoIncludes, BasicJSONAPIError>.self

let document = try decoder.decode(responseStructure, from: data)
```

This document is guaranteed by the JSON API spec to be "data", "metadata", or "errors." If it is "data", it may also contain "metadata" and/or other "included" resources. If it is "errors," it may also contain "metadata."

#### `ResourceBody`

The first generic type of a `JSONAPIDocument` is a `ResourceBody`. This can either be a `SingleResourceBody` or a `ManyResourceBody`. You will find zero or one `Entity` values in a JSON API document that has a `SingleResourceBody` and you will find zero or more `Entity` values in a JSON API document that has a `ManyResourceBody`.

If you expect a response to not have a "data" top-level key at all, then use `NoResourceBody` instead.

#### `MetaType`

The second generic type of a `JSONAPIDocument` is a `Meta`. This structure is entirely open-ended. As an example, the JSON API document may contain the following pagination info in its meta entry:
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

#### `IncludeType`

The third generic type of a `JSONAPIDocument` is an `Include`. This type controls which types of `Entity` are looked for when decoding the "included" part of the JSON API document. If you do not expect any included entities to be in the document, `NoIncludes` is the way to go. The `JSONAPI` framework provides `Include`s for up to six types of included entities. These are named `Include1`, `Include2`, `Include3`, and so on.

**IMPORTANT**: The number trailing "Include" in these type names does not indicate a number of included entities, it indicates a number of _types_ of included entities. `Include1` can be used to decode any number of included entities as long as all the entities are of the same _type_.

To specify that we expect friends of a person to be included in the above example `JSONAPIDocument`, we would use `Include1<Person>` instead of `NoIncludes`.

#### `Error`

The final generic type of a `JSONAPIDocument` is the `Error`. You should create an error type that can decode all the errors you expect your `JSONAPIDocument` to be able to decode. As prescribed by the JSON API Spec, these errors will be found in the root document member `errors`.

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
