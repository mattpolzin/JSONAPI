
import Foundation
import JSONAPI

/*

This is not realistically what JSONAPI code will look like. It makes
every bit of sense to typealias the long-winded generics of this
framework to make working with them more concise and readable.

The purpose of this example, then, is not to show "good" JSONAPI
code, but rather to generate a JSONAPI example document that uses
all the various (often optional) parts of a JSONAPI document.

The JSON example produced in this manner can be used to compare the
nomenclature of this library with the nomenclature of the JSON:API Spec.

*/

// MARK: - Extensions
extension Foundation.URL: JSONAPIURL {}

// extension String: CreatableRawIdType {} found in playground Entities.swift file.

// MARK: - Definitions
/// Metadata associated with entities
struct EntityMetadata: JSONAPI.Meta {
	let creationDate: Date
	let updatedDate: Date
}

/// Metadata associated with links
struct LinkMeta: JSONAPI.Meta {
	/// Don't trust this link past the expiry date.
	let expiry: Date
}

/// Links associated with entities
struct EntityLinks: JSONAPI.Links {
	let `self`: Link<Foundation.URL, LinkMeta>

	init(selfLink: Link<Foundation.URL, LinkMeta>) {
		self.`self` = selfLink
	}
}

/// Metadata associated with relationships
struct ToManyRelationshipMetadata: JSONAPI.Meta {
	/// Pagination for the relationship (to support really large
	/// to-many relationships)
	let pagination: Pagination

	struct Pagination: Codable, Equatable {
		let total: Int
		let limit: Int
		let offset: Int
	}
}

/// Links associated with relationships
struct ToManyRelationshipLinks: JSONAPI.Links {
	/// next page of relationships.
	let next: Link<Foundation.URL, LinkMeta>
}

/// Description of an Author entity.
enum AuthorDescription: ResourceObjectDescription {
	static var jsonType: String { return "authors" }

	struct Attributes: JSONAPI.Attributes {
		let name: Attribute<String>
	}

	struct Relationships: JSONAPI.Relationships {
		let articles: ToManyRelationship<Article, NoIdMetadata, ToManyRelationshipMetadata, ToManyRelationshipLinks>
	}
}

typealias Author = JSONAPI.ResourceObject<AuthorDescription, EntityMetadata, EntityLinks, String>

/// Description of an Article entity.
enum ArticleDescription: ResourceObjectDescription {
	static var jsonType: String { return "articles" }

	struct Attributes: JSONAPI.Attributes {
		let title: Attribute<String>
	}

	struct Relationships: JSONAPI.Relationships {
		/// The primary attributed author of the article.
		let primaryAuthor: ToOneRelationship<Author, NoIdMetadata, NoMetadata, NoLinks>
		/// All authors excluding the primary author.
		/// It is customary to print the primary author's
		/// name first, followed by the other authors.
		let otherAuthors: ToManyRelationship<Author, NoIdMetadata, ToManyRelationshipMetadata, ToManyRelationshipLinks>
	}
}

typealias Article = JSONAPI.ResourceObject<ArticleDescription, EntityMetadata, EntityLinks, String>

/// Metadata associated with the API Description
struct APIDescriptionMetadata: JSONAPI.Meta {
	/// A clever codename for this API version.
	let codename: String
}

/// Metadata associated with any Document
struct DocumentMetadata: JSONAPI.Meta {
	/// Assuming caching is in play, this is when
	/// the cached document being returned was created.
	let updatedDate: Date
}

/// Links associated with an Article Document
struct SingleArticleDocumentLinks: JSONAPI.Links {
	let otherArticlesByPrimaryAuthor: Link<Foundation.URL, LinkMeta>
}

/// Error that can occur when retrieving a Single Article Document
enum ArticleDocumentError: String, JSONAPIError, Codable {
	case unknownError = "unknown"
	case missing = "missing"

	static var unknown: ArticleDocumentError {
		return .unknownError
	}
}

typealias SingleArticleDocument = JSONAPI.Document<SingleResourceBody<Article>, DocumentMetadata, SingleArticleDocumentLinks, Include1<Author>, APIDescription<APIDescriptionMetadata>, ArticleDocumentError>

// MARK: - Instantiations
let authorId1 = Author.Id()
let authorId2 = Author.Id()
let authorId3 = Author.Id()

