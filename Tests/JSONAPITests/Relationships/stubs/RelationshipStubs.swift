//
//  RelationshipStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

let to_one_relationship = """
{
	"data": {
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
	}
}
""".data(using: .utf8)!

let to_many_relationship = """
{
	"data": [
		{
			"type": "test_entity1",
			"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
		},
		{
			"type": "test_entity1",
			"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333"
		},
		{
			"type": "test_entity1",
			"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
		}
	]
}
""".data(using: .utf8)!
