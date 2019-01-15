//
//  Id+Arbitrary.swift
//  JSONAPIArbitrary
//
//  Created by Mathew Polzin on 1/14/19.
//

import SwiftCheck
import JSONAPI

extension Unidentified: Arbitrary {
	public static var arbitrary: Gen<Unidentified> {
		return Gen.pure(.init())
	}
}

extension Id: Arbitrary where RawType: Arbitrary {
	public static var arbitrary: Gen<Id<RawType, IdentifiableType>> {
		return RawType.arbitrary.map { Id(rawValue: $0) }
	}
}