let now = Date()
let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!

let tomorrowEntityMeta = EntityMetadata(creationDate: Calendar.current.date(byAdding: .day, value: -10, to: now)!,
										updatedDate: Calendar.current.date(byAdding: .day, value: -2, to: now)!)
let articleLinks = EntityLinks(selfLink: .init(url: URL(string: "https://articles.com/article/1234")!,
											   meta: .init(expiry: tomorrow)))
let article = Article(attributes: .init(title: .init(value: "How to read JSONAPI")),
					  relationships: .init(primaryAuthor: .init(id: authorId1),
										   otherAuthors: .init(ids: [authorId2, authorId3],
															   meta: .init(pagination: .init(total: 2,
																							 limit: 50,
																							 offset: 0)),
															   links: .init(next: .init(url: URL(string: "https://articles.com/article/1234?otherAuthors[offset]=50")!,
																						meta: .init(expiry: tomorrow))))),
					  meta: tomorrowEntityMeta,
					  links: articleLinks)

let author1Links = EntityLinks(selfLink: .init(url: URL(string: "https://articles.com/author/\(authorId1.rawValue)")!,
											   meta: .init(expiry: tomorrow)))
let author1 = Author(id: authorId1,
					 attributes: .init(name: .init(value: "James Kinney")),
					 relationships: .init(articles: .init(ids: [article.id, Article.Id(), Article.Id()],
														  meta: .init(pagination: .init(total: 3,
																						limit: 50,
																						offset: 0)),
														  links: .init(next: .init(url: URL(string: "https://articles.com/author/\(authorId1.rawValue)?articles[offset]=50")!, meta: .init(expiry: tomorrow))))),
					 meta: tomorrowEntityMeta,
					 links: author1Links)

let author2Links = EntityLinks(selfLink: .init(url: URL(string: "https://articles.com/author/\(authorId2.rawValue)")!,
											   meta: .init(expiry: tomorrow)))
let author2 = Author(id: authorId2,
					 attributes: .init(name: .init(value: "James Kinney")),
					 relationships: .init(articles: .init(ids: [article.id, Article.Id()],
														  meta: .init(pagination: .init(total: 2,
																						limit: 50,
																						offset: 0)),
														  links: .init(next: .init(url: URL(string: "https://articles.com/author/\(authorId2.rawValue)?articles[offset]=50")!, meta: .init(expiry: tomorrow))))),
					 meta: tomorrowEntityMeta,
					 links: author2Links)

let author3Links = EntityLinks(selfLink: .init(url: URL(string: "https://articles.com/author/\(authorId3.rawValue)")!,
											   meta: .init(expiry: tomorrow)))
let author3 = Author(id: authorId3,
					 attributes: .init(name: .init(value: "James Kinney")),
					 relationships: .init(articles: .init(ids: [article.id],
														  meta: .init(pagination: .init(total: 1,
																						limit: 50,
																						offset: 0)),
														  links: .init(next: .init(url: URL(string: "https://articles.com/author/\(authorId3.rawValue)?articles[offset]=50")!, meta: .init(expiry: tomorrow))))),
					 meta: tomorrowEntityMeta,
					 links: author3Links)

let apiDescription = APIDescription<APIDescriptionMetadata>(version: "1.2",
															meta: APIDescriptionMetadata(codename: "cobra"))

let documentMetadata = DocumentMetadata(updatedDate: Date())

let documentLinks = SingleArticleDocumentLinks(otherArticlesByPrimaryAuthor: .init(url: URL(string: "https://articles.com/articles?author=\(authorId1.rawValue)")!,
																				   meta: .init(expiry: tomorrow)))

let singleArticleDocument = SingleArticleDocument(apiDescription: apiDescription,
												  body: .init(resourceObject: article),
												  includes: .init(values: [.init(author1), .init(author2), .init(author3)]),
												  meta: documentMetadata,
												  links: documentLinks)

// MARK: - Encoding
let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase
encoder.dateEncodingStrategy = .iso8601
encoder.outputFormatting = .prettyPrinted

let jsonData = try! encoder.encode(singleArticleDocument)

// MARK: - Printing JSON
print(String(data: jsonData, encoding: .utf8)!)
