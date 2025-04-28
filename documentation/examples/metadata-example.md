
# JSONAPI Metadata Example

We are about to walk through an example of parsing JSON:API metadata.
Information on creating models that take advantage of more of the features from
the JSON:API Specification can be found in the [README](https://github.com/mattpolzin/JSONAPI/blob/main/README.md).

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

We will additionally define a structure that can parse some pagination metadata.

```swift
struct PaginationMetadata: JSONAPI.Meta {
  
  let page: Page
  
  /// The total count of all resources of the primary type of a given response.
  let total: Int
  
  struct Page: Codable, Equatable {
    let index: Int
    let size: Int
  }
}
```

Next we will create similar `typealiases` for single and batch documents as we did
in the **Basic Example**, but we will specify that we expect the `BatchDocument` to
include our `PaginationMetadata`.

```swift
/// Our JSON:API Documents will still have no metadata or links associated with them but they will allow us to specify an include type later.
typealias SingleDocument<Resource: ResourceObjectType> = JSONAPI.Document<SingleResourceBody<Resource>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>

typealias BatchDocument<Resource: ResourceObjectType> = JSONAPI.Document<ManyResourceBody<Resource>, PaginationMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>
```

Now let's define a mock response containing a batch of dogs and pagination
metadata.

```swift
// snag Foundation for Data and JSONDecoder
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
  ],
  "meta": {
    "total": 10,
    "page": {
      "index": 2,
      "size": 2
    }
  }
}
""".data(using: .utf8)!
```

Parsing the above response looks identical to in the **Basic Example**.

```swift
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let metadataDocument = try! decoder.decode(BatchDocument<Dog>.self, from: mockBatchDogResponse)
```

The `Dogs` are pulled out as before with `Document.body.primaryResource`. The
metadata is accessed by the `Document.body.metadata` property.

```swift
let dogs = metadataDocument.body.primaryResource!.values
let metadata = metadataDocument.body.meta!

print("Parsed dogs named \(dogs.map { $0.name }.joined(separator: " and "))")
print("Page \(metadata.page.index) out of \(metadata.total / metadata.page.size) at \(metadata.page.size) resources per page.")
```

