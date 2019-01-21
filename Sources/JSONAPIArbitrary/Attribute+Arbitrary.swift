//
//  Attribute+Arbitrary.swift
//  JSONAPIArbitrary
//
//  Created by Mathew Polzin on 1/15/19.
//

import SwiftCheck
import JSONAPI

extension Attribute: Arbitrary where RawValue: Arbitrary {
	public static var arbitrary: Gen<Attribute<RawValue>> {
		return RawValue.arbitrary.map { .init(value: $0) }
	}
}

// Cannot conform TransformedAttribute to Arbitrary here
// because there is no way to guarantee that an arbitrary
// RawValue will successfully transform or that an
// arbitrary Value will successfully reverse-transform.
