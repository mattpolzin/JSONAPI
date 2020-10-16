
## Usage <!-- omit in toc -->

In this documentation, in order to draw attention to the difference between the `JSONAPI` framework (this Swift library) and the **JSON API Spec** (the specification this library helps you follow), the specification will consistently be referred to below as simply the **SPEC**.

- [`JSONAPI.ResourceObjectDescription`](#jsonapiresourceobjectdescription)
- [`JSONAPI.ResourceObject`](#jsonapiresourceobject)
	- [`Meta`](#meta)
	- [`Links`](#links)
	- [`MaybeRawId`](#mayberawid)
		- [`RawIdType`](#rawidtype)
	- [Convenient `typealiases`](#convenient-typealiases)
- [`JSONAPI.Relationships`](#jsonapirelationships)
	- [Relationship Metadata](#relationship-metadata)
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
	- [`SuccessDocument` and `ErrorDocument`](#successdocument-and-errordocument)
- [`CompoundResource`](#compoundresource)
- [`JSONAPI.Meta`](#jsonapimeta)
- [`JSONAPI.Links`](#jsonapilinks)
- [`JSONAPI.RawIdType`](#jsonapirawidtype)
- [Sparse Fieldsets](#sparse-fieldsets)
	- [Supporting Sparse Fieldset Encoding](#supporting-sparse-fieldset-encoding)
	- [Sparse Fieldset `typealias` comparisons](#sparse-fieldset-typealias-comparisons)
- [Replacing and Tapping Attributes/Relationships](#replacing-and-tapping-attributesrelationships)
	- [Tapping](#tapping)
	- [Replacing](#replacing)
- [Custom Attribute or Relationship Key Mapping](#custom-attribute-or-relationship-key-mapping)
- [Custom Attribute Encode/Decode](#custom-attribute-encodedecode)
- [Meta-Attributes](#meta-attributes)
- [Meta-Relationships](#meta-relationships)

### `JSONAPI.ResourceObjectDescription`

A `ResourceObjectDescription` is the `JSONAPI` framework's definition of the attributes and relationships of what the **SPEC** calls a *Resource Object*. You might create the following `ResourceObjectDescription` to represent a person in a network of friends:

```swift
enum PersonDescription: ResourceObjectDescription {
	static let jsonType: String = "people"

	struct Attributes: JSONAPI.Attributes {
		let name: Attribute<[String]>
		let favoriteColor: Attribute<String>
	}

	struct Relationships: JSONAPI.Relationships {
		let friends: ToManyRelationship<Person, NoIdMetadata, NoMetadata, NoLinks>
	}
}
```

The requirements of a `ResourceObjectDescription` are:
1. A static `var` (or `let`) "jsonType" that matches the JSON type; The **SPEC** requires every *Resource Object* to have a "type".
2. A `struct` of `Attributes` **- OR -** `typealias Attributes = NoAttributes`
3. A `struct` of `Relationships` **- OR -** `typealias Relationships = NoRelationships`

Note that an `enum` type was used above for the `PersonDescription`; it could have been a `struct`, but `ResourceObjectDescriptions` do not ever need to be created so an `enum` with no `cases` is a nice fit for the job.

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

Once you have a `ResourceObjectDescription`, you _create_, _encode_, and _decode_ `ResourceObjects` that "fit the description." If you have a `CreatableRawIdType` (see the section on `RawIdType`s below) then you can create new `ResourceObjects` that will automatically be given unique Ids, but even without a `CreatableRawIdType` you can encode, decode and work with resource objects.

The `ResourceObject` and `ResourceObjectDescription` together with a `JSONAPI.Meta` type and a `JSONAPI.Links` type embody the rules and properties of a JSON API *Resource Object*.

A `ResourceObject` needs to be specialized on four generic types. The first is the `ResourceObjectDescription` described above. The others are a `Meta`, `Links`, and `MaybeRawId`.

#### `Meta`

This is described in its own section [below](#jsonapimeta). All `Meta` at any level of a JSON API Document follow the same rules. You can use `NoMetadata` if you do not need to package any metadata with the `ResourceObject`.

#### `Links`

This is described in its own section [below](#jsonnapilinks). All `Links` at any level of a JSON API Document follow the same rules, although the **SPEC** makes different suggestions as to what types of links might live on which parts of the Document. You can use `NoLinks` if you do not need to package any links with the `ResourceObject`.

#### `MaybeRawId`

The last generic specialization on `ResourceObject` is `MaybeRawId`. This is either a `RawIdType` that can be used to uniquely identify `ResourceObjects` or it is `Unidentified` which is used to indicate a `ResourceObject` does not have an `Id`; it is useful to create unidentified resources when a client is requesting that the server create a `ResourceObject` and assign it a new `Id`.

##### `RawIdType`

The raw type of `Id` to use for the `ResourceObject`. The actual `Id` of the `ResourceObject` will not be a `RawIdType`, though. The `Id` will package a value of `RawIdType` with a specialized reference back to the `ResourceObject` type it identifies. This just looks like `Id<RawIdType, ResourceObject<ResourceObjectDescription, Meta, Links, RawIdType>>`.

Having the `ResourceObject` type associated with the `Id` makes it easy to store all of your resource objects in a hash broken out by `ResourceObject` type; You can pass `Ids` around and always know where to look for the `ResourceObject` to which the `Id` refers. This encapsulation provides some type safety because the Ids of two `ResourceObjects` with the "raw ID" of `"1"` but different types will not compare as equal.

A `RawIdType` is the underlying type that uniquely identifies a `ResourceObject`. This is often a `String` or a `UUID`.

#### Convenient `typealiases`

Often you can use one `RawIdType` for many if not all of your `ResourceObjects`. That means you can save yourself some boilerplate by using `typealiases` like the following:
```swift
public typealias ResourceObject<Description: JSONAPI.ResourceObjectDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.ResourceObject<Description, Meta, Links, String>

public typealias NewResourceObject<Description: JSONAPI.ResourceObjectDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.ResourceObject<Description, Meta, Links, Unidentified>
```

It can also be nice to create a `typealias` for each type of resource object you want to work with:
```swift
typealias Person = ResourceObject<PersonDescription, NoMetadata, NoLinks>

typealias NewPerson = NewResourceObject<PersonDescription, NoMetadata, NoLinks>
```

Note that I am calling an unidentified person is a "new" person. This is generally an acceptable conflation in naming because the only time the **SPEC** allows a *Resource Object* to be encoded without an `Id` is when a client is requesting the given *Resource Object* be created by the server and the client wants the server to create the `Id` for that object.

### `JSONAPI.Relationships`

There are three types of `Relationships`: `MetaRelationship`, `ToOneRelationship` and `ToManyRelationship`. A `ResourceObjectDescription`'s `Relationships` type can contain any number of `Relationship` properties of any of these types. Do not store anything other than `Relationship` properties in the `Relationships` struct of a `ResourceObjectDescription`.

The `MetaRelationship` is special in that it represents a Relationship Object with no `data` (it must contain at least one of `meta` or `links`). The other two relationship types are Relationship Objects with either singular resource linkages (`ToOneRelationship`) or arrays of resource linkages (`ToManyRelationship`).

To describe a relationship that may be omitted (i.e. the key is not even present in the JSON object), you make the entire `MetaRelationship`, `ToOneRelationship` or `ToManyRelationship` optional. 
```swift
// note the question mark at the very end of the line.
let optionalRelative: ToOneRelationship<Person, NoIdMetadata, NoMetadata, NoLinks>?
```

A `ToOneRelationship` can be marked as nullable (i.e. the value could be either `null` or a resource identifier) like this:
```swift
// note the question mark just after `Person`.
let nullableRelative: ToOneRelationship<Person?, NoIdMetadata, NoMetadata, NoLinks>
```

A `ToManyRelationship` can naturally represent the absence of related values with an empty array, so `ToManyRelationship` do not support nullability.

A `ResourceObject` that does not have relationships can be described by adding the following to a `ResourceObjectDescription`:
```swift
typealias Relationships = NoRelationships
```

`Relationship` values boil down to `Ids` of other resource objects. To access the `Id` of a related `ResourceObject`, you can use the custom `~>` operator with the `KeyPath` of the `Relationship` from which you want the `Id`. The friends of the above `Person` `ResourceObject` can be accessed as follows (type annotations for clarity):
```swift
let friendIds: [Person.Id] = person ~> \.friends
```

🗒You will likely find relationship types more ergonomic and easier to read if you create typealiases. For example, if your project never uses Relationship metadata or links, you can create a typealias like `typealias ToOne<T: JSONAPI.JSONAPIIdentifiable> = JSONAPI.ToOneRelationship<T, NoIdMetadata, NoMetadata, NoLinks>`.

#### Relationship Metadata
In addition to identifying resource objects by ID and type, `Relationships` can contain `Meta` or `Links` that follow the same rules as [`Meta`](#jsonapimeta) and [`Links`](#jsonapilinks) elsewhere in the JSON:API Document.

Metadata can be specified both in the Relationship Object and in the Resource Identifier Object. You specify the two types of metadata differently. As always, you can use `NoMetadata` to indicate you do not intend the JSON:API relationship to contain metadata.

```swift
// No metadata in the Resource Identifer or the Relationship:
// {
//   "data" : {
//     "id" : "1234",
//     "type": "people"
//   }
// }
let relationship1: ToOneRelationship<Person, NoIdMetadata, NoMetadata, NoLinks>

// No metadata in the Resource Identifier but some metadata in the Relationship:
// {
//   "data" : {
//     "id" : "1234",
//     "type": "people"
//   },
//   "meta": { ... }
// }
let relationship2: ToOneRelationship<Person, NoIdMetadata, RelMetadata, NoLinks>
// ^ assumes `RelMetadata` is a `Codable` struct defined elsewhere

// Metadata in the Resource Identifier but not the Relationship:
// {
//   "data" : {
//     "id" : "1234",
//     "type": "people",
//     "meta": { ... }
//   }
// }
let relationship3: ToOneRelationship<Person, CoolMetadata, NoMetadata, NoLinks>
// ^ assumes `CoolMetadata` is a `Codable` struct defined elsewhere
```

When you need metadata out of a to-one relationship, you can access the Relationship Object metadata with the `meta` property and the Resource Identifer metadata with the `idMeta` property. When you need metadata out of a to-many relationship, you can access the Relationship Object metadata with the `meta` property (there is only one such metadata object) and you can access the Resource Identifier metadata (of which there is one per related resource) by asking each element of the `idsWithMeta` property for its `meta` property.

```swift
// to-one
let relation = entity.relationships.home
let idMeta = relation.idMeta

// to-many
let relations = entity.relationships.friends
let idMeta = relations.idsWithMeta.map { $0.meta }
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
`ResourceObject` is a value type, so copying is its default behavior. There are three common mutations you might want to make when copying a `ResourceObject`:
1. Assigning a new `Id` to the copy of an identified `ResourceObject`.
2. Assigning a new `Id` to the copy of an unidentified `ResourceObject`.
3. Change attribute or relationship values.

The first two can be accomplished with code like the following:

```swift
// use case 1
let person1 = person.withNewIdentifier()

// use case 2
let newlyIdentifiedPerson1 = unidentifiedPerson.identified(byType: String.self)

let newlyIdentifiedPerson2 = unidentifiedPerson.identified(by: "2232")
```

The third use-case is described in [Replacing and Tapping Attributes/Relationships](#replacing-and-tapping-attributesrelationships).

### `JSONAPI.Document`

The entirety of a JSON API request or response is encoded or decoded from- or to a `Document`. As an example, a JSON API response containing one `Person` and no included resource objects could be decoded as follows:
```swift
let decoder = JSONDecoder()

let responseStructure = JSONAPI.Document<SingleResourceBody<Person>, NoMetadata, NoLinks, NoIncludes, BasicJSONAPIError<String>>.self

let document = try decoder.decode(responseStructure, from: data)
```

A JSON API Document is guaranteed by the **SPEC** to be "data", "metadata", or "errors." If it is "data", it may also contain "metadata" and/or other "included" resources. If it is "errors," it may also contain "metadata."

#### `ResourceBody`

The first generic type of a `JSONAPI.Document` is a `ResourceBody`. This can either be a `SingleResourceBody<PrimaryResource>` or a `ManyResourceBody<PrimaryResource>`. You will find zero or one `PrimaryResource` values in a JSON API document that has a `SingleResourceBody` and you will find zero or more `PrimaryResource` values in a JSON API document that has a `ManyResourceBody`. You can use the `Poly` types (`Poly1` through `Poly6`) to specify that a `ResourceBody` will be one of a few different types of `ResourceObject`. These `Poly` types work in the same way as the `Include` types described below.

If you expect a response to not have a "data" top-level key at all, then use `NoResourceBody` instead.

##### nullable `PrimaryResource`

If you expect a `SingleResourceBody` to sometimes come back `null`, you should make your `PrimaryResource` optional. If you do not make your `PrimaryResource` optional then a `null` primary resource will be considered an error when parsing the JSON.

You cannot, however, use an optional `PrimaryResource` with a `ManyResourceBody` because the **SPEC** requires that an empty document in that case be represented by an empty array rather than `null`.

#### `MetaType`

The second generic type of a `JSONAPI.Document` is a `Meta`. This `Meta` follows the same rules as `Meta` at any other part of a JSON API Document. It is described below in its own section, but as an example, the JSON API document could contain the following pagination info in its meta entry:
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

The third generic type of a `JSONAPI.Document` is a `Links` struct. `Links` are described in their own section [below](#jsonapilinks).

#### `IncludeType`

The fourth generic type of a `JSONAPI.Document` is an `Include`. This type controls which types of `ResourceObject` are looked for when decoding the "included" part of the JSON API document. If you do not expect any included resource objects to be in the document, `NoIncludes` is the way to go. The `JSONAPI` framework provides `Include`s for up to 10 types of included resource objects. These are named `Include1`, `Include2`, `Include3`, and so on.

**IMPORTANT**: The number trailing "Include" in these type names does not indicate a number of included resource objects, it indicates a number of _types_ of included resource objects. `Include1` can be used to decode any number of included resource objects as long as all the resource objects are of the same _type_.

Decoding a JSON:API Document will fail if you specify an `IncludeType` that does not cover all of the types of includes you expect a response to contain.

To specify that we expect friends of a person to be included in the above example `JSONAPI.Document`, we would use `Include1<Person>` instead of `NoIncludes`.

#### `APIDescriptionType`

The fifth generic type of a `JSONAPI.Document` is an `APIDescription`. The type represents the "JSON:API Object" described by the **SPEC**. This type describes the highest version of the **SPEC** supported and can carry additional metadata to describe the API.

You can specify this is not part of the document by using the `NoAPIDescription` type.

You can describe the API by a version with no metadata by using `APIDescription<NoMetadata>`.

You can supply any `JSONAPI.Meta` type as the metadata type of the API description.

#### `Error`

The final generic type of a `JSONAPI.Document` is the `Error`.

You can either create an error type that can handle all the errors you expect your `JSONAPI.Document` to be able to encode/decode or use an out-of-box error type described here. As prescribed by the **SPEC**, these errors will be found under the root document key `errors`.

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

#### `SuccessDocument` and `ErrorDocument`
The `Document` type also supplies two nested types that guarantee either a successful data document or error an error document. 

In general, if you want to encode or decode a document you will want the flexibility of representing either success or errors. When you know you will be working with one or the other in a particular context, `Document.SuccessDocument` and `Document.ErrorDocument` will provide additional convenience: they only expose relevant initializers (a success document cannot be initialized with errors), they only succeed to decode given the expected result, and success documents provide non-optional access to the `data` property that is normally optional on the `body`.

For example:
```swift
typealias Response = JSONAPI.Document<...>

let decoder = JSONDecoder()
let document = try decoder.decode(Response.SuccessDocument.self, from: ...)

// the following are non-optional because we know that if the document did not
// contain a `data` body (i.e. if it was an error response) then it would have
// failed to decode above.
let primaryResource = document.primaryResource
let includes = document.includes
```

### `CompoundResource`
`CompoundResource` packages a primary resource with relatives (stored using the same `Include` types that `Document` uses). The `CompoundResource` type can be a convenient way to package a resource and its relatives to be later turned into a `Document`; A single resource body for a document is a straight forward representation of a `CompoundResource`, but `Document` will take an array of `CompoundResources` and create a batch ("many") resource body containing all the primary resources and uniquely including each relative as required by the **SPEC**.

A single resource document:
```swift
typealias SinglePersonDocument = Document<SingleResourceBody<Person>, NoMetadata, NoLinks, Include1<Person>, NoAPIDescription, BasicJSONAPIError<String>>

let person: Person = ...
let friends: [Person] = ...
let friendIncludes = friends.map(SinglePersonDocument.Include.init)

let compoundResource = CompoundResource(primary: person, relatives: friendIncludes)

let document = SinglePersonDocument(
	apiDescription: .none,
	resource: compoundResource,
    meta: .none,
    links: .none
)
```

A batch resource document:
```swift
typealias ManyPersonDocument = Document<ManyResourceBody<Person>, NoMetadata, NoLinks, Include1<Person>, NoAPIDescription, BasicJSONAPIError<String>>

let people: [Person] = ...
let compoundResources = people.map { person in 
	let friends: [Person] = ...
	let friendIncludes = friends.map(SinglePersonDocument.Include.init)

	return CompoundResource(primary: person, relatives: friendIncludes)
}

let document = ManyPersonDocument(
	apiDescription: .none,
	resources: compoundResources,
    meta: .none,
    links: .none
)
```

### `JSONAPI.Meta`

A `Meta` struct is totally open-ended. It is described by the **SPEC** as a place to put any information that does not fit into the standard JSON API Document structure anywhere else.

You can specify `NoMetadata` if the part of the document being described should not contain any `Meta`.

If you need to support metadata with structure that is not pre-determined, consider an "Any Codable" type such as that found at https://github.com/Flight-School/AnyCodable.

### `JSONAPI.Links`

A `Links` struct must contain only `Link` properties. Each `Link` property can either be a `URL` or a `URL` and some `Meta`. Each part of the document has some suggested common `Links` to include but generally any link can be included.

You can specify `NoLinks` if the part of the document being described should not contain any `Links`.

**IMPORTANT:** The URL type used in links is a type conforming to `JSONAPIURL`. Any type that is both `Codable` and `Equatable` is eligible, but it must be conformed explicitly.

For example,
```swift
extension Foundation.URL: JSONAPIURL {}
extension String: JSONAPIURL {}
```

Here's an example of an "article" resource object with some links and the JSON it would be capable of parsing:
```swift
struct PersonStubDescription: JSONAPI.ResourceObjectDescription {
	// this is just a pretend model to be used in a relationship below.
    static let jsonType: String = "people"

    typealias Attributes = NoAttributes
    typealias Relationships = NoRelationships
}

typealias Person = JSONAPI.ResourceObject<PersonStubDescription, NoMetadata, NoLinks, String>

struct ArticleAuthorRelationshipLinks: JSONAPI.Links {
    let `self`: JSONAPI.Link<URL, NoMetadata>
    let related: JSONAPI.Link<URL, NoMetadata>
}

struct ArticleLinks: JSONAPI.Links {
    let `self`: JSONAPI.Link<URL, NoMetadata>
}

struct ArticleDescription: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "articles"

    struct Attributes: JSONAPI.Attributes {
        let title: Attribute<String>
    }

    struct Relationships: JSONAPI.Relationships {
        let author: ToOneRelationship<Person, NoIdMetadata, NoMetadata, ArticleAuthorRelationshipLinks>
    }
}

typealias Article = JSONAPI.ResourceObject<ArticleDescription, NoMetadata, ArticleLinks, String>
```
```json
{
    "type": "articles",
    "id": "1",
    "attributes": {
        "title": "Rails is Omakase"
    },
    "relationships": {
        "author": {
            "links": {
                "self": "http://example.com/articles/1/relationships/author",
                "related": "http://example.com/articles/1/author"
            },
            "data": { "type": "people", "id": "9" }
        }
    },
    "links": {
        "self": "http://example.com/articles/1"
    }
}
```

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
You might have found a `typealias` like the following for encoding/decoding `JSONAPI.Document`s (note the primary resource body is a `JSONAPI.CodableResourceBody`):
```swift
typealias Document<PrimaryResourceBody: JSONAPI.CodableResourceBody, IncludeType: JSONAPI.Include> = JSONAPI.Document<PrimaryResourceBody, NoMetadata, NoLinks, IncludeType, NoAPIDescription, BasicJSONAPIError<String>>
```

In order to support sparse fieldsets (which are encode-only), the following companion `typealias` would be useful (note the primary resource body is a `JSONAPI.EncodableResourceBody`):
```swift
typealias SparseDocument<PrimaryResourceBody: JSONAPI.EncodableResourceBody, IncludeType: JSONAPI.Include> = JSONAPI.Document<PrimaryResourceBody, NoMetadata, NoLinks, IncludeType, NoAPIDescription, BasicJSONAPIError<String>>
```

### Replacing and Tapping Attributes/Relationships
When you are working with an immutable Resource Object, it can be useful to replace its attributes or relationships. As a client, you might receive a resource from the server, update something, and then send the server a PATCH request.

`ResourceObject` is immutable, but you can create a new copy of a `ResourceObject` having updated attributes or relationships.

#### Tapping
If your `Attributes` or `Relationships` struct is mutable (i.e. its properties are `var`s) then you may find `ResourceObject`'s `tappingAttributes()` and `tappingRelationships()` functions useful. For both, you pass a function that takes an `inout` copy of the respective object or value that you can mutate. The mutated value is then used to create a new `ResourceObject`.

For example, to take a hypothetical `Dog` resource object and change the name attribute:
```swift
let resourceObject = Dog(...)

let newResourceObject = resourceObject
	.tappingAttributes { $0.name = .init(value: "Charlie") }
```

#### Replacing
If your `Attributes` or `Relationships` struct is immutable (i.e. its properties are `let`s) then you may find `ResourceObject`'s `replacingAttributes()` and `replacingRelationships()` functions useful. For both, you pass a function that takes the current attributes or relationships and you return a new value. The new value is then used to create a new `ResourceObject`.

For example, to take a hypothetical `Dog` resource object and change the name attribute:
```swift
let resourceObject = Dog(...)

let newResourceObject = resourceObject
	.replacingAttributes { _ in
		return Dog.Attributes(name: .init(value: "Charlie"))
}
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
**NOTE** this section describes an ability to create computed relationships, not to be confused with the similarly named `MetaRelationship` type which is used to create relationships that do not have an `id`/`type` (they only have `links` and/or `meta`).

This advanced feature may not ever be useful, but if you find yourself in the situation of dealing with an API that does not 100% follow the **SPEC** then you might find meta-relationships are just the thing to make your resource objects more natural to work with.

Similarly to Meta-Attributes, Meta-Relationships allow you to represent non-compliant relationships as computed relationship properties. In the following example, a relationship is created from some attributes on the JSON model.

```swift
enum UserDescription: ResourceObjectDescription {
	public static var jsonType: String { return "users" }

	struct Attributes: JSONAPI.Attributes {
		let friend_id: Attribute<String>
	}

	struct Relationships: JSONAPI.Relationships {
		public var friend: (User) -> User.Id {
			return { user in
				return User.Id(rawValue: user.friend_id)
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

This works because `friend` is defined in the form: `var {name}: ({ResourceObject}) -> {Id}` where `{ResourceObject}` is the `JSONAPI.ResourceObject` described by the `ResourceObjectDescription` containing the meta-relationship.
