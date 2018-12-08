//
//  ComputedPropertiesStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/28/18.
//

let computed_property_attribute = """
{
	"id": "1234",
	"type": "test",
	"attributes": {
		"name": "Sarah",
		"secret": "shhhh"
	},
	"relationships": {
		"other": {
			"data": {
				"id": "5678",
				"type": "test"
			}
		}
	}
}
""".data(using: .utf8)!
