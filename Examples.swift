//
//  Examples.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/12/18.
//

import Foundation
import JSONAPI

/*******

Please enjoy these examples, but allow me the forced casting and the lack of error checking for the sake of brevity.

********/

typealias ExampleEntity<Description: EntityDescription> = Entity<Description, Id<String, Description>>

// MARK: - A few resource objects (entities)
enum PersonDescription: EntityDescription {

	static var type: String { return "people" }
	
	struct Attributes: JSONAPI.Attributes {
		let name: [String]
		let favoriteColor: String
	}
	
	struct Relationships: JSONAPI.Relationships {
		let friends: ToManyRelationship<Person>
		let dogs: ToManyRelationship<Dog>
		let home: ToOneRelationship<House>
	}
}

typealias Person = ExampleEntity<PersonDescription>

enum DogDescription: EntityDescription {

	static var type: String { return "dogs" }

	struct Attributes: JSONAPI.Attributes {
		let name: String
	}

	struct Relationships: JSONAPI.Relationships {
		let owner: ToOneRelationship<Person?>
	}
}

typealias Dog = ExampleEntity<DogDescription>

enum HouseDescription: EntityDescription {

	static var type: String { return "houses" }

	typealias Attributes = NoAttributes
	typealias Relationships = NoRelatives
}

typealias House = ExampleEntity<HouseDescription>

// MARK: - Parse a response body with one Dog in it
typealias SingleDogResponse = JSONAPIDocument<SingleResourceBody<Dog>, NoIncludes, BasicJSONAPIError>

let dummyData = "".data(using: .utf8)!
let dogResponse = try! JSONDecoder().decode(SingleDogResponse.self, from: dummyData)
let dog = dogResponse.body.data?.primary.value

// MARK: Parse a response body with multiple people in it and dogs and houses included
typealias BatchPeopleResponse = JSONAPIDocument<ManyResourceBody<Person>, Include2<Dog, House>, BasicJSONAPIError>

let peopleResponse = try! JSONDecoder().decode(BatchPeopleResponse.self, from: dummyData)
let people = peopleResponse.body.data?.primary.values
let dogs = peopleResponse.body.data?.included[Dog.self]
let houses = peopleResponse.body.data?.included[House.self]
