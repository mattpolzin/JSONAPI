//
//  ResourceBody+Arbitrary.swift
//  JSONAPIArbitrary
//
//  Created by Mathew Polzin on 1/21/19.
//

import SwiftCheck
import JSONAPI

extension SingleResourceBody: Arbitrary where Entity: Arbitrary {
	public static var arbitrary: Gen<SingleResourceBody<Entity>> {
		return Entity.arbitrary.map(SingleResourceBody.init(entity:))
	}
}

extension ManyResourceBody: Arbitrary where Entity: Arbitrary {
	public static var arbitrary: Gen<ManyResourceBody<Entity>> {
		return Entity.arbitrary.proliferate.map(ManyResourceBody.init(entities:))
	}
}

extension NoResourceBody: Arbitrary {
	public static var arbitrary: Gen<NoResourceBody> {
		return Gen.pure(.none)
	}
}
