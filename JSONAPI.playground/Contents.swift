
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
//let people

//typealias BatchPeopleDocument = JSONAPIDocument<ManyResourceBody<Person>, Include2<Dog, House>, BasicJSONAPIError>


// MARK: - Parse a request or response body with multiple people in it and dogs and houses included

//let peopleResponse = try! JSONDecoder().decode(BatchPeopleResponse.self, from: dummyData)
//let people = peopleResponse.body.data?.primary.values
//let dogs = peopleResponse.body.data?.included[Dog.self]
//let houses = peopleResponse.body.data?.included[House.self]
