
# JSONAPI Basic Example

We are about to walk through a basic example to show how easy it is to set up a
simple model. Information on creating models that take advantage of more of the
features from the JSON:API Specification can be found in the [README](https://github.com/mattpolzin/JSONAPI/blob/main/README.md).

The `JSONAPI` framework relies heavily on generic types so the first step will
be to alias away some of the JSON:API features we do not need for our simple
example.

```swift
/// Our Resource objects will not have any metadata or links and they will be identified by Strings.
typealias Resource<Description: JSONAPI.ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, String>

/// Our JSON:API Documents will similarly have no metadata or links associated with them. Additionally, there will be no included resources.
typealias SingleDocument<Resource: ResourceObjectType> = JSONAPI.Document<SingleResourceBody<Resource>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>

typealias BatchDocument<Resource: ResourceObjectType> = JSONAPI.Document<ManyResourceBody<Resource>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>
```

The next step is to create `ResourceObjectDescriptions` and `ResourceObjects`.
For our simple example, let's create a `Person` and a `Dog`.

```swift
struct PersonDescription: ResourceObjectDescription {
  // by common convention, we will use the plural form
  // of the noun as the JSON:API "type"
  static let jsonType: String = "people"
  
  struct Attributes: JSONAPI.Attributes {
    let firstName: Attribute<String>
    let lastName: Attribute<String>
    
    // we mark this attribute as "nullable" because the user can choose
    // not to specify an age if they would like to.
    let age: Attribute<Int?> 
  }
  
  struct Relationships: JSONAPI.Relationships {
    // we will define "Dog" next
    let pets: ToManyRelationship<Dog, NoIdMetadata, NoMetadata, NoLinks>
  }
}

// this typealias is optional, but it makes working with resource objects much
// more user friendly.
typealias Person = Resource<PersonDescription>

struct DogDescription: ResourceObjectDescription {
  static let jsonType: String = "dogs"
  
  struct Attributes: JSONAPI.Attributes {
    let name: Attribute<String>
  }
  
  // we could relate dogs back to their owners, but for the sake of this example
  // we will instead show how you would create a resource with no relationships.
  typealias Relationships = NoRelationships
}

typealias Dog = Resource<DogDescription>
```

At this point we have two objects that can decode JSON:API responses. To
illustrate we can mock up a dog response and parse it.

```swift
// snag Foundation for JSONDecoder
import Foundation

let mockBatchDogResponse = 
"""
{
  "data": [
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

let decoder = JSONDecoder()

let dogsDocument = try! decoder.decode(BatchDocument<Dog>.self, from: mockBatchDogResponse)

let dogs = dogsDocument.body.primaryResource!.values

print("dogs parsed: \(dogs.count ?? 0)")
```

To illustrate `ResourceObject` property access, we can loop over the dogs and
print their names.

```swift
for dog in dogs {
  print(dog.name)
}
```

Now let's parse a mocked `Person` response.

```swift
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
  }
}
""".data(using: .utf8)!

decoder.keyDecodingStrategy = .convertFromSnakeCase

let personDocument = try! decoder.decode(SingleDocument<Person>.self, from: mockSinglePersonResponse)
```

Our `Person` object has both attributes and relationships. Generally what we care
about when accessing relationships is actually the Id(s) of the resource(s); the
loop below shows off how to access those Ids.

```swift
let person = personDocument.body.primaryResource!.value

let relatedDogIds = person ~> \.pets

print("related dog Ids: \(relatedDogIds)")
```

To wrap things up, let's throw our dog resources into a local cache and tie
things together a bit. There are many ways to go about storing or caching
resources clientside. For additional examples of more robust solutions, take a
look at [JSONAPI-ResourceStorage](https://github.com/mattpolzin/JSONAPI-ResourceStorage).

```swift
let dogCache = Dictionary(uniqueKeysWithValues: zip(dogs.map { $0.id }, dogs))

func cachedDog(_ id: Dog.Id) -> Dog? { return dogCache[id] }

print("Our person's name is \(person.firstName) \(person.lastName).")
print("They have \((person ~> \.pets).count) pets named \((person ~> \.pets).compactMap(cachedDog).map { $0.name }.joined(separator: " and ")).")
```

