//
//  PolyStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/23/18.
//

let poly_entity1 = """
{
	"type": "test_entity1",
	"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
	"attributes": {
		"foo": "Hello",
		"bar": 123
	}
}
""".data(using: .utf8)!

let poly_entity2 = """
{
	"type": "test_entity2",
	"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
	"attributes": {
		"foo": "World",
		"bar": 456
	},
	"relationships": {
		"entity1": {
			"data": {
				"type": "test_entity1",
				"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
			}
		}
	}
}
""".data(using: .utf8)!

let poly_entity3 = """
{
	"type": "test_entity3",
	"id": "11223B69-4DF1-467F-B52E-B0C9E44FC443",
	"relationships": {
		"entity1": {
			"data": {
				"type": "test_entity1",
				"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
			}
		},
		"entity2": {
			"data": [
			{
			"type": "test_entity2",
			"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333"
			}
			]
		}
	}
}
""".data(using: .utf8)!

let poly_entity4 = """
{
	"type": "test_entity4",
	"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
}
""".data(using: .utf8)!

let poly_entity5 = """
{
	"type": "test_entity5",
	"id": "A24B3B69-4DF1-467F-B52E-B0C9E44F436A"
}
""".data(using: .utf8)!

let poly_entity6 = """
{
	"type": "test_entity6",
	"id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
	"relationships": {
		"entity4": {
			"data": {
				"type": "test_entity4",
				"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
			}
		}
	}
}
""".data(using: .utf8)!

let poly_entity7 = """
{
	"type": "test_entity7",
	"id": "A24B3444-4DF1-467F-B52E-B0C9E44F436A"
}
""".data(using: .utf8)!
