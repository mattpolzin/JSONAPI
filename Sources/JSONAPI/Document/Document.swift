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
	associatedtype Error: JSONAPIError

	typealias Body = Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, Error>.Body

	var body: Body { get }
}

/// A JSON API Document represents the entire body
/// of a JSON API request or the entire body of
/// a JSON API response.
/// Note that this type uses Camel case. If your
/// API uses snake case, you will want to use
/// a conversion such as the one offerred by the
/// Foundation JSONEncoder/Decoder: `KeyDecodingStrategy`
public struct Document<PrimaryResourceBody: JSONAPI.ResourceBody, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links, IncludeType: JSONAPI.Include, Error: JSONAPIError>: JSONAPIDocument {
	public typealias Include = IncludeType

	public let body: Body
//	public let jsonApi: APIDescription?
	
	public enum Body: Equatable {
		case errors([Error], meta: MetaType?, links: LinksType?)
		case data(Data)

		public struct Data: Equatable {
			public let primary: PrimaryResourceBody
			public let includes: Includes<Include>
			public let meta: MetaType
			public let links: LinksType
		}

		public var isError: Bool {
			guard case .errors = self else { return false }
			return true
		}

		public var errors: [Error]? {
			guard case let .errors(errors, meta: _, links: _) = self else { return nil }
			return errors
		}
		
		public var primaryData: PrimaryResourceBody? {
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

	public init(errors: [Error], meta: MetaType? = nil, links: LinksType? = nil) {
		body = .errors(errors, meta: meta, links: links)
	}

	public init(body: PrimaryResourceBody, includes: Includes<Include>, meta: MetaType, links: LinksType) {
		self.body = .data(.init(primary: body, includes: includes, meta: meta, links: links))
	}
}

extension Document where IncludeType == NoIncludes {
	public init(body: PrimaryResourceBody, meta: MetaType, links: LinksType) {
		self.body = .data(.init(primary: body, includes: .none, meta: meta, links: links))
	}
}

extension Document where MetaType == NoMetadata {
	public init(body: PrimaryResourceBody, includes: Includes<Include>, links: LinksType) {
		self.body = .data(.init(primary: body, includes: includes, meta: .none, links: links))
	}
}

extension Document where LinksType == NoLinks {
	public init(body: PrimaryResourceBody, includes: Includes<Include>, meta: MetaType) {
		self.body = .data(.init(primary: body, includes: includes, meta: meta, links: .none))
	}
}

extension Document where IncludeType == NoIncludes, LinksType == NoLinks {
	public init(body: PrimaryResourceBody, meta: MetaType) {
		self.body = .data(.init(primary: body, includes: .none, meta: meta, links: .none))
	}
}

extension Document where IncludeType == NoIncludes, MetaType == NoMetadata {
	public init(body: PrimaryResourceBody, links: LinksType) {
		self.body = .data(.init(primary: body, includes: .none, meta: .none, links: links))
	}
}

extension Document where MetaType == NoMetadata, LinksType == NoLinks {
	public init(body: PrimaryResourceBody, includes: Includes<Include>) {
		self.body = .data(.init(primary: body, includes: includes, meta: .none, links: .none))
	}
}

extension Document where IncludeType == NoIncludes, MetaType == NoMetadata, LinksType == NoLinks {
	public init(body: PrimaryResourceBody) {
		self.body = .data(.init(primary: body, includes: .none, meta: .none, links: .none))
	}
}

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
