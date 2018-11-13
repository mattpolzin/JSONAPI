//
//  Examples.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/12/18.
//

import JSONAPI

enum PersonDescription: IdentifiedEntityDescription {
	static var type: String { return "people" }
	
	typealias Identifier = Id<String, PersonDescription>
	
	struct Attributes: JSONAPI.Attributes {
		let name: [String]
		let favoriteColor: String
	}
	
	struct Relationships: JSONAPI.Relationships {
		let friends: ToManyRelationship<PersonDescription>
	}
}

typealias Person = Entity<PersonDescription>

func tmp() {
	let x: Person.Identifier
}
