## Example
The following serves as a sort of pseudo-example. It skips server/client implementation details not related to JSON:API but still gives a more complete picture of what an implementation using this framework might look like. You can play with this example code in the Playground provided with this repo.

### Preamble (Setup shared by server and client)
```swift
// Make String a CreatableRawIdType.
var globalStringId: Int = 0
extension String: CreatableRawIdType {
	public static func unique() -> String {
		globalStringId += 1
		return String(globalStringId)
	}
}

// Create a typealias because we do not expect JSON:API Resource
// Objects for this particular API to have Metadata or Links associated
// with them. We also expect them to have String Identifiers.
typealias JSONEntity<Description: ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, String>

// Similarly, create a typealias for unidentified entities. JSON:API
// only allows unidentified entities (i.e. no "id" field) for client
// requests that create new entities. In these situations, the server
// is expected to assign the new entity a unique ID.
typealias UnidentifiedJSONEntity<Description: ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, Unidentified>

// Create relationship typealiases because we do not expect
// JSON:API Relationships for this particular API to have
// Metadata or Links associated with them.
typealias ToOneRelationship<Entity: JSONAPIIdentifiable> = JSONAPI.ToOneRelationship<Entity, NoIdMetadata, NoMetadata, NoLinks>
typealias ToManyRelationship<Entity: Relatable> = JSONAPI.ToManyRelationship<Entity, NoIdMetadata, NoMetadata, NoLinks>

// Create a typealias for a Document because we do not expect
// JSON:API Documents for this particular API to have Metadata, Links,
// useful Errors, or an APIDescription (The *SPEC* calls this
// "API Description" the "JSON:API Object").
typealias Document<PrimaryResourceBody: JSONAPI.CodableResourceBody, IncludeType: JSONAPI.Include> = JSONAPI.Document<PrimaryResourceBody, NoMetadata, NoLinks, IncludeType, NoAPIDescription, BasicJSONAPIError<String>>

// MARK: Entity Definitions

enum AuthorDescription: ResourceObjectDescription {
    public static var jsonType: String { return "authors" }

    public struct Attributes: JSONAPI.Attributes {
        public let name: Attribute<String>
    }

    public typealias Relationships = NoRelationships
}

typealias Author = JSONEntity<AuthorDescription>

enum ArticleDescription: ResourceObjectDescription {
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
typealias SingleArticleDocument = Document<SingleResourceBody<Article>, Include1<Author>>

// ... and a typealias to represent a batch document containing any number of Articles
typealias ManyArticleDocument = Document<ManyResourceBody<Article>, Include1<Author>>
```

### Server Pseudo-example
```swift
// Skipping over all the API and database stuff, here's a chunk of code
// that creates a document. Note that this document is the entirety
// of a JSON:API response body.
func article(includeAuthor: Bool) -> CompoundResource<Article, SingleArticleDocument.Include> {
    // Let's pretend all of this is coming from a database:

    let authorId = Author.Id(rawValue: "1234")

    let article = Article(
        id: .init(rawValue: "5678"),
        attributes: .init(
            title: .init(value: "JSON:API in Swift"),
            abstract: .init(value: "Not yet written")
        ),
        relationships: .init(author: .init(id: authorId)),
        meta: .none,
        links: .none
    )

    let authorInclude: SingleArticleDocument.Include?
    if includeAuthor {
        let author = Author(
            id: authorId,
            attributes: .init(name: .init(value: "Janice Bluff")),
            relationships: .none,
            meta: .none,
            links: .none
        )
        authorInclude = .init(author)
    } else {
        authorInclude = nil
    }

    return CompoundResource(
        primary: article,
        relatives: authorInclude.map { [$0] } ?? []
    )
}

func articleDocument(includeAuthor: Bool) -> SingleArticleDocument {

    let compoundResource = article(includeAuthor: includeAuthor)

    return SingleArticleDocument(
        apiDescription: .none,
        resource: compoundResource,
        meta: .none,
        links: .none
    )
}

let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase
encoder.outputFormatting = .prettyPrinted

let responseBody = articleDocument(includeAuthor: true)
let responseData = try! encoder.encode(responseBody)

// Next step would be setting the HTTP body of a response.
// We will just print it out instead:
print("-----")
print(String(data: responseData, encoding: .utf8)!)

// ... and if we had received a request for an article without
// including the author:
let otherResponseBody = articleDocument(includeAuthor: false)
let otherResponseData = try! encoder.encode(otherResponseBody)
print("-----")
print(String(data: otherResponseData, encoding: .utf8)!)
```

### Client Pseudo-example
```swift
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

    let articleDocument = try decoder.decode(SingleArticleDocument.self, from: articleResponseData)

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
```
