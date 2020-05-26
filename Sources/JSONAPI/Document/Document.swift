//
//  Document.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/5/18.
//

import Poly

public protocol DocumentBodyDataContext {
    associatedtype PrimaryResourceBody: JSONAPI.EncodableResourceBody
    associatedtype MetaType: JSONAPI.Meta
    associatedtype LinksType: JSONAPI.Links
    associatedtype IncludeType: JSONAPI.Include
}

public protocol DocumentBodyContext: DocumentBodyDataContext {
    associatedtype Error: JSONAPIError
    associatedtype BodyData: DocumentBodyData
        where
            BodyData.PrimaryResourceBody == PrimaryResourceBody,
            BodyData.MetaType == MetaType,
            BodyData.LinksType == LinksType,
            BodyData.IncludeType == IncludeType
}

public protocol DocumentBodyData: DocumentBodyDataContext {
    /// The document's primary resource body
    /// (contains one or many resource objects)
    var primary: PrimaryResourceBody { get }

    /// The document's included objects
    var includes: Includes<IncludeType> { get }
    var meta: MetaType { get }
    var links: LinksType { get }
}

public protocol DocumentBody: DocumentBodyContext {
    /// `true` if the document represents one or more errors. `false` if the
    /// document represents JSON:API data and/or metadata.
    var isError: Bool { get }

    /// Get all errors in the document, if any.
    ///
    /// `nil` if the Document is _not_ an error response. Otherwise,
    /// an array containing all errors.
    var errors: [Error]? { get }

    /// Get the document data
    ///
    /// `nil` if the Document is an error response. Otherwise,
    /// a structure containing the primary resource, any included
    /// resources, metadata, and links.
    var data: BodyData? { get }

    /// Quick access to the `data`'s primary resource.
    ///
    /// `nil` if the Document is an error document. Otherwise,
    /// the primary resource body, which will contain zero/one, one/many
    /// resources dependening on the `PrimaryResourceBody` type.
    ///
    /// See `SingleResourceBody` and `ManyResourceBody`.
    var primaryResource: PrimaryResourceBody? { get }

    /// Quick access to the `data`'s includes.
    ///
    /// `nil` if the Document is an error document. Otherwise,
    /// zero or more includes.
    var includes: Includes<IncludeType>? { get }

    /// The metadata for the error or data document or `nil` if
    /// no metadata is found.
    var meta: MetaType? { get }

    /// The links for the error or data document or `nil` if
    /// no links are found.
    var links: LinksType? { get }
}

/// An `EncodableJSONAPIDocument` supports encoding but not decoding.
/// It is more restrictive than `CodableJSONAPIDocument` which supports both
/// encoding and decoding.
public protocol EncodableJSONAPIDocument: Equatable, Encodable, DocumentBodyContext {
    associatedtype APIDescription: APIDescriptionType
    associatedtype Body: DocumentBody
        where
            Body.PrimaryResourceBody == PrimaryResourceBody,
            Body.MetaType == MetaType,
            Body.LinksType == LinksType,
            Body.IncludeType == IncludeType,
            Body.Error == Error,
            Body.BodyData == BodyData

    /// The Body of the Document. This body is either one or more errors
    /// with links and metadata attempted to parse but not guaranteed or
    /// it is a successful data struct containing all the primary and
    /// included resources, the metadata, and the links that this
    /// document type specifies.
    var body: Body { get }

    /// The JSON API Spec calls this the JSON:API Object. It contains version
    /// and metadata information about the API itself.
    var apiDescription: APIDescription { get }
}

/// A Document that can be constructed as successful (i.e. not an error document).
public protocol SucceedableJSONAPIDocument: EncodableJSONAPIDocument {
    /// Create a successful JSONAPI:Document.
    ///
    /// - Parameters:
    ///     - apiDescription: The description of the API (a.k.a. the "JSON:API Object").
    ///     - body: The primary resource body of the JSON:API Document. Generally a single resource or a batch of resources.
    ///     - includes: All related resources that are included in this Document.
    ///     - meta: Any metadata associated with the Document.
    ///     - links: Any links associated with the Document.
    ///
    init(
        apiDescription: APIDescription,
        body: PrimaryResourceBody,
        includes: Includes<IncludeType>,
        meta: MetaType,
        links: LinksType
    )
}

