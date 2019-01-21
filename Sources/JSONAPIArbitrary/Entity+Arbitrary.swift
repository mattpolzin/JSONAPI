//
//  Entity+Arbitrary.swift
//  JSONAPIArbitrary
//
//  Created by Mathew Polzin on 1/14/19.
//

import SwiftCheck
import JSONAPI

extension NoMetadata: Arbitrary {
	public static var arbitrary: Gen<NoMetadata> {
		return Gen.pure(.none)
	}
}

extension NoLinks: Arbitrary {
	public static var arbitrary: Gen<NoLinks> {
		return Gen.pure(.none)
	}
}

extension NoAttributes: Arbitrary {
	public static var arbitrary: Gen<NoAttributes> {
		return Gen.pure(.none)
	}
}

extension NoRelationships: Arbitrary {
	public static var arbitrary: Gen<NoRelationships> {
		return Gen.pure(.none)
	}
}

// NOTE: Arbitrary conformance for MetaType, LinksType, Description.Attributes,
// and Description.Relationships must all be provided BY YOU for Entity to
// gain Arbitrary conformance (with the exception of NoMetadata, NoLinks,
// NoAttributes, and NoRelationships which all have Arbitrary conformance
// out of the box).
extension Entity: Arbitrary where MetaType: Arbitrary, LinksType: Arbitrary, Description.Attributes: Arbitrary, Description.Relationships: Arbitrary, EntityRawIdType: Arbitrary {
	public static var arbitrary: Gen<Entity<Description, MetaType, LinksType, EntityRawIdType>> {
		return Gen.compose { c in
			Entity(id: c.generate(),
				   attributes: c.generate(),
				   relationships: c.generate(),
				   meta: c.generate(),
				   links: c.generate())
		}
	}
}
