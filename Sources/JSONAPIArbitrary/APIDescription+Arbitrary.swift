//
//  APIDescription+Arbitrary.swift
//  JSONAPIArbitrary
//
//  Created by Mathew Polzin on 1/21/19.
//

import SwiftCheck
import JSONAPI

extension APIDescription: Arbitrary where Meta: Arbitrary {
	public static var arbitrary: Gen<APIDescription<Meta>> {
		return Gen.compose { c in
			APIDescription(version: c.generate(),
						   meta: c.generate())
		}
	}
}

extension NoAPIDescription: Arbitrary {
	public static var arbitrary: Gen<NoAPIDescription> {
		return Gen.pure(.none)
	}
}
