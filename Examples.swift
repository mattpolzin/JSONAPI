//
//  Examples.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/12/18.
//

import JSONAPI

typealias StringId<E: EntityDescription> = Id<String, E>

enum PersonDescription: IdentifiedEntityDescription {
	typealias Identifier = Id<String, PersonDescription>

	static var type: String { return "people" }
	
	struct Attributes: JSONAPI.Attributes {
		let name: [String]
		let favoriteColor: String
	}
	
	struct Relationships: JSONAPI.Relationships {
		let friends: ToManyRelationship<Person>
	}
}

typealias Person = Entity<PersonDescription>

func tmp() {
	let person = Person(id: .init(rawValue: "33"), attributes: PersonDescription.Attributes(name: [], favoriteColor: "Green"), relationships: PersonDescription.Relationships(friends: .none))

	print(person.pointer)
}
