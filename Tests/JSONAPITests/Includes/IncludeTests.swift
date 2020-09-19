
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

    func test_TenDifferentIncludes() {
        let includes = decoded(type: Includes<Include10<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7, TestEntity8, TestEntity9, TestEntity10>>.self,
                               data: ten_different_type_includes)

        XCTAssertEqual(includes[TestEntity.self].count, 1)
        XCTAssertEqual(includes[TestEntity2.self].count, 1)
        XCTAssertEqual(includes[TestEntity3.self].count, 1)
        XCTAssertEqual(includes[TestEntity4.self].count, 1)
        XCTAssertEqual(includes[TestEntity5.self].count, 1)
        XCTAssertEqual(includes[TestEntity6.self].count, 1)
        XCTAssertEqual(includes[TestEntity7.self].count, 1)
        XCTAssertEqual(includes[TestEntity8.self].count, 1)
        XCTAssertEqual(includes[TestEntity9.self].count, 1)
        XCTAssertEqual(includes[TestEntity10.self].count, 1)
    }

    func test_TenDifferentIncludes_encode() {
        test_DecodeEncodeEquality(type: Includes<Include10<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7, TestEntity8, TestEntity9, TestEntity10>>.self,
                                  data: ten_different_type_includes)
    }

    func test_ElevenDifferentIncludes() {
        let includes = decoded(type: Includes<Include11<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7, TestEntity8, TestEntity9, TestEntity10, TestEntity11>>.self,
                               data: eleven_different_type_includes)

        XCTAssertEqual(includes[TestEntity.self].count, 1)
        XCTAssertEqual(includes[TestEntity2.self].count, 1)
        XCTAssertEqual(includes[TestEntity3.self].count, 1)
        XCTAssertEqual(includes[TestEntity4.self].count, 1)
        XCTAssertEqual(includes[TestEntity5.self].count, 1)
        XCTAssertEqual(includes[TestEntity6.self].count, 1)
        XCTAssertEqual(includes[TestEntity7.self].count, 1)
        XCTAssertEqual(includes[TestEntity8.self].count, 1)
        XCTAssertEqual(includes[TestEntity9.self].count, 1)
        XCTAssertEqual(includes[TestEntity10.self].count, 1)
        XCTAssertEqual(includes[TestEntity11.self].count, 1)
    }

    func test_ElevenDifferentIncludes_encode() {
        test_DecodeEncodeEquality(type: Includes<Include11<TestEntity, TestEntity2, TestEntity3, TestEntity4, TestEntity5, TestEntity6, TestEntity7, TestEntity8, TestEntity9, TestEntity10, TestEntity11>>.self,
                                  data: eleven_different_type_includes)
    }
}

// MARK: - Appending

extension IncludedTests {
	func test_appending() {
		let include1 = Includes<Include2<TestEntity8, TestEntity9>>(values: [.init(TestEntity8(attributes: .none, relationships: .none, meta: .none, links: .none)), .init(TestEntity9(attributes: .none, relationships: .none, meta: .none, links: .none)), .init(TestEntity8(attributes: .none, relationships: .none, meta: .none, links: .none))])

		let include2 = Includes<Include2<TestEntity8, TestEntity9>>(values: [.init(TestEntity8(attributes: .none, relationships: .none, meta: .none, links: .none)), .init(TestEntity9(attributes: .none, relationships: .none, meta: .none, links: .none)), .init(TestEntity8(attributes: .none, relationships: .none, meta: .none, links: .none))])

		let combined = include1 + include2

		XCTAssertEqual(combined.values, include1.values + include2.values)
	}
}

// MARK: - Sparse Fieldsets

