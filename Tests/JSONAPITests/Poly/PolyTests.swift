//
//  PolyTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/23/18.
//

import XCTest
import JSONAPI

// MARK: - init
class PolyTests: XCTestCase {
	func test_init_Poly0() {
		let _ = Poly0()
	}

	func test_init_Poly1() {
		let entity = TestEntity5()
		let poly = Poly1(entity)
		XCTAssertEqual(poly.a, entity)
	}

	func test_init_Poly2() {
		let entity = TestEntity5()
		let poly = Poly2<TestEntity5, TestEntity>(entity)
		XCTAssertEqual(poly.a, entity)
		XCTAssertNil(poly.b)

		let poly2 = Poly2<TestEntity, TestEntity5>(entity)
		XCTAssertEqual(poly2.b, entity)
		XCTAssertNil(poly2.a)
	}

	func test_init_Poly3() {
		let entity = TestEntity5()
		let poly = Poly3<TestEntity5, TestEntity, TestEntity2>(entity)
		XCTAssertEqual(poly.a, entity)
		XCTAssertNil(poly.b)
		XCTAssertNil(poly.c)

		let poly2 = Poly3<TestEntity, TestEntity5, TestEntity2>(entity)
		XCTAssertEqual(poly2.b, entity)
		XCTAssertNil(poly2.a)
		XCTAssertNil(poly2.c)

		let poly3 = Poly3<TestEntity, TestEntity2, TestEntity5>(entity)
		XCTAssertEqual(poly3.c, entity)
		XCTAssertNil(poly3.a)
		XCTAssertNil(poly3.b)
	}

	func test_init_Poly4() {
		let entity = TestEntity5()
		let poly = Poly4<TestEntity5, TestEntity, TestEntity2, TestEntity3>(entity)
		XCTAssertEqual(poly.a, entity)
		XCTAssertNil(poly.b)
		XCTAssertNil(poly.c)
		XCTAssertNil(poly.d)

		let poly2 = Poly4<TestEntity, TestEntity5, TestEntity2, TestEntity3>(entity)
		XCTAssertEqual(poly2.b, entity)
		XCTAssertNil(poly2.a)
		XCTAssertNil(poly2.c)
		XCTAssertNil(poly2.d)

		let poly3 = Poly4<TestEntity, TestEntity2, TestEntity5, TestEntity3>(entity)
		XCTAssertEqual(poly3.c, entity)
		XCTAssertNil(poly3.a)
		XCTAssertNil(poly3.b)
		XCTAssertNil(poly3.d)

		let poly4 = Poly4<TestEntity, TestEntity2, TestEntity3, TestEntity5>(entity)
		XCTAssertEqual(poly4.d, entity)
		XCTAssertNil(poly4.a)
		XCTAssertNil(poly4.b)
		XCTAssertNil(poly4.c)
	}

	func test_init_Poly5() {
		let entity = TestEntity5()
		let poly = Poly5<TestEntity5, TestEntity, TestEntity2, TestEntity3, TestEntity4>(entity)
		XCTAssertEqual(poly.a, entity)
		XCTAssertNil(poly.b)
		XCTAssertNil(poly.c)
		XCTAssertNil(poly.d)
		XCTAssertNil(poly.e)

		let poly2 = Poly5<TestEntity, TestEntity5, TestEntity2, TestEntity3, TestEntity4>(entity)
		XCTAssertEqual(poly2.b, entity)
		XCTAssertNil(poly2.a)
		XCTAssertNil(poly2.c)
		XCTAssertNil(poly2.d)
		XCTAssertNil(poly2.e)

		let poly3 = Poly5<TestEntity, TestEntity2, TestEntity5, TestEntity3, TestEntity4>(entity)
		XCTAssertEqual(poly3.c, entity)
		XCTAssertNil(poly3.a)
		XCTAssertNil(poly3.b)
		XCTAssertNil(poly3.d)
		XCTAssertNil(poly3.e)

		let poly4 = Poly5<TestEntity, TestEntity2, TestEntity3, TestEntity5, TestEntity4>(entity)
		XCTAssertEqual(poly4.d, entity)
		XCTAssertNil(poly4.a)
		XCTAssertNil(poly4.b)
		XCTAssertNil(poly4.c)
		XCTAssertNil(poly4.e)

		let poly5 = Poly5<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5>(entity)
		XCTAssertEqual(poly5.e, entity)
		XCTAssertNil(poly5.a)
		XCTAssertNil(poly5.b)
		XCTAssertNil(poly5.c)
		XCTAssertNil(poly5.d)
	}

