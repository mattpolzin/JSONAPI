# JSONAPI

A Swift package for encoding and decoding to *JSON API* compliant requests and responses.

See the JSON API Spec here: https://jsonapi.org/format/

## Primary Goals

The primary goals of this framework are:
1. Allow creation of Swift types that are easy to use in code but also can be encoded to- or decoded from *JSON API* compliant payloads without lots of boilerplate code.
2. Leverage `Codable` to avoid additional outside dependencies and get operability with non-JSON encoders/decoders for free.
3. Do not sacrifice type safety.

## Project Status

### Decoding
#### Document
- [x] `data`
- [x] `included`
- [x] `errors` (untested)
- [ ] `meta`
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
- [ ] `data`
- [ ] `included`
- [ ] `errors`
- [ ] `meta`
- [ ] `jsonapi`
- [ ] `links`

#### Resource Object
- [x] `id` (untested)
- [x] `type` (untested)
- [x] `attributes` (untested)
- [x] `relationships` (untested)
- [ ] `links`
- [ ] `meta`

#### Relationship Object
- [x] `data` (untested)
- [ ] `links`
- [ ] `meta`

### Misc
- [ ] `EntityType` validator (using reflection).
- [ ] Property-based testing (using `SwiftCheck`).

## Usage
### Prerequisites
1. Swift 4.2+ and Swift Package Manager

### `EntityDescription`

An `EntityDescription` is the `JSONAPI` framework's specification for what the JSON API spec calls a *Resource Objects*. You might create the following `EntityDescription` to represent a person in a network of friends:

```
enum PersonDescription: IdentifiedEntityDescription {
	static var type: String { return "people" }

	typealias Identifier = Id<String, PersonDescription>

	struct Attributes: JSONAPI.Attributes {
		let name: [String]
		let favoriteColor: String
	}

	struct Relationships: JSONAPI.Relationships {
		let friends: ToManyRelationship<PersonDescription>
	}
}
```

Note that an `enum` type is used here; it could have been a `struct`, but `EntityDescription`s do not ever need to be created so an `enum` with no `case`s is a nice fit for the job.

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

Once you have an `EntityDescription`, you _create_, _encode_, and _decode_ `Entity`s that "fit the description". If you have a `CreatableRawIdType` (see the section on `RawIdType`s below) then you can create new `Entity<PersonDescription>`s, but even without a `CreatableRawIdType` you can decode and work with entities.

The `Entity` and `EntityDescription` together embody the rules and properties of a JSON API *Resource Object*.

It can be nice to create a `typealias` for each type of entity you want to work with:

```
typealias Person = Entity<PersonDescription>
```

### `Relationships`

There are two types of `Relationship`s: `ToOneRelationship` and `ToManyRelationship`. An `EntityDescription`'s `Relationships` type can contain any number of `Relationship`s of either of these types. Do not store anything other than `Relationship`s in the `Relationships` type of an `EntityDescription`.

An entity that does not have relationships can be described by adding the following to an `EntityDescription`:
```
typealias Relationships = NoRelatives
```

`Relationship`s boil down to Ids of other entities. To access the Id of a related entity, you can use the shorthand `~>` operator with the `KeyPath` of the `Relationship` from which you want the Id. The friends of the above `Person` entity could be accessed as follows (type annotations for clarity):
```
let friendIds: [Person.Identifier] = person ~> \.friends
```

### `Attributes`

The `Attributes` of an `EntityDescription` can contain any JSON encodable/decodable types. This is the place to store all attributes of an entity.

An entity that does not have attributes can be described by adding the following to an `EntityDescription`:
```
typealias Attributes = NoAttributes
```

`Attributes` can be accessed via the `subscript` operator of the `Entity` type as follows:
```
let favoriteColor: String = person[\.favoriteColor]
```

### `JSONAPIDocument`

The entirety of a JSON API request or response is encoded or decoded from- or to a `JSONAPIDocument`. As an example, a JSON API response containing one `Person` and no included entities could be decoded as follows:
```
let decoder = JSONDecoder()

let responseStructure = JSONAPIDocument<SingleResourceBody<PersonDescription>, NoIncludes, BasicJSONAPIError>.self

let document = try decoder.decode(responseStructure, from: data)
```

#### `ResourceBody`

The first generic type of a `JSONAPIDocument` is a `ResourceBody`. This can either be a `SingleResourceBody` or a `ManyResourceBody`. You will find zero or one `Entity` values in a JSON API document that has a `SingleResourceBody` and you will find zero or more `Entity` values in a JSON API document that has a `ManyResourceBody`.

#### `IncludeDecoder`

The second generic type of a `JSONAPIDocument` is an `IncludeDecoder`. This type controls which types of `Entity` are looked for when decoding the "included" part of the JSON API document. If you do not expect any included entities to be in the document, `NoIncludes` is the way to go. The `JSONAPI` framework provides `IncludeDecoder`s for up to six types of included entities. These are named `Include1`, `Include2`, `Include3`, and so on.

To specify that we expect friends of a person to be included in the above example `JSONAPIDocument`, we would use `Include1<PersonDescription>` instead of `NoIncludes`.

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
