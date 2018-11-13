//
//  String+CreatableRawIdType.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

import JSONAPI

private var uniqueStringCounter = 0

extension String: CreatableRawIdType {
	public static func unique() -> String {
		uniqueStringCounter += 1
		return String(uniqueStringCounter)
	}
}