	func test_init_Poly6() {
		let entity = TestEntity5()
		let poly = Poly6<TestEntity5, TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity6>(entity)
		XCTAssertEqual(poly.a, entity)
		XCTAssertNil(poly.b)
		XCTAssertNil(poly.c)
		XCTAssertNil(poly.d)
		XCTAssertNil(poly.e)
		XCTAssertNil(poly.f)

		let poly2 = Poly6<TestEntity, TestEntity5, TestEntity2, TestEntity3, TestEntity4, TestEntity6>(entity)
		XCTAssertEqual(poly2.b, entity)
		XCTAssertNil(poly2.a)
		XCTAssertNil(poly2.c)
		XCTAssertNil(poly2.d)
		XCTAssertNil(poly2.e)
		XCTAssertNil(poly2.f)

		let poly3 = Poly6<TestEntity, TestEntity2, TestEntity5, TestEntity3, TestEntity4, TestEntity6>(entity)
		XCTAssertEqual(poly3.c, entity)
		XCTAssertNil(poly3.a)
		XCTAssertNil(poly3.b)
		XCTAssertNil(poly3.d)
		XCTAssertNil(poly3.e)
		XCTAssertNil(poly3.f)

		let poly4 = Poly6<TestEntity, TestEntity2, TestEntity3, TestEntity5, TestEntity4, TestEntity6>(entity)
		XCTAssertEqual(poly4.d, entity)
		XCTAssertNil(poly4.a)
		XCTAssertNil(poly4.b)
		XCTAssertNil(poly4.c)
		XCTAssertNil(poly4.e)
		XCTAssertNil(poly4.f)

		let poly5 = Poly6<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6>(entity)
		XCTAssertEqual(poly5.e, entity)
		XCTAssertNil(poly5.a)
		XCTAssertNil(poly5.b)
		XCTAssertNil(poly5.c)
		XCTAssertNil(poly5.d)
		XCTAssertNil(poly5.f)

		let poly6 = Poly6<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity6, TestEntity5>(entity)
		XCTAssertEqual(poly6.f, entity)
		XCTAssertNil(poly6.a)
		XCTAssertNil(poly6.b)
		XCTAssertNil(poly6.c)
		XCTAssertNil(poly6.d)
		XCTAssertNil(poly6.e)
	}
}

// MARK: - subscript lookup
extension PolyTests {
	func test_Poly1_lookup() {
		let entity = decoded(type: TestEntity.self, data: poly_entity1)
		let poly = decoded(type: Poly1<TestEntity>.self, data: poly_entity1)

		XCTAssertEqual(entity, poly[TestEntity.self])
	}

	func test_Poly2_lookup() {
		let entity = decoded(type: TestEntity2.self, data: poly_entity2)
		let poly = decoded(type: Poly2<TestEntity, TestEntity2>.self, data: poly_entity2)

		XCTAssertNil(poly[TestEntity.self])
		XCTAssertEqual(entity, poly[TestEntity2.self])
	}

	func test_Poly3_lookup() {
		let entity = decoded(type: TestEntity3.self, data: poly_entity3)
		let poly = decoded(type: Poly3<TestEntity, TestEntity2, TestEntity3>.self, data: poly_entity3)

		XCTAssertNil(poly[TestEntity.self])
		XCTAssertNil(poly[TestEntity2.self])
		XCTAssertEqual(entity, poly[TestEntity3.self])
	}

	func test_Poly4_lookup() {
		let entity = decoded(type: TestEntity4.self, data: poly_entity4)
		let poly = decoded(type: Poly4<TestEntity, TestEntity2, TestEntity3, TestEntity4>.self, data: poly_entity4)

		XCTAssertNil(poly[TestEntity.self])
		XCTAssertNil(poly[TestEntity2.self])
		XCTAssertNil(poly[TestEntity3.self])
		XCTAssertEqual(entity, poly[TestEntity4.self])
	}

	func test_Poly5_lookup() {
		let entity = decoded(type: TestEntity5.self, data: poly_entity5)
		let poly = decoded(type: Poly5<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5>.self, data: poly_entity5)

		XCTAssertNil(poly[TestEntity.self])
		XCTAssertNil(poly[TestEntity2.self])
		XCTAssertNil(poly[TestEntity3.self])
		XCTAssertNil(poly[TestEntity4.self])
		XCTAssertEqual(entity, poly[TestEntity5.self])
	}

