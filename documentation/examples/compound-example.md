# JSONAPI Compound Example

We are about to walk through an example to show how easy it is to parse JSON:API
includes. Information on creating models that take advantage of more of the
features from the JSON:API Specification can be found in the [README](https://github.com/mattpolzin/JSONAPI/blob/main/README.md).

We will begin by quickly redefining the same types of `ResourceObjects` from the
[Basic Example](https://github.com/mattpolzin/JSONAPI/blob/main/documentation/basic-example.md).

```swift
typealias Resource<Description: JSONAPI.ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, String>

struct PersonDescription: ResourceObjectDescription {
  
  static let jsonType: String = "people"
  
  struct Attributes: JSONAPI.Attributes {
    let firstName: Attribute<String>
    let lastName: Attribute<String>
    
    let age: Attribute<Int?> 
  }
  
  struct Relationships: JSONAPI.Relationships {
    let pets: ToManyRelationship<Dog, NoIdMetadata, NoMetadata, NoLinks>
  }
}

typealias Person = Resource<PersonDescription>

struct DogDescription: ResourceObjectDescription {
  static let jsonType: String = "dogs"
  
  struct Attributes: JSONAPI.Attributes {
    let name: Attribute<String>
  }
  
  typealias Relationships = NoRelationships
}

typealias Dog = Resource<DogDescription>
```

Next we will create similar `typealiases` for single and batch documents as we did
in the **Basic Example**, but we will allow for an include type to be specified.

```swift
/// Our JSON:API Documents will still have no metadata or links associated with them but they will allow us to specify an include type later.
typealias SingleDocument<Resource: ResourceObjectType, Include: JSONAPI.Include> = JSONAPI.Document<SingleResourceBody<Resource>, NoMetadata, NoLinks, Include, NoAPIDescription, UnknownJSONAPIError>

typealias BatchDocument<Resource: ResourceObjectType, Include: JSONAPI.Include> = JSONAPI.Document<ManyResourceBody<Resource>, NoMetadata, NoLinks, Include, NoAPIDescription, UnknownJSONAPIError>
```

Now let's define a mock response containing a single person and including any
dogs that are related to that person.

```swift
// snag Foundation for Data and JSONDecoder
import Foundation

let mockSinglePersonResponse = 
"""
{
  "data": {
    "type": "people",
    "id": "88223",
    "attributes": {
      "first_name": "Lisa",
      "last_name": "Offenbrook",
      "age": null
    },
    "relationships": {
      "pets": {
        "data": [
          {
            "type": "dogs",
            "id": "123"
          },
          {
            "type": "dogs",
            "id": "456"
          }
        ]
      }
    }
  },
  "included": [
    {
      "type": "dogs",
      "id": "123",
      "attributes": {
        "name": "Sparky"
      }
    },
    {
      "type": "dogs",
      "id": "456",
      "attributes": {
        "name": "Charlie Dog"
      }
    }
  ]
}
""".data(using: .utf8)!
```

Parsing the above response looks almost identical to in the **Basic Example**. The
key thing to note is that instead of specifying `NoIncludes` we specify
`Include1<Dog>` below. This does not mean "include one dog," it means "include one
type of thing, with that type being `Dog`." The `JSONAPI` framework comes with
built-in support for `Include2<...>`, `Include3<...>` and many more. If you wanted to include
both `Person` and `Dog` resources (perhaps because your primary `Person` resource had
a "friends" relationship), you would use `Include2<Person, Dog>`.

```swift
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let includeDocument = try! decoder.decode(SingleDocument<Person, Include1<Dog>>.self, from: mockSinglePersonResponse)
```

The `Person` is pulled out as before with `Document.body.primaryResource`. The dogs
can be accessed from `Document.body.includes`; note that because multiple types of
things can be included, we must specify that we want things of type `Dog` by using
the `JSONAPI.Includes` subscript operator.

```swift
let person = includeDocument.body.primaryResource!.value
let dogs = includeDocument.body.includes![Dog.self]

print("Parsed person named \(person.firstName) \(person.lastName)")
print("Parsed dogs named \(dogs.map { $0.name }.joined(separator: " and "))")
```

