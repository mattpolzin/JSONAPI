//
//  JSONAPIDocument.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/5/18.
//

/// A JSON API Document represents the entire body
/// of a JSON API request or the entire body of
/// a JSON API response.
/// Note that this type uses Camel case. If your
/// API uses snake case, you will want to use
/// a conversion such as the one offerred by the
/// Foundation JSONEncoder/Decoder: `KeyDecodingStrategy`
public struct JSONAPIDocument<ResourceBody: JSONAPI.ResourceBody, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links, IncludeType: JSONAPI.Include, Error: JSONAPIError>: Equatable {
	public typealias Include = IncludeType

	public let body: Body
//	public let jsonApi: APIDescription?
	
	public enum Body: Equatable {
		case errors([Error], meta: MetaType?, links: LinksType?)
		case data(primary: ResourceBody, included: Includes<Include>, meta: MetaType, links: LinksType)

		public var isError: Bool {
			guard case .errors = self else { return false }
			return true
		}

		public var errors: [Error]? {
			guard case let .errors(errors, meta: _, links: _) = self else { return nil }
			return errors
		}
		
		public var primaryData: ResourceBody? {
			guard case let .data(primary: body, included: _, meta: _, links: _) = self else { return nil }
			return body
		}

		public var includes: Includes<Include>? {
			guard case let .data(primary: _, included: includes, meta: _, links: _) = self else { return nil }
			return includes
		}

		public var meta: MetaType? {
			switch self {
			case .data(primary: _, included: _, meta: let metadata, links: _),
				 .errors(_, meta: let metadata?, links: _):
				return metadata
			default:
				return nil
			}
		}

		public var links: LinksType? {
			switch self {
			case .data(primary: _, included: _, meta: _, links: let links),
				 .errors(_, meta: _, links: let links?):
				return links
			default:
				return nil
			}
		}
	}

	public init(errors: [Error], meta: MetaType? = nil, links: LinksType? = nil) {
		body = .errors(errors, meta: meta, links: links)
	}

	public init(body: ResourceBody, includes: Includes<Include>, meta: MetaType, links: LinksType) {
		self.body = .data(primary: body, included: includes, meta: meta, links: links)
	}
}

extension JSONAPIDocument where IncludeType == NoIncludes {
	public init(body: ResourceBody, meta: MetaType, links: LinksType) {
		self.body = .data(primary: body, included: .none, meta: meta, links: links)
	}
}

extension JSONAPIDocument where MetaType == NoMetadata {
	public init(body: ResourceBody, includes: Includes<Include>, links: LinksType) {
		self.body = .data(primary: body, included: includes, meta: .none, links: links)
	}
}

extension JSONAPIDocument where LinksType == NoLinks {
	public init(body: ResourceBody, includes: Includes<Include>, meta: MetaType) {
		self.body = .data(primary: body, included: includes, meta: meta, links: .none)
	}
}

extension JSONAPIDocument where IncludeType == NoIncludes, LinksType == NoLinks {
	public init(body: ResourceBody, meta: MetaType) {
		self.body = .data(primary: body, included: .none, meta: meta, links: .none)
	}
}

extension JSONAPIDocument where IncludeType == NoIncludes, MetaType == NoMetadata {
	public init(body: ResourceBody, links: LinksType) {
		self.body = .data(primary: body, included: .none, meta: .none, links: links)
	}
}

extension JSONAPIDocument where MetaType == NoMetadata, LinksType == NoLinks {
	public init(body: ResourceBody, includes: Includes<Include>) {
		self.body = .data(primary: body, included: includes, meta: .none, links: .none)
	}
}

extension JSONAPIDocument where IncludeType == NoIncludes, MetaType == NoMetadata, LinksType == NoLinks {
	public init(body: ResourceBody) {
		self.body = .data(primary: body, included: .none, meta: .none, links: .none)
	}
}

extension JSONAPIDocument: Codable {
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

		let data: ResourceBody
		if let noData = NoResourceBody() as? ResourceBody {
			data = noData
		} else {
			data = try container.decode(ResourceBody.self, forKey: .data)
		}

		let maybeIncludes = try container.decodeIfPresent(Includes<Include>.self, forKey: .included)
		
		// TODO come back to this and make robust

		guard let metaVal = meta else {
			throw JSONAPIEncodingError.missingOrMalformedMetadata
		}
		guard let linksVal = links else {
			throw JSONAPIEncodingError.missingOrMalformedLinks
		}
		
		body = .data(primary: data, included: maybeIncludes ?? Includes<Include>.none, meta: metaVal, links: linksVal)
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

		case .data(primary: let resourceBody, included: let includes, let meta, links: let links):
			try container.encode(resourceBody, forKey: .data)

			if Include.self != NoIncludes.self {
				try container.encode(includes, forKey: .included)
			}

			if MetaType.self != NoMetadata.self {
				try container.encode(meta, forKey: .meta)
			}

			if LinksType.self != NoLinks.self {
				try container.encode(links, forKey: .links)
			}
		}
	}
}

// MARK: - CustomStringConvertible

extension JSONAPIDocument: CustomStringConvertible {
	public var description: String {
		return "JSONAPIDocument(body: \(String(describing: body))"
	}
}
