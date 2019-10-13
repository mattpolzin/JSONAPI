//: [Previous](@previous)

import Foundation
import JSONAPI

/*******

 Please enjoy these examples, but allow me the forced casting and the lack of error checking for the sake of brevity.

 This playground focuses on receiving a resource, making some changes, and then creating a request body for a PATCH request.
 As with all examples in these playround pages, no actual networking code will be provided.

 ********/

// Mock up a server response
let mockDogData = """
{
    "data": {
        "id": "1234",
        "type": "dogs",
        "attributes": {
            "name": "Sparky"
        },
        "relationships": {
            "owner": {
                "data": null
            }
        }
    }
}
""".data(using: .utf8)!

//
// MARK: - EXAMPLE 1 (Mutable Attributes)
//

// pretend to have requested a Dog and received the mock data
// now parse it.
let parsedResponse = try! JSONDecoder().decode(MutableDogDocument.self, from: mockDogData)

// extract our Dog (skipping over any robustness to handle errors)
var dog = parsedResponse.body.primaryResource!.value
print("Received dog named: \(dog.name)")

// change the dog's name
let changedDog = dog.tappingAttributes { $0.name = .init(value: "Julia") }

// create a document to be used as a request body for a PATCH request
let patchRequest = MutableDogDocument(apiDescription: .none,
                                      body: .init(resourceObject: changedDog),
                                      includes: .none,
                                      meta: .none,
                                      links: .none)

// encode and send off to server
let encodedPatchRequest = try! JSONEncoder().encode(patchRequest)
print("----")
print(String(data: encodedPatchRequest, encoding:.utf8)!)


//
// MARK: - EXAMPLE 2 (Immutable Attributes)
//
print()
print("####")
print()

// pretend to have requested a Dog and received the mock data
// now parse it.
let parsedResponse2 = try! JSONDecoder().decode(SingleDogDocument.self, from: mockDogData)

// extract our Dog (skipping over any robustness to handle errors)
var dog2 = parsedResponse2.body.primaryResource!.value
print("Received dog named: \(dog2.name)")

// change the dog's name
let changedDog2 = dog2.replacingAttributes { _ in
    return .init(name: .init(value: "Nigel"))
}

// create a document to be used as a request body for a PATCH request
let patchRequest2 = SingleDogDocument(apiDescription: .none,
                                      body: .init(resourceObject: changedDog2),
                                      includes: .none,
                                      meta: .none,
                                      links: .none)

// encode and send off to server
let encodedPatchRequest2 = try! JSONEncoder().encode(patchRequest2)
print("----")
print(String(data: encodedPatchRequest2, encoding:.utf8)!)


//
// MARK: - EXAMPLE 3 (Change relationship)
//
print()
print("####")
print()

// pretend to have requested a Dog and received the mock data
// now parse it.
let parsedResponse3 = try! JSONDecoder().decode(SingleDogDocument.self, from: mockDogData)

// extract our Dog (skipping over any robustness to handle errors)
var dog3 = parsedResponse2.body.primaryResource!.value
print("Received dog with owner: \(dog3 ~> \.owner)")

// give the dog an owner
let changedDog3 = dog3.replacingRelationships { _ in
    return .init(owner: .init(id: Id(rawValue: "1")))
}

// create a document to be used as a request body for a PATCH request
let patchRequest3 = SingleDogDocument(apiDescription: .none,
                                      body: .init(resourceObject: changedDog3),
                                      includes: .none,
                                      meta: .none,
                                      links: .none)

// encode and send off to server
let encodedPatchRequest3 = try! JSONEncoder().encode(patchRequest3)
print("----")
print(String(data: encodedPatchRequest3, encoding:.utf8)!)
