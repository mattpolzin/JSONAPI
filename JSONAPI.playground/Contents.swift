
import Foundation
import JSONAPI

/*******

Please enjoy these examples, but allow me the forced casting and the lack of error checking for the sake of brevity.

********/

// MARK: - Create a request or response body with one Dog in it
let dogFromCode = try! Dog(name: "Buddy", owner: nil)

typealias SingleDogDocument = JSONAPIDocument<SingleResourceBody<Dog>, NoIncludes, BasicJSONAPIError>

let singleDogDocument = SingleDogDocument(body: SingleResourceBody(entity: dogFromCode))

let singleDogData = try! JSONEncoder().encode(singleDogDocument)

// MARK: - Parse a request or response body with one Dog in it
let dogResponse = try! JSONDecoder().decode(SingleDogDocument.self, from: singleDogData)
let dogFromData = dogResponse.body.data?.primary.value

// MARK: - Create a request or response with multiple people and dogs and houses included
let personIds = [Person.Identifier(), Person.Identifier()]
let dogs = try! [Dog(name: "Buddy", owner: personIds[0]), Dog(name: "Joy", owner: personIds[0]), Dog(name: "Travis", owner: personIds[1])]
let houses = [House(), House()]
let people = try! [Person(id: personIds[0], name: ["Gary", "Doe"], favoriteColor: "Orange-Red", friends: [], dogs: [dogs[0], dogs[1]], home: houses[0]), Person(id: personIds[1], name: ["Elise", "Joy"], favoriteColor: "Red", friends: [], dogs: [dogs[2]], home: houses[1])]

typealias BatchPeopleDocument = JSONAPIDocument<ManyResourceBody<Person>, Include2<Dog, House>, BasicJSONAPIError>

let includes = dogs.map { BatchPeopleDocument.Include($0) } + houses.map { BatchPeopleDocument.Include($0) }
let batchPeopleDocument = BatchPeopleDocument(body: .init(entities: people), includes: .init(values: includes))
let batchPeopleData = try! JSONEncoder().encode(batchPeopleDocument)

// MARK: - Parse a request or response body with multiple people in it and dogs and houses included

let peopleResponse = try! JSONDecoder().decode(BatchPeopleDocument.self, from: batchPeopleData)
let peopleFromData = peopleResponse.body.data?.primary.values
let dogsFromData = peopleResponse.body.data?.included[Dog.self]
let housesFromData = peopleResponse.body.data?.included[House.self]
