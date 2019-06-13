
import XCTest
@testable import JSONAPI

class IncludedTests: XCTestCase {

	func test_zeroIncludes_init() {
		let includes = Includes()
		XCTAssertEqual(includes.count, 0)
	}

	func test_zeroIncludes() {
		let includes = decoded(type: Includes<NoIncludes>.self,
												data: two_same_type_includes)
		
		XCTAssertEqual(includes.count, 0)
	}

	func test_zeroIncludes_encode() {
		XCTAssertThrowsError(try JSONEncoder().encode(decoded(type: Includes<NoIncludes>.self,
														  data: two_same_type_includes)))
	}
	
	func test_OneInclude() {
		let includes = decoded(type: Includes<Include1<TestEntity>>.self,
							   data: one_include)

		XCTAssertEqual(includes[TestEntity.self].count, 1)
	}

	func test_OneInclude_encode() {
		test_DecodeEncodeEquality(type: Includes<Include1<TestEntity>>.self,
							   data: one_include)
	}
	
	func test_TwoSameIncludes() {
		let includes = decoded(type: Includes<Include1<TestEntity>>.self,
							   data: two_same_type_includes)
		
		XCTAssertEqual(includes[TestEntity.self].count, 2)
	}

	func test_TwoSameIncludes_encode() {
		test_DecodeEncodeEquality(type: Includes<Include1<TestEntity>>.self,
							   data: two_same_type_includes)
	}
	
	func test_TwoDifferentIncludes() {
		let includes = decoded(type: Includes<Include2<TestEntity, TestEntity2>>.self,
									data: two_different_type_includes)

		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
	}

	func test_TwoDifferentIncludes_encode() {
		test_DecodeEncodeEquality(type: Includes<Include2<TestEntity, TestEntity2>>.self,
							   data: two_different_type_includes)
	}
	
	func test_ThreeDifferentIncludes() {
		let includes = decoded(type: Includes<Include3<TestEntity, TestEntity2, TestEntity4>>.self,
							   data: three_different_type_includes)

		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
	}

	func test_ThreeDifferentIncludes_encode() {
		test_DecodeEncodeEquality(type: Includes<Include3<TestEntity, TestEntity2, TestEntity4>>.self,
							   data: three_different_type_includes)
	}
	
	func test_FourDifferentIncludes() {
		let includes = decoded(type: Includes<Include4<TestEntity, TestEntity2, TestEntity4, TestEntity6>>.self,
							   data: four_different_type_includes)
		
		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
		XCTAssertEqual(includes[TestEntity6.self].count, 1)
	}

	func test_FourDifferentIncludes_encode() {
		test_DecodeEncodeEquality(type: Includes<Include4<TestEntity, TestEntity2, TestEntity4, TestEntity6>>.self,
							   data: four_different_type_includes)
	}
	
	func test_FiveDifferentIncludes() {
		let includes = decoded(type: Includes<Include5<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity6>>.self,
							   data: five_different_type_includes)
		
		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity3.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
		XCTAssertEqual(includes[TestEntity6.self].count, 1)
	}

	func test_FiveDifferentIncludes_encode() {
		test_DecodeEncodeEquality(type: Includes<Include5<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity6>>.self,
							   data: five_different_type_includes)
	}
	
	func test_SixDifferentIncludes() {
		let includes = decoded(type: Includes<Include6<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6>>.self,
							   data: six_different_type_includes)
		
		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity3.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
		XCTAssertEqual(includes[TestEntity5.self].count, 1)
		XCTAssertEqual(includes[TestEntity6.self].count, 1)
	}

	func test_SixDifferentIncludes_encode() {
		test_DecodeEncodeEquality(type: Includes<Include6<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6>>.self,
							   data: six_different_type_includes)
	}

	func test_SevenDifferentIncludes() {
		let includes = decoded(type: Includes<Include7<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7>>.self,
							   data: seven_different_type_includes)

		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity3.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
		XCTAssertEqual(includes[TestEntity5.self].count, 1)
		XCTAssertEqual(includes[TestEntity6.self].count, 1)
		XCTAssertEqual(includes[TestEntity7.self].count, 1)
	}

	func test_SevenDifferentIncludes_encode() {
		test_DecodeEncodeEquality(type: Includes<Include7<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7>>.self,
								  data: seven_different_type_includes)
	}

	func test_EightDifferentIncludes() {
		let includes = decoded(type: Includes<Include8<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7, TestEntity8>>.self,
							   data: eight_different_type_includes)

		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity3.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
		XCTAssertEqual(includes[TestEntity5.self].count, 1)
		XCTAssertEqual(includes[TestEntity6.self].count, 1)
		XCTAssertEqual(includes[TestEntity7.self].count, 1)
		XCTAssertEqual(includes[TestEntity8.self].count, 1)
	}