extension IncludedTests {
    func test_OneSparseIncludeType() {
        let include1 = TestEntity(attributes: .init(foo: "hello",
                                                    bar: 10),
                                  relationships: .none,
                                  meta: .none,
                                  links: .none)
            .sparse(with: [.foo])

        let includes: Includes<Include1<TestEntity.SparseType>> = .init(values: [.init(include1)])

        let encoded = try! JSONEncoder().encode(includes)

        let deserialized = try! JSONSerialization.jsonObject(with: encoded,
                                                             options: [])

        let deserializedObj = deserialized as? [Any]

        XCTAssertEqual(deserializedObj?.count, 1)

        guard let deserializedObj1 = deserializedObj?.first as? [String: Any] else {
                XCTFail("Expected to deserialize one object from array")
                return
        }

        XCTAssertNotNil(deserializedObj1["id"])
        XCTAssertEqual(deserializedObj1["id"] as? String, include1.resourceObject.id.rawValue)

        XCTAssertNotNil(deserializedObj1["type"])
        XCTAssertEqual(deserializedObj1["type"] as? String, TestEntity.jsonType)

        XCTAssertEqual((deserializedObj1["attributes"] as? [String: Any])?.count, 1)
        XCTAssertEqual((deserializedObj1["attributes"] as? [String: Any])?["foo"] as? String, "hello")

        XCTAssertNil(deserializedObj1["relationships"])
    }

    func test_TwoSparseIncludeTypes() {
        let include1 = TestEntity(attributes: .init(foo: "hello",
                                                    bar: 10),
                                  relationships: .none,
                                  meta: .none,
                                  links: .none)
            .sparse(with: [.foo])

        let include2 = TestEntity2(attributes: .init(foo: "world",
                                                     bar: 2),
                                   relationships: .init(entity1: "1234"),
                                   meta: .none,
                                   links: .none)
            .sparse(with: [.bar])

        let includes: Includes<Include2<TestEntity.SparseType, TestEntity2.SparseType>> = .init(values: [.init(include1), .init(include2)])

        let encoded = try! JSONEncoder().encode(includes)

        let deserialized = try! JSONSerialization.jsonObject(with: encoded,
                                                             options: [])

        let deserializedObj = deserialized as? [Any]

        XCTAssertEqual(deserializedObj?.count, 2)

        guard let deserializedObj1 = deserializedObj?.first as? [String: Any],
            let deserializedObj2 = deserializedObj?.last as? [String: Any] else {
            XCTFail("Expected to deserialize two objects from array")
            return
        }

        // first include
        XCTAssertNotNil(deserializedObj1["id"])
        XCTAssertEqual(deserializedObj1["id"] as? String, include1.resourceObject.id.rawValue)

        XCTAssertNotNil(deserializedObj1["type"])
        XCTAssertEqual(deserializedObj1["type"] as? String, TestEntity.jsonType)

        XCTAssertEqual((deserializedObj1["attributes"] as? [String: Any])?.count, 1)
        XCTAssertEqual((deserializedObj1["attributes"] as? [String: Any])?["foo"] as? String, "hello")

        XCTAssertNil(deserializedObj1["relationships"])

        // second include
        XCTAssertNotNil(deserializedObj2["id"])
        XCTAssertEqual(deserializedObj2["id"] as? String, include2.resourceObject.id.rawValue)

        XCTAssertNotNil(deserializedObj2["type"])
        XCTAssertEqual(deserializedObj2["type"] as? String, TestEntity2.jsonType)

        XCTAssertEqual((deserializedObj2["attributes"] as? [String: Any])?.count, 1)
        XCTAssertEqual((deserializedObj2["attributes"] as? [String: Any])?["bar"] as? Int, 2)

        XCTAssertNotNil(deserializedObj2["relationships"])
        XCTAssertNotNil((deserializedObj2["relationships"] as? [String: Any])?["entity1"])
    }