/// A Document that can be constructed as failed (i.e. an error document with no primary
/// resource).
public protocol FailableJSONAPIDocument: EncodableJSONAPIDocument {
    /// Create an error JSONAPI:Document.
    init(
        apiDescription: APIDescription,
        errors: [Error],
        meta: MetaType?,
        links: LinksType?
    )
}

/// A `CodableJSONAPIDocument` supports encoding and decoding of a JSON:API
/// compliant Document.
public protocol CodableJSONAPIDocument: EncodableJSONAPIDocument, Decodable where PrimaryResourceBody: JSONAPI.CodableResourceBody, IncludeType: Decodable {}

/// A JSON API Document represents the entire body
/// of a JSON API request or the entire body of
/// a JSON API response.
///
/// Note that this type uses Camel case. If your
/// API uses snake case, you will want to use
/// a conversion such as the one offerred by the
/// Foundation JSONEncoder/Decoder: `KeyDecodingStrategy`
public struct Document<PrimaryResourceBody: JSONAPI.EncodableResourceBody, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links, IncludeType: JSONAPI.Include, APIDescription: APIDescriptionType, Error: JSONAPIError>: EncodableJSONAPIDocument, SucceedableJSONAPIDocument, FailableJSONAPIDocument {
    public typealias Include = IncludeType
    public typealias BodyData = Body.Data

    // See `EncodableJSONAPIDocument` for documentation.
    public let apiDescription: APIDescription

    // See `EncodableJSONAPIDocument` for documentation.
    public let body: Body

    public init(
        apiDescription: APIDescription,
        errors: [Error],
        meta: MetaType? = nil,
        links: LinksType? = nil
    ) {
        body = .errors(errors, meta: meta, links: links)
        self.apiDescription = apiDescription
    }

    public init(
        apiDescription: APIDescription,
        body: PrimaryResourceBody,
        includes: Includes<Include>,
        meta: MetaType,
        links: LinksType
    ) {
        self.body = .data(
            .init(
                primary: body,
                includes: includes,
                meta: meta,
                links: links
            )
        )
        self.apiDescription = apiDescription
    }
}

extension Document {
    public enum Body: DocumentBody, Equatable {
        case errors([Error], meta: MetaType?, links: LinksType?)
        case data(Data)

        public typealias BodyData = Data

        public struct Data: DocumentBodyData, Equatable {
            /// The document's Primary Resource object(s)
            public let primary: PrimaryResourceBody
            /// The document's included objects
            public let includes: Includes<Include>
            public let meta: MetaType
            public let links: LinksType

            public init(primary: PrimaryResourceBody, includes: Includes<Include>, meta: MetaType, links: LinksType) {
                self.primary = primary
                self.includes = includes
                self.meta = meta
                self.links = links
            }
        }

        /// `true` if the document represents one or more errors. `false` if the
        /// document represents JSON:API data and/or metadata.
        public var isError: Bool {
            guard case .errors = self else { return false }
            return true
        }

        public var errors: [Error]? {
            guard case let .errors(errors, meta: _, links: _) = self else { return nil }
            return errors
        }

        public var data: Data? {
            guard case let .data(data) = self else { return nil }
            return data
        }

        public var primaryResource: PrimaryResourceBody? {
            guard case let .data(data) = self else { return nil }
            return data.primary
        }

        public var includes: Includes<Include>? {
            guard case let .data(data) = self else { return nil }
            return data.includes
        }

        public var meta: MetaType? {
            switch self {
            case .data(let data):
                return data.meta
            case .errors(_, meta: let metadata?, links: _):
                return metadata
            default:
                return nil
            }
        }

        public var links: LinksType? {
            switch self {
            case .data(let data):
                return data.links
            case .errors(_, meta: _, links: let links?):
                return links
            default:
                return nil
            }
        }
    }
}

extension Document.Body.Data where PrimaryResourceBody: ResourceBodyAppendable {
    public func merging(_ other: Document.Body.Data,
                        combiningMetaWith metaMerge: (MetaType, MetaType) -> MetaType,
                        combiningLinksWith linksMerge: (LinksType, LinksType) -> LinksType) -> Document.Body.Data {
        return Document.Body.Data(primary: primary.appending(other.primary),
                                  includes: includes.appending(other.includes),
                                  meta: metaMerge(meta, other.meta),
                                  links: linksMerge(links, other.links))
    }
}