	func test_EightDifferentIncludes_encode() {
		test_DecodeEncodeEquality(type: Includes<Include8<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7, TestEntity8>>.self,
								  data: eight_different_type_includes)
	}

	func test_NineDifferentIncludes() {
		let includes = decoded(type: Includes<Include9<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7, TestEntity8, TestEntity9>>.self,
							   data: nine_different_type_includes)

		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity3.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
		XCTAssertEqual(includes[TestEntity5.self].count, 1)
		XCTAssertEqual(includes[TestEntity6.self].count, 1)
		XCTAssertEqual(includes[TestEntity7.self].count, 1)
		XCTAssertEqual(includes[TestEntity8.self].count, 1)
		XCTAssertEqual(includes[TestEntity9.self].count, 1)
	}

	func test_NineDifferentIncludes_encode() {
		test_DecodeEncodeEquality(type: Includes<Include9<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7, TestEntity8, TestEntity9>>.self,
								  data: nine_different_type_includes)
	}
}

extension IncludedTests {
	func test_appending() {
		let include1 = Includes<Include2<TestEntity8, TestEntity9>>(values: [.init(TestEntity8(attributes: .none, relationships: .none, meta: .none, links: .none)), .init(TestEntity9(attributes: .none, relationships: .none, meta: .none, links: .none)), .init(TestEntity8(attributes: .none, relationships: .none, meta: .none, links: .none))])

		let include2 = Includes<Include2<TestEntity8, TestEntity9>>(values: [.init(TestEntity8(attributes: .none, relationships: .none, meta: .none, links: .none)), .init(TestEntity9(attributes: .none, relationships: .none, meta: .none, links: .none)), .init(TestEntity8(attributes: .none, relationships: .none, meta: .none, links: .none))])

		let combined = include1 + include2

		XCTAssertEqual(combined.values, include1.values + include2.values)
	}
}

// MARK: - Test types
extension IncludedTests {
	enum TestEntityType: ResourceObjectDescription {

		typealias Relationships = NoRelationships

		public static var jsonType: String { return "test_entity1" }

		public struct Attributes: JSONAPI.Attributes {
			let foo: Attribute<String>
			let bar: Attribute<Int>
		}
	}

	typealias TestEntity = BasicEntity<TestEntityType>

	enum TestEntityType2: ResourceObjectDescription {

		public static var jsonType: String { return "test_entity2" }

		public struct Relationships: JSONAPI.Relationships {
			let entity1: ToOneRelationship<TestEntity, NoMetadata, NoLinks>
		}

		public struct Attributes: JSONAPI.Attributes {
			let foo: Attribute<String>
			let bar: Attribute<Int>
		}
	}

	typealias TestEntity2 = BasicEntity<TestEntityType2>

	enum TestEntityType3: ResourceObjectDescription {

		typealias Attributes = NoAttributes
		
		public static var jsonType: String { return "test_entity3" }
		
		public struct Relationships: JSONAPI.Relationships {
			let entity1: ToOneRelationship<TestEntity, NoMetadata, NoLinks>
			let entity2: ToManyRelationship<TestEntity2, NoMetadata, NoLinks>
		}
	}

	typealias TestEntity3 = BasicEntity<TestEntityType3>

	enum TestEntityType4: ResourceObjectDescription {

		typealias Attributes = NoAttributes

		typealias Relationships = NoRelationships

		public static var jsonType: String { return "test_entity4" }
	}

	typealias TestEntity4 = BasicEntity<TestEntityType4>

	enum TestEntityType5: ResourceObjectDescription {

		typealias Attributes = NoAttributes

		typealias Relationships = NoRelationships

		public static var jsonType: String { return "test_entity5" }
	}

	typealias TestEntity5 = BasicEntity<TestEntityType5>

	enum TestEntityType6: ResourceObjectDescription {

		typealias Attributes = NoAttributes

		public static var jsonType: String { return "test_entity6" }

		struct Relationships: JSONAPI.Relationships {
			let entity4: ToOneRelationship<TestEntity4, NoMetadata, NoLinks>
		}
	}

	typealias TestEntity6 = BasicEntity<TestEntityType6>

	enum TestEntityType7: ResourceObjectDescription {

		typealias Attributes = NoAttributes

		public static var jsonType: String { return "test_entity7" }

		typealias Relationships = NoRelationships
	}

	typealias TestEntity7 = BasicEntity<TestEntityType7>

	enum TestEntityType8: ResourceObjectDescription {

		typealias Attributes = NoAttributes

		public static var jsonType: String { return "test_entity8" }

		typealias Relationships = NoRelationships
	}

	typealias TestEntity8 = BasicEntity<TestEntityType8>

	enum TestEntityType9: ResourceObjectDescription {

		typealias Attributes = NoAttributes

		public static var jsonType: String { return "test_entity9" }

		typealias Relationships = NoRelationships
	}

	typealias TestEntity9 = BasicEntity<TestEntityType9>
}
