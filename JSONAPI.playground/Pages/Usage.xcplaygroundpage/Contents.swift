
import Foundation
import JSONAPI

/*******

Please enjoy these examples, but allow me the forced casting and the lack of error checking for the sake of brevity.

********/


// MARK: - Create a request or response body with one Dog in it
let dogFromCode = try! Dog(name: "Buddy", owner: nil)

let singleDogDocument = SingleDogDocument(apiDescription: .none, body: .init(resourceObject: dogFromCode), includes: .none, meta: .none, links: .none)

let singleDogData = try! JSONEncoder().encode(singleDogDocument)


// MARK: - Parse a request or response body with one Dog in it
let dogResponse = try! JSONDecoder().decode(SingleDogDocument.self, from: singleDogData)
let dogFromData = dogResponse.body.primaryResource?.value
let dogOwner: Person.Id? = dogFromData.flatMap { $0 ~> \.owner }


// MARK: - Parse a request or response body with one Dog in it using an alternative model
typealias AltSingleDogDocument = JSONAPI.Document<SingleResourceBody<AlternativeDog>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, BasicJSONAPIError<String>>
let altDogResponse = try! JSONDecoder().decode(AltSingleDogDocument.self, from: singleDogData)
let altDogFromData = altDogResponse.body.primaryResource?.value
let altDogHuman: Person.Id? = altDogFromData.flatMap { $0 ~> \.human }


// MARK: - Create a request or response with multiple people and dogs and houses included
let personIds = [Person.Id(), Person.Id()]
let dogs = try! [Dog(name: "Buddy", owner: personIds[0]), Dog(name: "Joy", owner: personIds[0]), Dog(name: "Travis", owner: personIds[1])]
let houses = [House(attributes: .none, relationships: .none, meta: .none, links: .none), House(attributes: .none, relationships: .none, meta: .none, links: .none)]
let people = try! [Person(id: personIds[0], name: ["Gary", "Doe"], favoriteColor: "Orange-Red", friends: [], dogs: [dogs[0], dogs[1]], home: houses[0]), Person(id: personIds[1], name: ["Elise", "Joy"], favoriteColor: "Red", friends: [], dogs: [dogs[2]], home: houses[1])]

let includes = dogs.map { BatchPeopleDocument.Include($0) } + houses.map { BatchPeopleDocument.Include($0) }
let batchPeopleDocument = BatchPeopleDocument(apiDescription: .none, body: .init(resourceObjects: people), includes: .init(values: includes), meta: .none, links: .none)
let batchPeopleData = try! JSONEncoder().encode(batchPeopleDocument)


// MARK: - Parse a request or response body with multiple people in it and dogs and houses included

let peopleResponse = try! JSONDecoder().decode(BatchPeopleDocument.self, from: batchPeopleData)
let peopleFromData = peopleResponse.body.primaryResource?.values
let dogsFromData = peopleResponse.body.includes?[Dog.self]
let housesFromData = peopleResponse.body.includes?[House.self]

print("-----")
print(peopleResponse)
print("-----")


// MARK: - Pass successfully parsed body to other parts of the code

if case let .data(bodyData) = peopleResponse.body {
	print("first person's name: \(bodyData.primary.values[0].fullName)")
} else {
	print("no body data")
}


// MARK: - Work in the abstract
print("-----")
func process<T: CodableJSONAPIDocument>(document: T) {
    guard let body = document.body.data else {
		return
	}
	let x: T.BodyData = body
}
process(document: peopleResponse)

// MARK: - Work with errors
typealias ErrorDoc = JSONAPI.Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, BasicJSONAPIError<String>>

let mockErrorData =
"""
{
    "errors": [
        {
            "status": "500",
            "title": "Internal Server Error",
            "detail": "Server fell over while parsing your request."
        }
    ]
}
""".data(using: .utf8)!

let errorResponse = try! JSONDecoder().decode(ErrorDoc.self, from: mockErrorData)

switch errorResponse.body {
case .data:
    print("cool, data!")
case .errors(let errors, let meta, let links):
    let errorDetails = errors.compactMap { $0.payload?.detail }
    print("error details: \(errorDetails)")
}