extension Document.Body.Data where PrimaryResourceBody: ResourceBodyAppendable, MetaType == NoMetadata, LinksType == NoLinks {
    public func merging(_ other: Document.Body.Data) -> Document.Body.Data {
        return merging(other,
                       combiningMetaWith: { _, _ in .none },
                       combiningLinksWith: { _, _ in .none })
    }
}

extension Document where IncludeType == NoIncludes {
    /// Create a new Document with the given includes.
    public func including<I: JSONAPI.Include>(_ includes: Includes<I>) -> Document<PrimaryResourceBody, MetaType, LinksType, I, APIDescription, Error> {
        // Note that if IncludeType is NoIncludes, then we allow anything
        // to be included, but if IncludeType already specifies a type
        // of thing to be expected then we lock that down.
        // See: Document.including() where IncludeType: _Poly1
        switch body {
        case .data(let data):
            return .init(apiDescription: apiDescription,
                         body: data.primary,
                         includes: includes,
                         meta: data.meta,
                         links: data.links)
        case .errors(let errors, meta: let meta, links: let links):
            return .init(apiDescription: apiDescription,
                         errors: errors,
                         meta: meta,
                         links: links)
        }
    }
}

// extending where _Poly1 means all non-zero _Poly arities are included
extension Document where IncludeType: _Poly1 {
    /// Create a new Document adding the given includes. This does not
    /// remove existing includes; it is additive.
    public func including(_ includes: Includes<IncludeType>) -> Document {
        // Note that if IncludeType is NoIncludes, then we allow anything
        // to be included, but if IncludeType already specifies a type
        // of thing to be expected then we lock that down.
        // See: Document.including() where IncludeType == NoIncludes
        switch body {
        case .data(let data):
            return .init(apiDescription: apiDescription,
                         body: data.primary,
                         includes: data.includes + includes,
                         meta: data.meta,
                         links: data.links)
        case .errors(let errors, meta: let meta, links: let links):
            return .init(apiDescription: apiDescription,
                         errors: errors,
                         meta: meta,
                         links: links)
        }
    }
}

// MARK: - Codable
extension Document {
    private enum RootCodingKeys: String, CodingKey {
        case data
        case errors
        case included
        case meta
        case links
        case jsonapi
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootCodingKeys.self)

        switch body {
        case .errors(let errors, meta: let meta, links: let links):
            var errContainer = container.nestedUnkeyedContainer(forKey: .errors)

            for error in errors {
                try errContainer.encode(error)
            }

            if MetaType.self != NoMetadata.self,
                let metaVal = meta {
                try container.encode(metaVal, forKey: .meta)
            }

            if LinksType.self != NoLinks.self,
                let linksVal = links {
                try container.encode(linksVal, forKey: .links)
            }

        case .data(let data):
            try container.encode(data.primary, forKey: .data)

            if Include.self != NoIncludes.self {
                try container.encode(data.includes, forKey: .included)
            }

            if MetaType.self != NoMetadata.self {
                try container.encode(data.meta, forKey: .meta)
            }

            if LinksType.self != NoLinks.self {
                try container.encode(data.links, forKey: .links)
            }
        }

        if APIDescription.self != NoAPIDescription.self {
            try container.encode(apiDescription, forKey: .jsonapi)
        }
    }
}

extension Document: Decodable, CodableJSONAPIDocument where PrimaryResourceBody: CodableResourceBody, IncludeType: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)

        if let noAPIDescription = NoAPIDescription() as? APIDescription {
            apiDescription = noAPIDescription
        } else {
            apiDescription = try container.decode(APIDescription.self, forKey: .jsonapi)
        }

        let errors = try container.decodeIfPresent([Error].self, forKey: .errors)

        let meta: MetaType?
        if let noMeta = NoMetadata() as? MetaType {
            meta = noMeta
        } else {
            do {
                meta = try container.decode(MetaType.self, forKey: .meta)
            } catch {
                meta = nil
            }
        }

        let links: LinksType?
        if let noLinks = NoLinks() as? LinksType {
            links = noLinks
        } else {
            do {
                links = try container.decode(LinksType.self, forKey: .links)
            } catch {
                links = nil
            }
        }

        // If there are errors, there cannot be a body. Return errors and any metadata found.
        if let errors = errors {
            body = .errors(errors, meta: meta, links: links)
            return
        }

        let data: PrimaryResourceBody
        if let noData = NoResourceBody() as? PrimaryResourceBody {
            data = noData
        } else {
            do {
                data = try container.decode(PrimaryResourceBody.self, forKey: .data)
            } catch let error as ResourceObjectDecodingError {
                throw DocumentDecodingError(error)
            } catch let error as ManyResourceBodyDecodingError {
                throw DocumentDecodingError(error)
            } catch let error as DecodingError {
                throw DocumentDecodingError(error)
                    ?? error
            }
        }

        let maybeIncludes: Includes<Include>?
        do {
            maybeIncludes = try container.decodeIfPresent(Includes<Include>.self, forKey: .included)
        } catch let error as IncludesDecodingError {
            throw DocumentDecodingError(error)
        }

        guard let metaVal = meta else {
            throw JSONAPICodingError.missingOrMalformedMetadata(path: decoder.codingPath)
        }
        guard let linksVal = links else {
            throw JSONAPICodingError.missingOrMalformedLinks(path: decoder.codingPath)
        }

        body = .data(.init(primary: data, includes: maybeIncludes ?? Includes<Include>.none, meta: metaVal, links: linksVal))
    }
}

