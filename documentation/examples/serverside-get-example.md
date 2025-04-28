
# JSONAPI Serverside GET Example

We are about to walk through a basic example of serializing a simple model.
Information on creating models that take advantage of more of the features from
the JSON:API Specification can be found in the [README](https://github.com/mattpolzin/JSONAPI/blob/main/README.md).

Note that the first two steps here are almost identical to the first two steps
in the 
[Clientside Basic Example](https://github.com/mattpolzin/JSONAPI/blob/main/documentation/basic-example.md).
The same Swift resource types you create with this framework can be used by the
client and the server.

The `JSONAPI` framework relies heavily on generic types so the first step will be
to alias away some of the JSON:API features we do not need for our simple
example.

```swift
/// Our Resource objects will not have any metadata or links and they will be identified by Strings.
typealias Resource<Description: JSONAPI.ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, String>

/// Our JSON:API Documents will similarly have no metadata or links associated with them. Additionally, there will be no included resources.
typealias SingleDocument<Resource: ResourceObjectType> = JSONAPI.Document<SingleResourceBody<Resource>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>

typealias BatchDocument<Resource: ResourceObjectType> = JSONAPI.Document<ManyResourceBody<Resource>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>
```

The next step is to create `ResourceObjectDescriptions` and `ResourceObjects`. For
our simple example, let's create a `Person` and a `Dog`.

```swift
enum API {}

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
    let pets: ToManyRelationship<API.Dog, NoIdMetadata, NoMetadata, NoLinks>
  }
}

// this typealias is optional, but it makes working with resource objects much
// more user friendly.
extension API {
  typealias Person = Resource<PersonDescription>
}

struct DogDescription: ResourceObjectDescription {
  static let jsonType: String = "dogs"
  
  struct Attributes: JSONAPI.Attributes {
    let name: Attribute<String>
  }
  
  // we could relate dogs back to their owners, but for the sake of this example
  // we will instead show how you would create a resource with no relationships.
  typealias Relationships = NoRelationships
}

extension API {
  typealias Dog = Resource<DogDescription>
}
```

At this point we have two objects that can encode JSON:API responses. To
illustrate we will skip over the details of reading from the database and assume
we have some data ready to be turned into a JSON:API response for a collection
of `Dogs`.

```swift
// snag Foundation for JSONDecoder
import Foundation

// This is just a standin for whatever models you've got coming out of the database.
enum DB {
  struct Dog {
    let id: Int
    let name: String
  }
}

// you could handle this any number of ways, but here we will write an extension
// that gets you the `JSONAPI` models from the database models.
extension DB.Dog {
  var serializable: API.Dog {
    let attributes = API.Dog.Attributes(name: .init(value: name))
    return API.Dog(id: .init(rawValue: String(id)), 
                   attributes: attributes, 
                   relationships: .none,
                   meta: .none,
                   links: .none)
  }
}

let dogs = [
  DB.Dog(id: 123, name: "Sparky"),
  DB.Dog(id: 456, name: "Charlie Dog")
].map { $0.serializable }


let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let primaryResources = ManyResourceBody(resourceObjects: dogs)

let dogsDocument = BatchDocument(apiDescription: .none,
                                 body: primaryResources,
                                 includes: .none,
                                 meta: .none,
                                 links: .none)

let dogsResponse = try! encoder.encode(dogsDocument)

// At this point you can send the response data to the client in whatever way you like.

print("dogs response: \(String(data: dogsResponse, encoding: .utf8)!)")
```

Let's look at a single `Person` response as well.

```swift
extension DB {
  struct Person {
    let id: Int
    let firstName: String
    let lastName: String
    let age: Int?
    
    /// relationship to dogs created as array of String Ids
    let dogs: [Int]
  }
}

extension DB.Person {
  var serializable: API.Person {
    let attributes = API.Person.Attributes(firstName: .init(value: firstName),
                                           lastName: .init(value: lastName),
                                           age: .init(value: age))
    let relationships = API.Person.Relationships(pets: .init(ids: dogs.map { API.Dog.Id(rawValue: String($0)) }))
    
    return API.Person(id: .init(rawValue: String(id)),
                      attributes: attributes,
                      relationships: relationships,
                      meta: .none,
                      links: .none)
  }
}

let person = DB.Person(id: 9876, 
                       firstName: "Julie", 
                       lastName: "Stone", 
                       age: nil,
                       dogs: [123, 456]).serializable

let personDocument = SingleDocument(apiDescription: .none,
                                    body: .init(resourceObject: person),
                                    includes: .none,
                                    meta: .none,
                                    links: .none)

let personResponse = try! encoder.encode(personDocument)

// At this point you can send the response data to the client in whatever way you like.

print("person response: \(String(data: personResponse, encoding: .utf8)!)")
```

