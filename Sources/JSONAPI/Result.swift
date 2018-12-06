//
//  Result.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 12/5/18.
//

enum Result<T, E: Swift.Error> {
	case success(T)
	case failure(E)

	var value: T? {
		guard case .success(let val) = self else {
			return nil
		}
		return val
	}

	var error: E? {
		guard case .failure(let err) = self else {
			return nil
		}
		return err
	}

	func map<U>(_ transform: (T) -> U) -> Result<U, E> {
		switch self {
		case .failure(let err):
			return .failure(err)
		case .success(let val):
			return .success(transform(val))
		}
	}
}

extension Result: CustomStringConvertible where T: CustomStringConvertible, E: CustomStringConvertible {
	var description: String {
		switch self {
		case .success(let val):
			return String(describing: val)
		case .failure(let err):
			return String(describing: err)
		}
	}
}
