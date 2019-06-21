//
//  AttributeTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/27/18.
//

import XCTest
import JSONAPI

class AttributeTests: XCTestCase {

	func test_AttributeConstructor() {
		XCTAssertEqual(Attribute<String>(value: "hello").value, "hello")
	}

	func test_TransformedAttributeNoThrow() {
		XCTAssertNoThrow(try TransformedAttribute<String, TestTransformer>(rawValue: "10"))
	}

	func test_TransformedAttributeThrows() {
		XCTAssertThrowsError(try TransformedAttribute<String, TestTransformer>(rawValue: "10.3"))
	}

	func test_TransformedAttributeReversNoThrow() {
		XCTAssertNoThrow(try TransformedAttribute<String, TestTransformer>(transformedValue: 10))
	}

	func test_EncodedPrimitives() {
		testEncodedPrimitive(attribute: Attribute<Int>(value: 10))
		testEncodedPrimitive(attribute: Attribute<Bool>(value: false))
		testEncodedPrimitive(attribute: Attribute<Double>(value: 10.2))

		testEncodedPrimitive(attribute: try! TransformedAttribute<Int, IntToString>(rawValue: 10))
		testEncodedPrimitive(attribute: try! TransformedAttribute<Int, IntToInt>(rawValue: 10))
		testEncodedPrimitive(attribute: try! TransformedAttribute<Int, IntToDouble>(rawValue: 10))
		testEncodedPrimitive(attribute: try! TransformedAttribute<String, TestTransformer>(rawValue: "10"))
		testEncodedPrimitive(attribute: try! TransformedAttribute<String?, OptionalToString<String>>(rawValue: "10"))
	}

	func test_NullableIsNullIfNil() {
		struct Wrapper: Codable {
			let dummy: Attribute<String?>
		}
		let data = encoded(value: Wrapper(dummy: .init(value: nil)))
		let string = String(data: data, encoding: .utf8)!

		XCTAssertEqual(string, "{\"dummy\":null}")
	}

	func test_NullableIsEqualToNonNullableIfNotNil() {
		struct Wrapper1: Codable {
			let dummy: Attribute<String?>
		}
		struct Wrapper2: Codable {
			let dummy: Attribute<String>
		}
		let data1 = encoded(value: Wrapper1(dummy: .init(value: "hello")))
		let data2 = encoded(value: Wrapper2(dummy: .init(value: "hello")))

		XCTAssertEqual(data1, data2)
	}
}

// MARK: Property Wrappers
extension AttributeTests {
    func test_Transformed() {

        struct Test: Codable {
            @Transformed(IntToString.self)
            var value: String = ""
        }

        let test = Test(value: "hello")
        XCTAssertEqual(test.value, "hello")

        let test2 = try! JSONDecoder().decode(Test.self,
                                              from: #"{"value": 12}"#.data(using: .utf8)!)

        XCTAssertEqual(test2.value, "12")
        try! print(String(data: JSONEncoder().encode(test2), encoding: .utf8)!)

        let test3 = try? JSONDecoder().decode(Test.self,
                                              from: #"{"value": null}"#.data(using: .utf8)!)

        XCTAssertNil(test3)
    }

    func test_Nullable() {
        struct Test: Codable {
            @Nullable
            var value: String?
        }

        let test = Test(value: nil)
        XCTAssertNil(test.value)

        let test2 = Test(value: "hello")
        XCTAssertEqual(test2.value, "hello")

        let test3 = try! JSONDecoder().decode(Test.self,
                                              from: #"{"value": "world"}"#.data(using: .utf8)!)

        XCTAssertEqual(test3.value, "world")
        try! print(String(data: JSONEncoder().encode(test2), encoding: .utf8)!)

        let test4 = try? JSONDecoder().decode(Test.self,
                                              from: #"{"value": null}"#.data(using: .utf8)!)

        XCTAssertNotNil(test4)
        XCTAssertNil(test4?.value)
    }

    func test_NullableTransformed() {
        struct Test: Codable {
//            Nullable<Transformed<IntToString>>
            let x: Transformed<IntToString>
//            @Nullable @Transformed(IdentityTransformer.self)
            @Transformed(IntToString.self) @Nullable
            var value: String?
        }

        let test = Test(x: .init(initialValue: "12", IntToString.self))

        print(test.x.wrappedValue)
    }
}

// MARK: Test types
extension AttributeTests {
	enum TestTransformer: ReversibleTransformer {
		public static func transform(_ value: String) throws -> Int {
			guard let ret = Int(value) else {
				throw DecodingError.typeMismatch(Int.self, .init(codingPath: [], debugDescription: "Expected Int from String."))
			}
			return ret
		}

		public static func reverse(_ value: Int) throws -> String {
			return String(value)
		}
	}

	enum IntToString: ReversibleTransformer {
		public static func transform(_ from: Int) -> String {
			return String(from)
		}

        public static func reverse(_ value: String) throws -> Int {
            guard let intValue = Int(value) else {
                fatalError("Reversed IntToString with invalid String value.")
            }
            return intValue
        }
	}

    enum OptionalIntToOptionalString: ReversibleTransformer {
        public static func transform(_ from: Int?) -> String? {
            return from.map(String.init)
        }

        public static func reverse(_ value: String?) throws -> Int? {
            guard let stringValue = value else {
                return nil
            }

            guard let intValue = Int(stringValue) else {
                fatalError("Reversed IntToString with invalid String value.")
            }

            return intValue
        }
    }

	enum IntToInt: Transformer {
		public static func transform(_ from: Int) -> Int {
			return from + 100
		}
	}

	enum IntToDouble: Transformer {
		public static func transform(_ from: Int) -> Double {
			return Double(from)
		}
	}

	enum OptionalToString<T>: Transformer {
		public static func transform(_ from: T?) -> String {
			return String(describing: from)
		}
	}
}