// MARK: - CustomStringConvertible

extension Document: CustomStringConvertible {
    public var description: String {
        return "Document(\(String(describing: body)))"
    }
}

extension Document.Body: CustomStringConvertible {
    public var description: String {
        switch self {
        case .errors(let errors, meta: let meta, links: let links):
            return "errors: \(String(describing: errors)), meta: \(String(describing: meta)), links: \(String(describing: links))"
        case .data(let data):
            return String(describing: data)
        }
    }
}

extension Document.Body.Data: CustomStringConvertible {
    public var description: String {
        return "primary: \(String(describing: primary)), includes: \(String(describing: includes)), meta: \(String(describing: meta)), links: \(String(describing: links))"
    }
}

// MARK: - Error and Success Document Types

extension Document {
    /// A Document that only supports error bodies. This is useful if you wish to pass around a
    /// Document type but you wish to constrain it to error values.
    public struct ErrorDocument: EncodableJSONAPIDocument, FailableJSONAPIDocument {
        public typealias BodyData = Document.BodyData

        public var body: Document.Body { return document.body }

        private let document: Document

        public init(
            apiDescription: APIDescription,
            errors: [Error],
            meta: MetaType? = nil,
            links: LinksType? = nil
        ) {
            document = .init(apiDescription: apiDescription, errors: errors, meta: meta, links: links)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            try container.encode(document)
        }

        /// The JSON API Spec calls this the JSON:API Object. It contains version
        /// and metadata information about the API itself.
        public var apiDescription: APIDescription {
            return document.apiDescription
        }

        /// Get all errors in the document, if any.
        public var errors: [Error] {
            return document.body.errors ?? []
        }

        /// The metadata for the error or data document or `nil` if
        /// no metadata is found.
        public var meta: MetaType? {
            return document.body.meta
        }

        /// The links for the error or data document or `nil` if
        /// no links are found.
        public var links: LinksType? {
            return document.body.links
        }

        public static func ==(lhs: Document, rhs: ErrorDocument) -> Bool {
            return lhs == rhs.document
        }

        public static func ==(lhs: ErrorDocument, rhs: Document) -> Bool {
            return lhs.document == rhs
        }
    }

    /// A Document that only supports success bodies. This is useful if you wish to pass around a
    /// Document type but you wish to constrain it to success values.
    public struct SuccessDocument: EncodableJSONAPIDocument, SucceedableJSONAPIDocument {
        public typealias BodyData = Document.BodyData
        public typealias APIDescription = Document.APIDescription
        public typealias Body = Document.Body
        public typealias PrimaryResourceBody = Document.PrimaryResourceBody
        public typealias Include = Document.Include
        public typealias MetaType = Document.MetaType
        public typealias LinksType = Document.LinksType

        public let apiDescription: APIDescription
        public let data: BodyData
        public let body: Body

        public var document: Document {
            Document(
                apiDescription: apiDescription,
                body: data.primary,
                includes: data.includes,
                meta: data.meta,
                links: data.links
            )
        }

        public init(
            apiDescription: APIDescription,
            body: PrimaryResourceBody,
            includes: Includes<Include>,
            meta: MetaType,
            links: LinksType
        ) {
            self.apiDescription = apiDescription
            data = .init(
                primary: body,
                includes: includes,
                meta: meta,
                links: links
            )
            self.body = .data(data)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            try container.encode(document)
        }