    func test_ComboSparseAndFullIncludeTypes() {
        let include1 = TestEntity(attributes: .init(foo: "hello",
                                                    bar: 10),
                                  relationships: .none,
                                  meta: .none,
                                  links: .none)
            .sparse(with: [.foo])

        let include2 = TestEntity2(attributes: .init(foo: "world",
                                                     bar: 2),
                                   relationships: .init(entity1: "1234"),
                                   meta: .none,
                                   links: .none)

        let includes: Includes<Include2<TestEntity.SparseType, TestEntity2>> = .init(values: [.init(include1), .init(include2)])

        let encoded = try! JSONEncoder().encode(includes)

        let deserialized = try! JSONSerialization.jsonObject(with: encoded,
                                                             options: [])

        let deserializedObj = deserialized as? [Any]

        XCTAssertEqual(deserializedObj?.count, 2)

        guard let deserializedObj1 = deserializedObj?.first as? [String: Any],
            let deserializedObj2 = deserializedObj?.last as? [String: Any] else {
                XCTFail("Expected to deserialize two objects from array")
                return
        }

        // first include
        XCTAssertNotNil(deserializedObj1["id"])
        XCTAssertEqual(deserializedObj1["id"] as? String, include1.resourceObject.id.rawValue)

        XCTAssertNotNil(deserializedObj1["type"])
        XCTAssertEqual(deserializedObj1["type"] as? String, TestEntity.jsonType)

        XCTAssertEqual((deserializedObj1["attributes"] as? [String: Any])?.count, 1)
        XCTAssertEqual((deserializedObj1["attributes"] as? [String: Any])?["foo"] as? String, "hello")

        XCTAssertNil(deserializedObj1["relationships"])

        // second include
        XCTAssertNotNil(deserializedObj2["id"])
        XCTAssertEqual(deserializedObj2["id"] as? String, include2.id.rawValue)

        XCTAssertNotNil(deserializedObj2["type"])
        XCTAssertEqual(deserializedObj2["type"] as? String, TestEntity2.jsonType)

        XCTAssertEqual((deserializedObj2["attributes"] as? [String: Any])?.count, 2)
        XCTAssertEqual((deserializedObj2["attributes"] as? [String: Any])?["foo"] as? String, "world")
        XCTAssertEqual((deserializedObj2["attributes"] as? [String: Any])?["bar"] as? Int, 2)

        XCTAssertNotNil(deserializedObj2["relationships"])
        XCTAssertNotNil((deserializedObj2["relationships"] as? [String: Any])?["entity1"])
    }
}

// MARK: - Test types
extension IncludedTests {
    enum TestEntityType: ResourceObjectDescription {

        typealias Relationships = NoRelationships

        public static var jsonType: String { return "test_entity1" }

        public struct Attributes: JSONAPI.SparsableAttributes {
            let foo: Attribute<String>
            let bar: Attribute<Int>

            public enum CodingKeys: String, Equatable, CodingKey {
                case foo
                case bar
            }
        }
    }

    typealias TestEntity = BasicEntity<TestEntityType>

    enum TestEntityType2: ResourceObjectDescription {

        public static var jsonType: String { return "test_entity2" }

        public struct Relationships: JSONAPI.Relationships {
            let entity1: ToOneRelationship<TestEntity, NoIdMetadata, NoMetadata, NoLinks>
        }

        public struct Attributes: JSONAPI.SparsableAttributes {
            let foo: Attribute<String>
            let bar: Attribute<Int>

            public enum CodingKeys: String, Equatable, CodingKey {
                case foo
                case bar
            }
        }
    }

    typealias TestEntity2 = BasicEntity<TestEntityType2>

	enum TestEntityType3: ResourceObjectDescription {

		typealias Attributes = NoAttributes
		
		public static var jsonType: String { return "test_entity3" }
		
		public struct Relationships: JSONAPI.Relationships {
			let entity1: ToOneRelationship<TestEntity, NoIdMetadata, NoMetadata, NoLinks>
			let entity2: ToManyRelationship<TestEntity2, NoIdMetadata, NoMetadata, NoLinks>
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
			let entity4: ToOneRelationship<TestEntity4, NoIdMetadata, NoMetadata, NoLinks>
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

    enum TestEntityType10: ResourceObjectDescription {

        typealias Attributes = NoAttributes

        public static var jsonType: String { return "test_entity10" }

        typealias Relationships = NoRelationships
    }

    typealias TestEntity10 = BasicEntity<TestEntityType10>

    enum TestEntityType11: ResourceObjectDescription {

        typealias Attributes = NoAttributes

        public static var jsonType: String { return "test_entity11" }

        typealias Relationships = NoRelationships
    }

    typealias TestEntity11 = BasicEntity<TestEntityType11>
}
