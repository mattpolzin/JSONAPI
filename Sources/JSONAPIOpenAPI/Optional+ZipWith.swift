//
//  Optional+ZipWith.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/19/19.
//

func zip<X, Y, Z>(_ left: X?, _ right: Y?, with fn: (X, Y) -> Z) -> Z? {
	return left.flatMap { lft in right.map { rght in fn(lft, rght) }}
}