        /// Quick access to the `data`'s primary resource.
        ///
        /// Guaranteed to exist for a `SuccessDocument`.
        /// The primary resource body, which will contain zero/one, one/many
        /// resources dependening on the `PrimaryResourceBody` type.
        ///
        /// See `SingleResourceBody` and `ManyResourceBody`.
        public var primaryResource: PrimaryResourceBody {
            return data.primary
        }

        /// Quick access to the `data`'s includes.
        ///
        /// Zero or more includes.
        public var includes: Includes<IncludeType> {
            return data.includes
        }

        /// The metadata for the data document.
        public var meta: MetaType {
            return data.meta
        }

        /// The links for the data document.
        public var links: LinksType {
            return data.links
        }

        public static func ==(lhs: Document, rhs: SuccessDocument) -> Bool {
            return lhs == rhs.document
        }

        public static func ==(lhs: SuccessDocument, rhs: Document) -> Bool {
            return lhs.document == rhs
        }
    }
}

extension Document.ErrorDocument: Decodable, CodableJSONAPIDocument
    where PrimaryResourceBody: CodableResourceBody, IncludeType: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        document = try container.decode(Document.self)

        guard document.body.isError else {
            throw DocumentDecodingError.foundSuccessDocumentWhenExpectingError
        }
    }
}

extension Document.SuccessDocument: Decodable, CodableJSONAPIDocument
    where PrimaryResourceBody: CodableResourceBody, IncludeType: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let document = try container.decode(Document.self)

        guard case .data(let data) = document.body else {
            throw DocumentDecodingError.foundErrorDocumentWhenExpectingSuccess
        }

        self.apiDescription = document.apiDescription
        self.data = data
        self.body = .data(data)
    }
}

extension Document.SuccessDocument where IncludeType == NoIncludes {
    /// Create a new Document with the given includes.
    public func including<I: JSONAPI.Include>(_ includes: Includes<I>) -> Document<PrimaryResourceBody, MetaType, LinksType, I, APIDescription, Error>.SuccessDocument {
        // Note that if IncludeType is NoIncludes, then we allow anything
        // to be included, but if IncludeType already specifies a type
        // of thing to be expected then we lock that down.
        // See: Document.including() where IncludeType: _Poly1
        switch document.body {
        case .data(let data):
            return .init(apiDescription: document.apiDescription,
                         body: data.primary,
                         includes: includes,
                         meta: data.meta,
                         links: data.links)
        case .errors:
            fatalError("SuccessDocument cannot end up in an error state")
        }
    }
}

// extending where _Poly1 means all non-zero _Poly arities are included
extension Document.SuccessDocument where IncludeType: _Poly1 {
    /// Create a new Document adding the given includes. This does not
    /// remove existing includes; it is additive.
    public func including(_ includes: Includes<IncludeType>) -> Document.SuccessDocument {
        // Note that if IncludeType is NoIncludes, then we allow anything
        // to be included, but if IncludeType already specifies a type
        // of thing to be expected then we lock that down.
        // See: Document.including() where IncludeType == NoIncludes
        switch document.body {
        case .data(let data):
            return .init(apiDescription: document.apiDescription,
                         body: data.primary,
                         includes: data.includes + includes,
                         meta: data.meta,
                         links: data.links)
        case .errors:
            fatalError("SuccessDocument cannot end up in an error state")
        }
    }
}

extension Document where MetaType == NoMetadata, LinksType == NoLinks, IncludeType == NoIncludes, APIDescription == NoAPIDescription {
    public init(body: PrimaryResourceBody) {
        self.init(
            apiDescription: .none,
            body: body,
            includes: .none,
            meta: .none,
            links: .none
        )
    }

    public init(errors: [Error]) {
        self.init(apiDescription: .none, errors: errors)
    }
}

extension Document.SuccessDocument where Document.MetaType == NoMetadata, Document.LinksType == NoLinks, Document.IncludeType == NoIncludes, Document.APIDescription == NoAPIDescription {
    public init(body: PrimaryResourceBody) {
        self.init(
            apiDescription: .none,
            body: body,
            includes: .none,
            meta: .none,
            links: .none
        )
    }
}

extension Document.ErrorDocument where Document.MetaType == NoMetadata, Document.LinksType == NoLinks, Document.IncludeType == NoIncludes, Document.APIDescription == NoAPIDescription {
    public init(errors: [Error]) {
        self.init(apiDescription: .none, errors: errors)
    }
}
