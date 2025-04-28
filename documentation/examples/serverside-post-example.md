
# JSONAPI Serverside POST Example

We are about to walk through an example handling a POST (resource creation)
request. Information on creating models that take advantage of more of the
features from the JSON:API Specification can be found in the [README](https://github.com/mattpolzin/JSONAPI/blob/main/README.md).

We will identify our resources using `UUID`s.

```swift
// If we wanted to, we could just make `UUID` a `RawIdType`
// extension UUID: RawIdType {}

// We will go a step further and make it a `CreatableRawIdType` and let `JSONAPI`
// create new unique Ids for people in the POST handling code farther down in this
// example.
extension UUID: CreatableRawIdType {
  public static func unique() -> UUID {
    return UUID()
  }
}
```

The `JSONAPI` framework relies heavily on generic types so the first step will be
to alias away some of the JSON:API features we do not need for our simple
example.

```swift
/// Our Resource objects will not have any metadata or links and they will be identified by UUIDs.
typealias Resource<Description: JSONAPI.ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, UUID>

/// The client will send us a POST request with an unidenfitied resource object. We will call this a "new resource object"
typealias New<Resource: JSONAPI.ResourceObjectType> = JSONAPI.ResourceObject<Resource.Description, NoMetadata, NoLinks, Unidentified>

/// Our JSON:API Documents will similarly have no metadata or links associated with them. Additionally, there will be no included resources.
typealias SingleDocument<Resource: ResourceObjectType> = JSONAPI.Document<SingleResourceBody<Resource>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>
```

The next step is to create `ResourceObjectDescriptions` and `ResourceObjects`. For
our simple example, we will handle a `POST` request for a `Person` resource.

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
  
  typealias Relationships = NoRelationships
}

// this typealias is optional, but it makes working with resource objects much
// more user friendly.
extension API {
  typealias Person = Resource<PersonDescription>
}
```

To illustrate using the `JSONAPI` framework, we will skip over the details of
database reading/writing. Let's mock up a database model for a `Person`.

```swift
// snag Foundation for JSONDecoder
import Foundation

// This is just a standin for whatever models you've got coming out of the database.
enum DB {
  struct Person {
    let id: String
    let firstName: String
    let lastName: String
    let age: Int?
  }
}

// you could handle this any number of ways, but here we will write an initializer
// that gets you a database model from the `JSONAPI` model.
extension DB.Person {
  
  init(_ person: API.Person) {
    id = "\(person.id.rawValue)"
    firstName = person.firstName
    lastName = person.lastName
    age = person.age
  }
}
```

Now we'll handle a `POST` request by creating a new database record (we'll skip
this detail) and responding with a `Person` resource.

```swift
// NOTE this request has no Id because the client is requesting this new `Person` be created.
let mockPersonRequest =
"""
{
  "data": {
    "type": "people",
    "attributes": {
      "first_name": "Jimmie",
      "last_name": "Glows",
      "age": 53
    }
  }
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

// We will decode a "new" resource (see typealiases earlier in this example)
let requestedPersonDocument = try! decoder.decode(SingleDocument<New<API.Person>>.self, from: mockPersonRequest)
let requestedPerson = requestedPersonDocument.body.primaryResource!.value

// Our DB.Person initializer expects an identified `Person`, not a `New<Person>`
// but we can let the `JSONAPI` framework create a new `UUID` for us:
let identifiedPerson = requestedPerson.identified(byType: UUID.self)

let dbPerson = DB.Person(identifiedPerson)

// Here's where we would save our `dbPerson` to te database, if we had an
// actualy database connection in this example. We'd also create our response from
// the result of that database save, ideally. We are going to skip those details
// and pretend the database write was successful.

// finally, let's create a response
let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase
encoder.outputFormatting = .prettyPrinted

let responseData = try! encoder.encode(SingleDocument(apiDescription: .none,
                                                      body: .init(resourceObject: identifiedPerson),
                                                      includes: .none,
                                                      meta: .none,
                                                      links: .none))

// Send it off to the client!

print("response body:")
print("\(String(data: responseData, encoding: .utf8)!)")
```

