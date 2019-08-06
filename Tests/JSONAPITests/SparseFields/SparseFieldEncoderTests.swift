//
//  SparseFieldEncoderTests.swift
//  
//
//  Created by Mathew Polzin on 8/5/19.
//

import XCTest
import JSONAPI
import Foundation

class SparseFieldEncoderTests: XCTestCase {
    func test_AccurateCodingPath() {
        let encoder = JSONEncoder()
        XCTAssertThrowsError(try encoder.encode(Wrapper()))

        do {
            let _ = try encoder.encode(Wrapper())
        } catch let err as Wrapper.OuterFail.FailError {
            print(err.path)
            XCTAssertEqual(err.path.first as? Wrapper.OuterFail.CodingKeys, Wrapper.OuterFail.CodingKeys.inner)
        } catch {
            XCTFail("received unexpected error during test")
        }
    }

    func test_SkipsOmittedFields() {
        let encoder = JSONEncoder()

        // does not throw because we omit the field that would have failed
        XCTAssertNoThrow(try encoder.encode(Wrapper(fields: [])))
    }

    func test_EverythingArsenal_allOn() {
        let encoder = JSONEncoder()

        let allThingsOn = try! encoder.encode(EverythingWrapper(fields: EverythingWrapper.EverythingWrapped.CodingKeys.allCases))

        let allThingsOnDeserialized = try! JSONSerialization.jsonObject(with: allThingsOn,
        options: []) as! [String: Any]

        XCTAssertNil(allThingsOnDeserialized["omittable"])
        XCTAssertNotNil(allThingsOnDeserialized["nullable"] as? NSNull)
        XCTAssertEqual(allThingsOnDeserialized["bool"] as? Bool, true)
        XCTAssertEqual(allThingsOnDeserialized["double"] as? Double, 10.5)
        XCTAssertEqual(allThingsOnDeserialized["string"] as? String, "hello")
        XCTAssertEqual(allThingsOnDeserialized["float"] as? Float, 1.2)
        XCTAssertEqual(allThingsOnDeserialized["int"] as? Int, 3)
        XCTAssertEqual(allThingsOnDeserialized["int8"] as? Int8, 4)
        XCTAssertEqual(allThingsOnDeserialized["int16"] as? Int16, 5)
        XCTAssertEqual(allThingsOnDeserialized["int32"] as? Int32, 6)
        XCTAssertEqual(allThingsOnDeserialized["int64"] as? Int64, 7)
        XCTAssertEqual(allThingsOnDeserialized["uint"] as? UInt, 8)
        XCTAssertEqual(allThingsOnDeserialized["uint8"] as? UInt8, 9)
        XCTAssertEqual(allThingsOnDeserialized["uint16"] as? UInt16, 10)
        XCTAssertEqual(allThingsOnDeserialized["uint32"] as? UInt32, 11)
        XCTAssertEqual(allThingsOnDeserialized["uint64"] as? UInt64, 12)
        XCTAssertEqual(allThingsOnDeserialized["nested"] as? String, "world")
    }

    func test_EverythingArsenal_allOff() {
        let encoder = JSONEncoder()

        let allThingsOn = try! encoder.encode(EverythingWrapper(fields: []))

        let allThingsOnDeserialized = try! JSONSerialization.jsonObject(with: allThingsOn,
                                                                        options: []) as! [String: Any]

        XCTAssertNil(allThingsOnDeserialized["omittable"])
        XCTAssertNil(allThingsOnDeserialized["nullable"])
        XCTAssertNil(allThingsOnDeserialized["bool"])
        XCTAssertNil(allThingsOnDeserialized["double"])
        XCTAssertNil(allThingsOnDeserialized["string"])
        XCTAssertNil(allThingsOnDeserialized["float"])
        XCTAssertNil(allThingsOnDeserialized["int"])
        XCTAssertNil(allThingsOnDeserialized["int8"])
        XCTAssertNil(allThingsOnDeserialized["int16"])
        XCTAssertNil(allThingsOnDeserialized["int32"])
        XCTAssertNil(allThingsOnDeserialized["int64"])
        XCTAssertNil(allThingsOnDeserialized["uint"])
        XCTAssertNil(allThingsOnDeserialized["uint8"])
        XCTAssertNil(allThingsOnDeserialized["uint16"])
        XCTAssertNil(allThingsOnDeserialized["uint32"])
        XCTAssertNil(allThingsOnDeserialized["uint64"])
        XCTAssertNil(allThingsOnDeserialized["nested"])
        XCTAssertEqual(allThingsOnDeserialized.count, 0)
    }
}

extension SparseFieldEncoderTests {
    struct Wrapper: Encodable {

        let fields: [OuterFail.CodingKeys]

        init(fields: [OuterFail.CodingKeys] = OuterFail.CodingKeys.allCases) {
            self.fields = fields
        }

        func encode(to encoder: Encoder) throws {
            let sparseEncoder = SparseFieldEncoder(wrapping: encoder,
                                                   encoding: fields)
            try OuterFail(inner: .init()).encode(to: sparseEncoder)
        }

        struct OuterFail: Encodable {
            let inner: InnerFail

            public enum CodingKeys: String, Equatable, CaseIterable, CodingKey {
                case inner
            }

            struct InnerFail: Encodable {
                func encode(to encoder: Encoder) throws {

                    throw FailError(path: encoder.codingPath)
                }
            }

            struct FailError: Swift.Error {
                let path: [CodingKey]
            }
        }
    }

    struct EverythingWrapper: Encodable {
        let fields: [EverythingWrapped.CodingKeys]

        func encode(to encoder: Encoder) throws {
            let sparseEncoder = SparseFieldEncoder(wrapping: encoder,
                                                   encoding: fields)

            try EverythingWrapped(omittable: nil,
                                  nullable: .init(value: nil),
                                  bool: true,
                                  double: 10.5,
                                  string: "hello",
                                  float: 1.2,
                                  int: 3,
                                  int8: 4,
                                  int16: 5,
                                  int32: 6,
                                  int64: 7,
                                  uint: 8,
                                  uint8: 9,
                                  uint16: 10,
                                  uint32: 11,
                                  uint64: 12,
                                  nested: .init(value: "world"))
                .encode(to: sparseEncoder)
        }

        struct EverythingWrapped: Encodable {
            let omittable: Int?
            let nullable: Attribute<Int?>
            let bool: Bool
            let double: Double
            let string: String
            let float: Float
            let int: Int
            let int8: Int8
            let int16: Int16
            let int32: Int32
            let int64: Int64
            let uint: UInt
            let uint8: UInt8
            let uint16: UInt16
            let uint32: UInt32
            let uint64: UInt64
            let nested: Attribute<String>

            enum CodingKeys: String, Equatable, CaseIterable, CodingKey {
                case omittable
                case nullable
                case bool
                case double
                case string
                case float
                case int
                case int8
                case int16
                case int32
                case int64
                case uint
                case uint8
                case uint16
                case uint32
                case uint64
                case nested
            }
        }
    }
}
