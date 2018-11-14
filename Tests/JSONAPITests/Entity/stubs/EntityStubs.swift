//
//  EntityStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

let entity_no_relationships_no_attributes = """
{
	"id": "A24B3B69-4DF1-467F-B52E-B0C9E44F436A",
	"type": "test_entities"
}
""".data(using: .utf8)!

let entity_no_relationships_some_attributes = """
{
"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
"type": "fifth_test_entities",
"attributes": {
"floater": 123.321
}
}
""".data(using: .utf8)!

let entity_some_relationships_no_attributes = """
{
"id": "11113B69-4DF1-467F-B52E-B0C9E44FC444",
"type": "third_test_entities",
"relationships": {
"others": {
"data": [{
"type": "test_entities",
"id": "364B3B69-4DF1-467F-B52E-B0C9E44F666E"
}]
}
}
}
""".data(using: .utf8)!

let entity_some_relationships_some_attributes = """
{
"id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
"type": "fourth_test_entities",
"attributes": {
"word": "coolio",
"number": 992299,
"array": [12.3, 4, 0.1]
},
"relationships": {
"other": {
"data": {
"type": "second_test_entities",
"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
}
}
}
}
""".data(using: .utf8)!

let entity_one_omitted_attribute = """
{
	"id": "1",
	"type": "sixth_test_entities",
	"attributes": {
		"here": "Hello",
		"maybeNull": "World"
	}
}
""".data(using: .utf8)!

let entity_one_null_attribute = """
{
	"id": "1",
	"type": "sixth_test_entities",
	"attributes": {
		"here": "Hello",
		"maybeHere": "World",
		"maybeNull": null
	}
}
""".data(using: .utf8)!

let entity_all_attributes = """
{
	"id": "1",
	"type": "sixth_test_entities",
	"attributes": {
		"here": "Hello",
		"maybeHere": "World",
		"maybeNull": "!"
	}
}
""".data(using: .utf8)!

let entity_one_null_and_one_missing_attribute = """
{
	"id": "1",
	"type": "sixth_test_entities",
	"attributes": {
		"here": "Hello",
		"maybeNull": null
	}
}
""".data(using: .utf8)!

let entity_broken_missing_nullable_attribute = """
{
	"id": "1",
	"type": "sixth_test_entities",
	"attributes": {
		"here": "Hello",
		"maybeHere": "World"
	}
}
""".data(using: .utf8)!
