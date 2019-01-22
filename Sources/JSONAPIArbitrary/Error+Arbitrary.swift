//
//  Error+Arbitrary.swift
//  JSONAPIArbitrary
//
//  Created by Mathew Polzin on 1/21/19.
//

import SwiftCheck
import JSONAPI

extension UnknownJSONAPIError: Arbitrary {
	public static var arbitrary: Gen<UnknownJSONAPIError> {
		return Gen.pure(.unknownError)
	}
}
