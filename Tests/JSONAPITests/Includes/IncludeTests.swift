
import XCTest
import JSONAPI

class IncludedTests: XCTestCase {

	let decoder = JSONDecoder()

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
}

// MARK: - Test types
extension IncludedTests {
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

	enum TestEntityType7: EntityDescription {

		typealias Attributes = NoAttributes

		public static var type: String { return "test_entity7" }

		typealias Relationships = NoRelationships
	}

	typealias TestEntity7 = BasicEntity<TestEntityType7>
}
