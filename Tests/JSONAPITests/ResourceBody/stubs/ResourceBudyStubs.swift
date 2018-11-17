//
//  ResourceBudyStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

let single_resource_body = """
{
    "type": "articles",
    "id": "1",
    "attributes": {
      "title": "JSON:API paints my bikeshed!"
	}
}
""".data(using: .utf8)!

let many_resource_body = """
[
	{
		"type": "articles",
		"id": "1",
		"attributes": {
		  "title": "JSON:API paints my bikeshed!"
		}
	},
	{
		"type": "articles",
		"id": "2",
		"attributes": {
		  "title": "Sick"
		}
	},
	{
		"type": "articles",
		"id": "3",
		"attributes": {
		  "title": "Hello World"
		}
	}
]
""".data(using: .utf8)!

let many_resource_body_empty = """
[
]
""".data(using: .utf8)!
