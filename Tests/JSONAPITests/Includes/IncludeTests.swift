
import XCTest
import JSONAPI

class IncludedTests: XCTestCase {

	let decoder = JSONDecoder()
	
	func test_zeroIncludes() {
		let maybeIncludes = try? decoder.decode(Includes<NoIncludes>.self, from: two_same_type_includes)
		
		XCTAssertNotNil(maybeIncludes)
		
		guard let includes = maybeIncludes else {
			return
		}
		
		XCTAssertEqual(includes.count, 0)
	}
	
	func test_OneInclude() {
		let maybeIncludes = try? decoder.decode(Includes<Include1<TestEntityType>>.self, from: one_include)
		
		XCTAssertNotNil(maybeIncludes)

		guard let includes = maybeIncludes else {
			return
		}

		XCTAssertEqual(includes[TestEntity.self].count, 1)
	}
	
	func test_TwoSameIncludes() {
		let maybeIncludes = try? decoder.decode(Includes<Include1<TestEntityType>>.self, from: two_same_type_includes)
		
		XCTAssertNotNil(maybeIncludes)
		
		guard let includes = maybeIncludes else {
			return
		}
		
		XCTAssertEqual(includes[TestEntity.self].count, 2)
	}
	
	func test_TwoDifferentIncludes() {
		let maybeIncludes = try? decoder.decode(Includes<Include2<TestEntityType, TestEntityType2>>.self, from: two_different_type_includes)
		
		XCTAssertNotNil(maybeIncludes)

		guard let includes = maybeIncludes else {
			return
		}

		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
	}
	
	func test_ThreeDifferentIncludes() {
		let maybeIncludes = try? decoder.decode(Includes<Include3<TestEntityType, TestEntityType2, TestEntityType4>>.self, from: three_different_type_includes)
		
		XCTAssertNotNil(maybeIncludes)

		guard let includes = maybeIncludes else {
			return
		}

		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
	}
	
	func test_FourDifferentIncludes() {
		let maybeIncludes = try? decoder.decode(Includes<Include4<TestEntityType, TestEntityType2, TestEntityType4, TestEntityType6>>.self, from: four_different_type_includes)
		
		XCTAssertNotNil(maybeIncludes)
		
		guard let includes = maybeIncludes else {
			return
		}
		
		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
		XCTAssertEqual(includes[TestEntity6.self].count, 1)
	}
	
	func test_FiveDifferentIncludes() {
		let maybeIncludes = try? decoder.decode(Includes<Include5<TestEntityType, TestEntityType2, TestEntityType3, TestEntityType4, TestEntityType6>>.self, from: five_different_type_includes)
		
		XCTAssertNotNil(maybeIncludes)
		
		guard let includes = maybeIncludes else {
			return
		}
		
		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity3.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
		XCTAssertEqual(includes[TestEntity6.self].count, 1)
	}
	
	func test_SixDifferentIncludes() {
		let maybeIncludes = try? decoder.decode(Includes<Include6<TestEntityType, TestEntityType2, TestEntityType3, TestEntityType4, TestEntityType5, TestEntityType6>>.self, from: six_different_type_includes)
		
		XCTAssertNotNil(maybeIncludes)
		
		guard let includes = maybeIncludes else {
			return
		}
		
		XCTAssertEqual(includes[TestEntity.self].count, 1)
		XCTAssertEqual(includes[TestEntity2.self].count, 1)
		XCTAssertEqual(includes[TestEntity3.self].count, 1)
		XCTAssertEqual(includes[TestEntity4.self].count, 1)
		XCTAssertEqual(includes[TestEntity5.self].count, 1)
		XCTAssertEqual(includes[TestEntity6.self].count, 1)
	}
}

extension IncludedTests {
	enum TestEntityType: EntityDescription {
		typealias Identifier = Id<String, TestEntityType>
		
		typealias Relationships = NoRelatives
		
		public static var type: String { return "test_entity1" }
		
		public struct Attributes: JSONAPI.Attributes {
			let foo: Attribute<String>
			let bar: Attribute<Int>
		}
	}
	
	typealias TestEntity = Entity<TestEntityType>
	
	enum TestEntityType2: EntityDescription {
		typealias Identifier = Id<String, TestEntityType2>
		
		public static var type: String { return "test_entity2" }
		
		public struct Relationships: JSONAPI.Relationships {
			let entity1: ToOneRelationship<TestEntity>
		}
		
		public struct Attributes: JSONAPI.Attributes {
			let foo: Attribute<String>
			let bar: Attribute<Int>
		}
	}
	
	typealias TestEntity2 = Entity<TestEntityType2>
	
	enum TestEntityType3: EntityDescription {
		typealias Identifier = Id<String, TestEntityType3>
		
		typealias Attributes = NoAttributes
		
		public static var type: String { return "test_entity3" }
		
		public struct Relationships: JSONAPI.Relationships {
			let entity1: ToOneRelationship<TestEntity>
			let entity2: ToManyRelationship<TestEntity2>
		}
	}
	
	typealias TestEntity3 = Entity<TestEntityType3>
	
	enum TestEntityType4: EntityDescription {
		typealias Identifier = Id<String, TestEntityType4>
		
		typealias Attributes = NoAttributes
		
		typealias Relationships = NoRelatives
		
		public static var type: String { return "test_entity4" }
	}
	
	typealias TestEntity4 = Entity<TestEntityType4>
	
	enum TestEntityType5: EntityDescription {
		typealias Identifier = Id<String, TestEntityType5>
		
		typealias Attributes = NoAttributes
		
		typealias Relationships = NoRelatives
		
		public static var type: String { return "test_entity5" }
	}
	
	typealias TestEntity5 = Entity<TestEntityType5>
	
	enum TestEntityType6: EntityDescription {
		typealias Identifier = Id<String, TestEntityType6>
		
		typealias Attributes = NoAttributes
		
		public static var type: String { return "test_entity6" }
		
		struct Relationships: JSONAPI.Relationships {
			let entity4: ToOneRelationship<TestEntity4>
		}
	}
	
	typealias TestEntity6 = Entity<TestEntityType6>
}
