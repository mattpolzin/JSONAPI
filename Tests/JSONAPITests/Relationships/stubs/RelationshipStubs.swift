//
//  RelationshipStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

let meta_relationship_with_meta = """
{
    "meta": {
        "a": "hello"
    }
}
""".data(using: .utf8)!

let meta_relationship_with_links = """
{
    "links": {
        "b": "world"
    }
}
""".data(using: .utf8)!

let meta_relationship_with_meta_and_links = """
{
    "meta": {
        "a": "hello"
    },
    "links": {
        "b": "world"
    }
}
""".data(using: .utf8)!

let to_one_relationship = """
{
	"data": {
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
	}
}
""".data(using: .utf8)!

let to_one_relationship_nulled_out = """
{
    "data": null
}
""".data(using: .utf8)!

let to_one_relationship_type_mismatch = """
{
	"data": {
		"type": "not_a_type",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
	}
}
""".data(using: .utf8)!

let to_one_relationship_with_meta = """
{
	"data": {
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
	},
	"meta": {
		"a": "hello"
	}
}
""".data(using: .utf8)!

let to_one_relationship_with_meta_inside_identifier = """
{
    "data": {
        "type": "test_entity1",
        "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
        "meta": {
                "a": "hello"
        }
    }
}
""".data(using: .utf8)!

let to_one_relationship_with_links = """
{
	"data": {
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
	},
	"links": {
		"b": "world"
	}
}
""".data(using: .utf8)!

let to_one_relationship_with_meta_and_links = """
{
	"data": {
		"type": "test_entity1",
		"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
	},
	"meta": {
		"a": "hello"
	},
	"links": {
		"b": "world"
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

let to_many_relationship_with_meta = """
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
	],
	"meta": {
		"a": "hello"
	}
}
""".data(using: .utf8)!

let to_many_relationship_with_meta_inside_identifier = """
{
    "data": [
        {
            "type": "test_entity1",
            "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
            "meta": {
                "a": "hello"
            }
        },
        {
            "type": "test_entity1",
            "id": "90F03B69-4DF1-467F-B52E-B0C9E44FC333",
            "meta": {
                "a": "hello"
            }
        },
        {
            "type": "test_entity1",
            "id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF",
            "meta": {
                "a": "hello"
            }
        }
    ]
}
""".data(using: .utf8)!

let to_many_relationship_with_links = """
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
	],
	"links": {
		"b": "world"
	}
}
""".data(using: .utf8)!

let to_many_relationship_with_meta_and_links = """
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
	],
	"meta": {
		"a": "hello"
	},
	"links": {
		"b": "world"
	}
}
""".data(using: .utf8)!

let to_many_relationship_type_mismatch = """
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
			"type": "not_a_type",
			"id": "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"
		}
	]
}
""".data(using: .utf8)!
