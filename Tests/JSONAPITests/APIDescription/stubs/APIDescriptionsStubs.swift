//
//  APIDescriptionsStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 12/2/18.
//

let api_description_empty = """
{}
""".data(using: .utf8)!

let api_description_with_version = """
{
	"version": "1.5"
}
""".data(using: .utf8)!

let api_description_with_meta = """
{
	"meta": {
		"hello": "world",
		"number": 10
	}
}
""".data(using: .utf8)!

let api_description_with_version_and_meta = """
{
	"version": "2.0",
	"meta": {
		"hello": "world",
		"number": 10
	}
}
""".data(using: .utf8)!
