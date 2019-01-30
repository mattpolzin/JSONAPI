import Foundation
import JSONAPI
import Poly

// MARK: - Preamble (setup)

// We make String a CreatableRawIdType. This is actually done in
// this Playground's Entities.swift file, so it is commented out here.
/*
var GlobalStringId: Int = 0
extension String: CreatableRawIdType {
	public static func unique() -> String {
		GlobalStringId += 1
		return String(GlobalStringId)
	}
}
*/

// We create a typealias given that we do not expect JSON:API Resource
// Objects for this particular API to have Metadata or Links associated
// with them. We also expect them to have String Identifiers.
typealias JSONEntity<Description: EntityDescription> = JSONAPI.Entity<Description, NoMetadata, NoLinks, String>

// Similarly, we create a typealias for unidentified entities. JSON:API
// only allows unidentified entities (i.e. no "id" field) for client
// requests that create new entities. In these situations, the server
// is expected to assign the new entity a unique ID.
typealias UnidentifiedJSONEntity<Description: EntityDescription> = JSONAPI.Entity<Description, NoMetadata, NoLinks, Unidentified>

// We create typealiases given that we do not expect JSON:API Relationships
// for this particular API to have Metadata or Links associated
// with them.
typealias ToOneRelationship<Entity: Identifiable> = JSONAPI.ToOneRelationship<Entity, NoMetadata, NoLinks>
typealias ToManyRelationship<Entity: Relatable> = JSONAPI.ToManyRelationship<Entity, NoMetadata, NoLinks>

// We create a typealias for a Document given that we do not expect
// JSON:API Documents for this particular API to have Metadata, Links,
// useful Errors, or a JSON:API Object (i.e. APIDescription).
typealias Document<PrimaryResourceBody: JSONAPI.ResourceBody, IncludeType: JSONAPI.Include> = JSONAPI.Document<PrimaryResourceBody, NoMetadata, NoLinks, IncludeType, NoAPIDescription, UnknownJSONAPIError>

// MARK: Entity Definitions

enum AuthorDescription: EntityDescription {
	public static var jsonType: String { return "authors" }

	public struct Attributes: JSONAPI.Attributes {
		public let name: Attribute<String>
	}

	public typealias Relationships = NoRelationships
}

typealias Author = JSONEntity<AuthorDescription>

enum ArticleDescription: EntityDescription {
	public static var jsonType: String { return "articles" }

	public struct Attributes: JSONAPI.Attributes {
		public let title: Attribute<String>
		public let abstract: Attribute<String>
	}

	public struct Relationships: JSONAPI.Relationships {
		public let author: ToOneRelationship<Author>
	}
}

typealias Article = JSONEntity<ArticleDescription>

// MARK: Document Definitions

// We create a typealias to represent a document containing one Article
// and including its Author
typealias SingleArticleDocumentWithIncludes = Document<SingleResourceBody<Article>, Include1<Author>>

// ... and a typealias to represent a document containing one Article and
// not including any related entities.
typealias SingleArticleDocument = Document<SingleResourceBody<Article>, NoIncludes>

// MARK: - Server Pseudo-example

// Skipping over all the API and database stuff, here's a chunk of code
// that creates a document. Note that this document is the entirety
// of a JSON:API response body.
func articleDocument(includeAuthor: Bool) -> Either<SingleArticleDocument, SingleArticleDocumentWithIncludes> {
	// Let's pretend all of this is coming from a database:

	let authorId = Author.Identifier(rawValue: "1234")

	let article = Article(id: .init(rawValue: "5678"),
						  attributes: .init(title: .init(value: "JSON:API in Swift"),
											abstract: .init(value: "Not yet written")),
						  relationships: .init(author: .init(id: authorId)),
						  meta: .none,
						  links: .none)

	let document = SingleArticleDocument(apiDescription: .none,
										 body: .init(entity: article),
										 includes: .none,
										 meta: .none,
										 links: .none)

	switch includeAuthor {
	case false:
		return .a(document)

	case true:
		let author = Author(id: authorId,
							attributes: .init(name: .init(value: "Janice Bluff")),
							relationships: .none,
							meta: .none,
							links: .none)

		let includes: Includes<SingleArticleDocumentWithIncludes.Include> = .init(values: [.init(author)])

		return .b(document.including(.init(values: [.init(author)])))
	}
}

let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase
encoder.outputFormatting = .prettyPrinted

let responseBody = articleDocument(includeAuthor: true)
let responseData = try! encoder.encode(responseBody)

// Next step would be encoding and setting as the HTTP body of a response.
// we will just print it out instead:
print("-----")
print(String(data: responseData, encoding: .utf8)!)

// ... and if we had received a request for an article without
// including the author:
let otherResponseBody = articleDocument(includeAuthor: false)
let otherResponseData = try! encoder.encode(otherResponseBody)
print("-----")
print(String(data: otherResponseData, encoding: .utf8)!)

// MARK: - Client Pseudo-example

enum NetworkError: Swift.Error {
	case serverError
	case quantityMismatch
}

// Skipping over all the API stuff, here's a chunk of code that will
// decode a document. We will assume we have made a request for a
// single article including the author.
func docode(articleResponseData: Data) throws -> (article: Article, author: Author) {
	let decoder = JSONDecoder()
	decoder.keyDecodingStrategy = .convertFromSnakeCase

	let articleDocument = try decoder.decode(SingleArticleDocumentWithIncludes.self, from: articleResponseData)

	switch articleDocument.body {
	case .data(let data):
		let authors = data.includes[Author.self]

		guard authors.count == 1 else {
			throw NetworkError.quantityMismatch
		}

		return (article: data.primary.value, author: authors[0])
	case .errors(let errors, meta: _, links: _):
		throw NetworkError.serverError
	}
}

let response = try! docode(articleResponseData: responseData)

// Next step would be to do something useful with the article and author but we will print them instead.
print("-----")
print(response.article)
print(response.author)
