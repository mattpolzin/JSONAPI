
# JSONAPI PATCH Example

We are about to walk through an example to show how to take an existing resource
object and create a copy with different attributes. Additional information on
the features used here can be found in the [README](https://github.com/mattpolzin/JSONAPI/blob/main/README.md).

The `JSONAPI` framework relies heavily on generic types so the first step will be
to alias away some of the JSON:API features we do not need for our simple
example.

```swift
/// Our Resource objects will not have any metadata or links and they will be identified by Strings.
typealias Resource<Description: JSONAPI.ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, String>

/// Our JSON:API Documents will similarly have no metadata or links associated with them. Additionally, there will be no included resources.
typealias SingleDocument<Resource: ResourceObjectType> = JSONAPI.Document<SingleResourceBody<Resource>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>
```

The next step is to create `ResourceObjectDescriptions` and `ResourceObjects`. For
our simple example, let's create a `Dog`. We will choose to make the properties of
our `Attributes` struct `vars` to facilitate updating them via the `ResourceObject`
`tapping` functions; an alternative approach with an immutable structure is found
later in this tutorial.

```swift
struct DogDescription: ResourceObjectDescription {
  static let jsonType: String = "dogs"
  
  struct Attributes: JSONAPI.Attributes {
    var name: Attribute<String>
  }

  typealias Relationships = NoRelationships
}

typealias Dog = Resource<DogDescription>
```

At this point we have two objects that can decode JSON:API responses. To
illustrate we can mock up a dog response we might receive from the server and
parse it.

```swift
// snag Foundation for JSONDecoder
import Foundation

let mockDogResponse = 
"""
{
  "data": {
    "type": "dogs",
    "id": "123",
    "attributes": {
      "name": "Sparky"
    }
  }
}
""".data(using: .utf8)!

let decoder = JSONDecoder()

let dogDocument = try! decoder.decode(SingleDocument<Dog>.self, from: mockDogResponse)

let dog = dogDocument.body.primaryResource!.value
```

We'll demonstrate renaming the dog using `ResourceObject`'s `tappingAttributes()`
function.

```swift
let updatedDog = dog
  .tappingAttributes { $0.name = .init(value: "Charlie") }
```

Now we can prepare a document to be used as the request body of a `PATCH` request.

```swift
let patchRequestDocument = SingleDocument(apiDescription: .none,
                                          body: .init(resourceObject: updatedDog),
                                          includes: .none,
                                          meta: .none,
                                          links: .none)

let requestBody = JSONEncoder().encode(patchRequestDocument)
```

Instead of actually sending off a `PATCH` request, we will just print the request
body out to prove to ourselves that the name was updated.

```swift
print(String(data: requestBody, encoding: .utf8)!)
```

----

Alternatively, the `Attributes` struct could have been defined with `let`
properties. Not much changes, but the `name` cannot be mutated so the entire
struct must be recreated. We will take this opportunity to use the
`ResourceObject` `replacingAttributes()` method to contrast it to the
`tappingAttributes()` method.

The `ImmutableDogDescription` below is almost identical to `DogDescription`, but the `name`
is a `let` constant.

```swift
struct ImmutableDogDescription: ResourceObjectDescription {
  static let jsonType: String = "dogs"
  
  struct Attributes: JSONAPI.Attributes {
    let name: Attribute<String>
  }

  typealias Relationships = NoRelationships
}

typealias Dog2 = Resource<ImmutableDogDescription>
```

We can use the same mock data for a single dog document and parse it as a `Dog2`.

```swift
let dogDocument2 = try! decoder.decode(SingleDocument<Dog2>.self, from: mockDogResponse)

let dog2 = dogDocument2.body.primaryResource!.value
```

We could still use `tappingAttributes()` but we cannot mutate the name property of
the new `Attributes` struct, so we will use `replacingAttributes()` instead. This
method takes as its parameter a function that returns the new attributes.

```swift
let updatedDog2 = dog2
  .replacingAttributes { _ in
    return .init(name: .init(value: "Toby"))
}
```

Now create a request document.

```swift
let patchRequestDocument2 = SingleDocument(apiDescription: .none,
                                          body: .init(resourceObject: updatedDog2),
                                          includes: .none,
                                          meta: .none,
                                          links: .none)

let requestBody2 = JSONEncoder().encode(patchRequestDocument2)
```

Once again, we'll print the request body out instead of sending it with a `PATCH`
request.

```swift
print(String(data: requestBody2, encoding: .utf8)!)
```

