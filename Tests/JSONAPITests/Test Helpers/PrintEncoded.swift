//
//  PrintEncoded.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 12/8/18.
//

import Foundation

/// Print the UTF8 encoded String value of data produced by encoding the given object.
func print<T: Encodable>(encodable: T) {
	print(String(data: try! JSONEncoder().encode(encodable), encoding: .utf8)!)
}
