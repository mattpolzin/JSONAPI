//
//  LinkStubs.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/24/18.
//

let link_without_meta = """
{
	"link": "https://website.com/path/file",
	"optionalLink": "https://theweb.com/not"
}
""".data(using: .utf8)!

let link_without_meta_without_optional_link = """
{
	"link": "https://website.com/path/file"
}
""".data(using: .utf8)!

let link_with_null_meta = """
{
	"href": "https://website.com/path/file",
	"meta": null
}
""".data(using: .utf8)!

let link_with_metadata = """
{
	"href": "https://website.com/path/file",
	"meta": {
		"hello": "world"
	}
}
""".data(using: .utf8)!
