//
//  JSONAPIDocument.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/5/18.
//

public protocol JSONAPIDocument: Codable, Equatable {
	associatedtype PrimaryResourceBody: JSONAPI.ResourceBody
	associatedtype MetaType: JSONAPI.Meta
	associatedtype LinksType: JSONAPI.Links
	associatedtype IncludeType: JSONAPI.Include
	associatedtype APIDescription: APIDescriptionType
	associatedtype Error: JSONAPIError

	typealias Body = Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>.Body

	var body: Body { get }
}

/// A JSON API Document represents the entire body
/// of a JSON API request or the entire body of
/// a JSON API response.
/// Note that this type uses Camel case. If your
/// API uses snake case, you will want to use
/// a conversion such as the one offerred by the
/// Foundation JSONEncoder/Decoder: `KeyDecodingStrategy`
public struct Document<PrimaryResourceBody: JSONAPI.ResourceBody, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links, IncludeType: JSONAPI.Include, APIDescription: APIDescriptionType, Error: JSONAPIError>: JSONAPIDocument {
	public typealias Include = IncludeType

	/// The JSON API Spec calls this the JSON:API Object. It contains version
	/// and metadata information about the API itself.
	public let apiDescription: APIDescription

	/// The Body of the Document. This body is either one or more errors
	/// with links and metadata attempted to parse but not guaranteed or
	/// it is a successful data struct containing all the primary and
	/// included resources, the metadata, and the links that this
	/// document type specifies.
	public let body: Body
	
	public enum Body: Equatable {
		case errors([Error], meta: MetaType?, links: LinksType?)
		case data(Data)

		public struct Data: Equatable {
			public let primary: PrimaryResourceBody
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

	public init(apiDescription: APIDescription, errors: [Error], meta: MetaType? = nil, links: LinksType? = nil) {
		body = .errors(errors, meta: meta, links: links)
		self.apiDescription = apiDescription
	}

	public init(apiDescription: APIDescription, body: PrimaryResourceBody, includes: Includes<Include>, meta: MetaType, links: LinksType) {
		self.body = .data(.init(primary: body, includes: includes, meta: meta, links: links))
		self.apiDescription = apiDescription
	}
}
/*
extension Document where IncludeType == NoIncludes {
	public init(apiDescription: APIDescription, body: PrimaryResourceBody, meta: MetaType, links: LinksType) {
		self.init(apiDescription: apiDescription, body: body, includes: .none, meta: meta, links: links)
	}
}

extension Document where MetaType == NoMetadata {
	public init(apiDescription: APIDescription, body: PrimaryResourceBody, includes: Includes<Include>, links: LinksType) {
		self.init(apiDescription: apiDescription, body: body, includes: includes, meta: .none, links: links)
	}
}

extension Document where LinksType == NoLinks {
	public init(apiDescription: APIDescription, body: PrimaryResourceBody, includes: Includes<Include>, meta: MetaType) {
		self.init(apiDescription: apiDescription, body: body, includes: includes, meta: meta, links: .none)
	}
}

extension Document where APIDescription == NoAPIDescription {
	public init(body: PrimaryResourceBody, includes: Includes<Include>, meta: MetaType, links: LinksType) {
		self.init(apiDescription: .none, body: body, includes: includes, meta: meta, links: links)
	}
}

extension Document where IncludeType == NoIncludes, LinksType == NoLinks {
	public init(apiDescription: APIDescription, body: PrimaryResourceBody, meta: MetaType) {
		self.init(apiDescription: apiDescription, body: body, meta: meta, links: .none)
	}
}

extension Document where IncludeType == NoIncludes, MetaType == NoMetadata {
	public init(apiDescription: APIDescription, body: PrimaryResourceBody, links: LinksType) {
		self.init(apiDescription: apiDescription, body: body, meta: .none, links: links)
	}
}

extension Document where IncludeType == NoIncludes, APIDescription == NoAPIDescription {
	public init(body: PrimaryResourceBody, meta: MetaType, links: LinksType) {
		self.init(apiDescription: .none, body: body, meta: meta, links: links)
	}
}

extension Document where MetaType == NoMetadata, LinksType == NoLinks {
	public init(apiDescription: APIDescription, body: PrimaryResourceBody, includes: Includes<Include>) {
		self.init(apiDescription: apiDescription, body: body, includes: includes, links: .none)
	}
}

extension Document where MetaType == NoMetadata, APIDescription == NoAPIDescription {
	public init(body: PrimaryResourceBody, includes: Includes<Include>, links: LinksType) {
		self.init(apiDescription: .none, body: body, includes: includes, links: links)
	}
}

extension Document where IncludeType == NoIncludes, MetaType == NoMetadata, LinksType == NoLinks {
	public init(apiDescription: APIDescription, body: PrimaryResourceBody) {
		self.init(apiDescription: apiDescription, body: body, includes: .none)
	}
}

extension Document where MetaType == NoMetadata, LinksType == NoLinks, APIDescription == NoAPIDescription {
	public init(body: PrimaryResourceBody, includes: Includes<Include>) {
		self.init(apiDescription: .none, body: body, includes: includes)
	}
}

extension Document where IncludeType == NoIncludes, MetaType == NoMetadata, LinksType == NoLinks, APIDescription == NoAPIDescription {
	public init(body: PrimaryResourceBody) {
		self.init(apiDescription: .none, body: body)
	}
}
*/

extension Document.Body.Data where PrimaryResourceBody: AppendableResourceBody {
	public func merging(_ other: Document.Body.Data,
						combiningMetaWith metaMerge: (MetaType, MetaType) -> MetaType,
						combiningLinksWith linksMerge: (LinksType, LinksType) -> LinksType) -> Document.Body.Data {
		return Document.Body.Data(primary: primary.appending(other.primary),
								  includes: includes.appending(other.includes),
								  meta: metaMerge(meta, other.meta),
								  links: linksMerge(links, other.links))
	}
}

extension Document.Body.Data where PrimaryResourceBody: AppendableResourceBody, MetaType == NoMetadata, LinksType == NoLinks {
	public func merging(_ other: Document.Body.Data) -> Document.Body.Data {
		return merging(other,
					   combiningMetaWith: { _, _ in .none },
					   combiningLinksWith: { _, _ in .none })
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
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RootCodingKeys.self)

		if let noData = NoAPIDescription() as? APIDescription {
			apiDescription = noData
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
			data = try container.decode(PrimaryResourceBody.self, forKey: .data)
		}

		let maybeIncludes = try container.decodeIfPresent(Includes<Include>.self, forKey: .included)
		
		// TODO come back to this and make robust

		guard let metaVal = meta else {
			throw JSONAPIEncodingError.missingOrMalformedMetadata
		}
		guard let linksVal = links else {
			throw JSONAPIEncodingError.missingOrMalformedLinks
		}
		
		body = .data(.init(primary: data, includes: maybeIncludes ?? Includes<Include>.none, meta: metaVal, links: linksVal))
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
