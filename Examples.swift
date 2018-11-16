//
//  Examples.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/12/18.
//

import JSONAPI

enum PersonDescription: EntityDescription {

	static var type: String { return "people" }
	
	struct Attributes: JSONAPI.Attributes {
		let name: [String]
		let favoriteColor: String
	}
	
	struct Relationships: JSONAPI.Relationships {
		let friends: ToManyRelationship<Person>
	}
}

typealias Person = Entity<PersonDescription, Id<String, PersonDescription>>
