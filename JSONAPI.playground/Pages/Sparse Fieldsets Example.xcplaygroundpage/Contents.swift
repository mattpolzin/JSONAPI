
import JSONAPI
import Foundation

// MARK: - Resource Object

enum ThingWithPropertiesDescription: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "thing"

    //
    // NOTE: `JSONAPI.SparsableAttributes` as opposed to `JSONAPI.Attributes`
    //
    struct Attributes: JSONAPI.SparsableAttributes {
        let stringThing: Attribute<String>
        let numberThing: Attribute<Double>
        let boolThing: Attribute<Bool?>

        //
        // NOTE: Special implementation of `CodingKeys`
        //
        enum CodingKeys: String, JSONAPI.SparsableCodingKey {
            case stringThing
            case numberThing
            case boolThing
        }
    }

    typealias Relationships = NoRelationships
}

typealias ThingWithProperties = JSONAPI.ResourceObject<ThingWithPropertiesDescription, NoMetadata, NoLinks, String>

// MARK: - Document

//
// NOTE: Using `JSONAPI.EncodableResourceBody` which means the document type will be `Encodable` but not `Decodable`.
//
typealias Document<PrimaryResourceBody: JSONAPI.EncodableResourceBody, IncludeType: JSONAPI.Include> = JSONAPI.Document<PrimaryResourceBody, NoMetadata, NoLinks, IncludeType, NoAPIDescription, BasicJSONAPIError<String>>

//
// NOTE: Using `JSONAPI.EncodablePrimaryResource` which means the `ResourceBody` will be `Encodable` but not `Decodable.
//
typealias SingleDocument<T: JSONAPI.EncodablePrimaryResource> = Document<SingleResourceBody<T>, NoIncludes>

// MARK: - Resource Initialization

let resource = ThingWithProperties(id: .init(rawValue: "1234"),
                                   attributes: .init(stringThing: .init(value: "hello world"),
                                                     numberThing: .init(value: 10),
                                                     boolThing: .init(value: nil)),
                                   relationships: .none,
                                   meta: .none,
                                   links: .none)
//
// NOTE: Creating a sparse resource that will only encode
//       the attribute named "stringThing"
//
let sparseResource = resource.sparse(with: [.stringThing])

// MARK: - Encoding

let encoder = JSONEncoder()

let sparseResourceDoc = SingleDocument(apiDescription: .none,
                                       body: .init(resourceObject: sparseResource),
                                       includes: .none,
                                       meta: .none,
                                       links: .none)

let data = try! encoder.encode(sparseResourceDoc)

print(String(data: data, encoding: .utf8)!)
