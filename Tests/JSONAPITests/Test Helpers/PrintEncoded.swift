//
//  PrintEncoded.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 12/8/18.
//

import Foundation

func print<T: Encodable>(encodable: T) {
	print(String(data: try! JSONEncoder().encode(encodable), encoding: .utf8)!)
}