	func test_Poly6_lookup() {
		let entity = decoded(type: TestEntity6.self, data: poly_entity6)
		let poly = decoded(type: Poly6<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6>.self, data: poly_entity6)

		XCTAssertNil(poly[TestEntity.self])
		XCTAssertNil(poly[TestEntity2.self])
		XCTAssertNil(poly[TestEntity3.self])
		XCTAssertNil(poly[TestEntity4.self])
		XCTAssertNil(poly[TestEntity5.self])
		XCTAssertEqual(entity, poly[TestEntity6.self])
	}
}

// MARK: - failures
extension PolyTests {
	func test_Poly0_encode_throws() {
		XCTAssertThrowsError(try JSONEncoder().encode(Poly0()))
	}

	func test_Poly0_decode_throws() {
		XCTAssertThrowsError(try JSONDecoder().decode(Poly0.self, from: poly_entity1))
	}

	func test_Poly1_decode_throws_typeNotFound() {
		XCTAssertThrowsError(try JSONDecoder().decode(Poly1<TestEntity>.self, from: poly_entity2))
	}

	func test_Poly2_decode_throws_typeNotFound() {
		XCTAssertThrowsError(try JSONDecoder().decode(Poly2<TestEntity, TestEntity2>.self, from: poly_entity3))
	}

	func test_Poly3_decode_throws_typeNotFound() {
		XCTAssertThrowsError(try JSONDecoder().decode(Poly3<TestEntity, TestEntity2, TestEntity3>.self, from: poly_entity4))
	}

	func test_Poly4_decode_throws_typeNotFound() {
		XCTAssertThrowsError(try JSONDecoder().decode(Poly4<TestEntity, TestEntity2, TestEntity3, TestEntity4>.self, from: poly_entity5))
	}

	func test_Poly5_decode_throws_typeNotFound() {
		XCTAssertThrowsError(try JSONDecoder().decode(Poly5<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5>.self, from: poly_entity6))
	}

	func test_Poly6_decode_throws_typeNotFound() {
		XCTAssertThrowsError(try JSONDecoder().decode(Poly6<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6>.self, from: poly_entity7))
	}
}

// MARK: - Test types
extension PolyTests {
	enum TestEntityType: EntityDescription {

		typealias Relationships = NoRelationships

		public static var type: String { return "test_entity1" }

		public struct Attributes: JSONAPI.Attributes {
			let foo: Attribute<String>
			let bar: Attribute<Int>
		}
	}

	typealias TestEntity = BasicEntity<TestEntityType>

	enum TestEntityType2: EntityDescription {

		public static var type: String { return "test_entity2" }

		public struct Relationships: JSONAPI.Relationships {
			let entity1: ToOneRelationship<TestEntity, NoMetadata, NoLinks>
		}

		public struct Attributes: JSONAPI.Attributes {
			let foo: Attribute<String>
			let bar: Attribute<Int>
		}
	}

	typealias TestEntity2 = BasicEntity<TestEntityType2>

	enum TestEntityType3: EntityDescription {

		typealias Attributes = NoAttributes

		public static var type: String { return "test_entity3" }

		public struct Relationships: JSONAPI.Relationships {
			let entity1: ToOneRelationship<TestEntity, NoMetadata, NoLinks>
			let entity2: ToManyRelationship<TestEntity2, NoMetadata, NoLinks>
		}
	}

	typealias TestEntity3 = BasicEntity<TestEntityType3>

	enum TestEntityType4: EntityDescription {

		typealias Attributes = NoAttributes

		typealias Relationships = NoRelationships

		public static var type: String { return "test_entity4" }
	}

	typealias TestEntity4 = BasicEntity<TestEntityType4>

	enum TestEntityType5: EntityDescription {

		typealias Attributes = NoAttributes

		typealias Relationships = NoRelationships

		public static var type: String { return "test_entity5" }
	}

	typealias TestEntity5 = BasicEntity<TestEntityType5>

	enum TestEntityType6: EntityDescription {

		typealias Attributes = NoAttributes

		public static var type: String { return "test_entity6" }

		struct Relationships: JSONAPI.Relationships {
			let entity4: ToOneRelationship<TestEntity4, NoMetadata, NoLinks>
		}
	}

	typealias TestEntity6 = BasicEntity<TestEntityType6>
}
