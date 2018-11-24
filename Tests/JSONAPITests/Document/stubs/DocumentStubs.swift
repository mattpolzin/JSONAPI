//
//  DocumentStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

let single_document_null = """
{
	"data": null
}
""".data(using: .utf8)!

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

let single_document_no_includes_with_metadata = """
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
	"meta": {
		"total": 70,
		"limit": 40,
		"offset": 10
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

let single_document_some_includes_with_metadata = """
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
	],
	"meta": {
		"total": 70,
		"limit": 40,
		"offset": 10
	}
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

let error_document_no_metadata = """
{
	"errors": [
		{
			"description": "Boooo!",
			"code": 1
		}
	]
}
""".data(using: .utf8)!

let error_document_with_metadata = """
{
	"errors": [
		{
			"description": "Boooo!",
			"code": 1
		}
	],
	"meta": {
		"total": 70,
		"limit": 40,
		"offset": 10
	}
}
""".data(using: .utf8)!

let metadata_document = """
{
	"meta": {
		"total": 100,
		"limit": 50,
		"offset": 0
	}
}
""".data(using: .utf8)!

let metadata_document_missing_metadata = """
{
}
""".data(using: .utf8)!

let metadata_document_missing_metadata2 = """
{
	"meta": null
}
""".data(using: .utf8)!
