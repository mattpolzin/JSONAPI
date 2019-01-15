//
//  Relationship+Arbitrary.swift
//  JSONAPIArbitrary
//
//  Created by Mathew Polzin on 1/15/19.
//

import SwiftCheck
import JSONAPI

extension ToOneRelationship: Arbitrary where Identifiable.Identifier: Arbitrary, MetaType: Arbitrary, LinksType: Arbitrary {
	public static var arbitrary: Gen<ToOneRelationship<Identifiable, MetaType, LinksType>> {
		return Gen.compose { c in
			return .init(id: c.generate(),
						 meta: c.generate(),
						 links: c.generate())
		}
	}
}

extension ToOneRelationship where MetaType: Arbitrary, LinksType: Arbitrary {
	public static func arbitrary<E: EntityType>(givenEntities: [E]) -> Gen<ToOneRelationship<Identifiable, MetaType, LinksType>> where E.Id == Identifiable.Identifier {

		return Gen.compose { c in
			let idGen = Gen.fromElements(of: givenEntities).map { $0.id }
			return .init(id: c.generate(using: idGen),
						 meta: c.generate(),
						 links: c.generate())
		}
	}
}

extension ToManyRelationship: Arbitrary where Relatable.Identifier: Arbitrary, MetaType: Arbitrary, LinksType: Arbitrary {
	public static var arbitrary: Gen<ToManyRelationship<Relatable, MetaType, LinksType>> {
		return Gen.compose { c in
			return .init(ids: c.generate(),
						 meta: c.generate(),
						 links: c.generate())
		}
	}
}

extension ToManyRelationship where MetaType: Arbitrary, LinksType: Arbitrary {
	public static func arbitrary<E: EntityType>(givenEntities: [E]) -> Gen<ToManyRelationship<Relatable, MetaType, LinksType>> where E.Id == Relatable.Identifier {
		return Gen.compose { c in
			let idsGen = Gen.fromElements(of: givenEntities).map { $0.id }.proliferate
			return .init(ids: c.generate(using: idsGen),
						 meta: c.generate(),
						 links: c.generate())
		}
	}
}
