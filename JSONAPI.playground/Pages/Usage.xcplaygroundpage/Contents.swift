
import Foundation
import JSONAPI

/*******

Please enjoy these examples, but allow me the forced casting and the lack of error checking for the sake of brevity.

********/

// MARK: - Create a request or response body with one Dog in it
let dogFromCode = try! Dog(name: "Buddy", owner: nil)

typealias SingleDogDocument = JSONAPI.Document<SingleResourceBody<Dog>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>

let singleDogDocument = SingleDogDocument(body: SingleResourceBody(entity: dogFromCode))

let singleDogData = try! JSONEncoder().encode(singleDogDocument)

// MARK: - Parse a request or response body with one Dog in it
let dogResponse = try! JSONDecoder().decode(SingleDogDocument.self, from: singleDogData)
let dogFromData = dogResponse.body.primaryData?.value

// MARK: - Create a request or response with multiple people and dogs and houses included
let personIds = [Person.Identifier(), Person.Identifier()]
let dogs = try! [Dog(name: "Buddy", owner: personIds[0]), Dog(name: "Joy", owner: personIds[0]), Dog(name: "Travis", owner: personIds[1])]
let houses = [House(), House()]
let people = try! [Person(id: personIds[0], name: ["Gary", "Doe"], favoriteColor: "Orange-Red", friends: [], dogs: [dogs[0], dogs[1]], home: houses[0]), Person(id: personIds[1], name: ["Elise", "Joy"], favoriteColor: "Red", friends: [], dogs: [dogs[2]], home: houses[1])]

typealias BatchPeopleDocument = JSONAPI.Document<ManyResourceBody<Person>, NoMetadata, NoLinks, Include2<Dog, House>, UnknownJSONAPIError>

let includes = dogs.map { BatchPeopleDocument.Include($0) } + houses.map { BatchPeopleDocument.Include($0) }
let batchPeopleDocument = BatchPeopleDocument(body: .init(entities: people), includes: .init(values: includes))
let batchPeopleData = try! JSONEncoder().encode(batchPeopleDocument)

// MARK: - Parse a request or response body with multiple people in it and dogs and houses included

let peopleResponse = try! JSONDecoder().decode(BatchPeopleDocument.self, from: batchPeopleData)
let peopleFromData = peopleResponse.body.primaryData?.values
let dogsFromData = peopleResponse.body.includes?[Dog.self]
let housesFromData = peopleResponse.body.includes?[House.self]

print("-----")
print(peopleResponse)
print("-----")

// MARK: - Pass successfully parsed body to other parts of the code

if case let .data(bodyData) = peopleResponse.body {
	print("first person's name: \(bodyData.primary.values[0][\.fullName])")
} else {
	print("no body data")
}

// MARK: - Work in the abstract

func process<T: JSONAPIDocument>(document: T) {
	guard case let .data(body) = document.body else {
		return
	}
	let x: T.BodyData = body
}
process(document: peopleResponse)
