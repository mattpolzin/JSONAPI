//
//  DocumentStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

import Foundation

let single_document_no_includes = """
{
	"data": {
		"id": "1",
		"type": "articles",
		"relationships": {
			"author": {
				"data": {
					"type": "authors",
					"id": "33"
				}
			}
		}
	}
}
""".data(using: .utf8)!

let single_document_some_includes = """
{
	"data": {
		"id": "1",
		"type": "articles",
		"relationships": {
			"author": {
				"data": {
					"type": "authors",
					"id": "33"
				}
			}
		}
	},
	"included": [
		{
			"id": "33",
			"type": "authors"
		}
	]
}
""".data(using: .utf8)!

let many_document_no_includes = """
{
	"data": [
		{
			"id": "1",
			"type": "articles",
			"relationships": {
				"author": {
					"data": {
						"type": "authors",
						"id": "33"
					}
				}
			}
		},
		{
			"id": "2",
			"type": "articles",
			"relationships": {
				"author": {
					"data": {
						"type": "authors",
						"id": "22"
					}
				}
			}
		},
		{
			"id": "3",
			"type": "articles",
			"relationships": {
				"author": {
					"data": {
						"type": "authors",
						"id": "11"
					}
				}
			}
		}
	]
}
""".data(using: .utf8)!

let many_document_some_includes = """
{
	"data": [
		{
			"id": "1",
			"type": "articles",
			"relationships": {
				"author": {
					"data": {
						"type": "authors",
						"id": "33"
					}
				}
			}
		},
		{
			"id": "2",
			"type": "articles",
			"relationships": {
				"author": {
					"data": {
						"type": "authors",
						"id": "22"
					}
				}
			}
		},
		{
			"id": "3",
			"type": "articles",
			"relationships": {
				"author": {
					"data": {
						"type": "authors",
						"id": "11"
					}
				}
			}
		}
	],
	"included": [
		{
			"id": "33",
			"type": "authors"
		},
		{
			"id": "22",
			"type": "authors"
		},
		{
			"id": "11",
			"type": "authors"
		}
	]
}
""".data(using: .utf8)!
