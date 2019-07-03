//
//  EmptyObjectDecoder.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 7/2/19.
//

/// `EmptyObjectDecoder` exists internally for the sole purpose of
/// allowing certain fallback logic paths to attempt to create `Decodable`
/// types from empty containers (specifically in a way that is agnostic
/// of any given encoding). In other words, this serves the same purpose
/// as `JSONDecoder().decode(Thing.self, from: "{}".data(using: .utf8)!)`
/// without needing to use a third party or `Foundation` library decoder.
struct EmptyObjectDecoder: Decoder {

    var codingPath: [CodingKey] = []

    var userInfo: [CodingUserInfoKey : Any] = [:]

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(EmptyKeyedContainer())
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return EmptyUnkeyedContainer()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw EmptyObjectDecodingError.emptyObjectCannotBeSingleValue
    }
}

enum EmptyObjectDecodingError: Swift.Error {
    case emptyObjectCannotBeSingleValue
    case emptyObjectCannotBeUnkeyedValues
    case emptyObjectCannotHaveKeyedValues
    case emptyObjectCannotHaveNestedContainers
    case emptyObjectCannotHaveSuper
}

struct EmptyUnkeyedContainer: UnkeyedDecodingContainer {
    var codingPath: [CodingKey] { return [] }

    var count: Int? { return 0 }

    var isAtEnd: Bool { return true }

    var currentIndex: Int { return 0 }

    mutating func decodeNil() throws -> Bool {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: String.Type) throws -> String {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: Float.Type) throws -> Float {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: Int.Type) throws -> Int {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: UInt.Type) throws -> UInt {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        throw EmptyObjectDecodingError.emptyObjectCannotBeUnkeyedValues
    }

    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveNestedContainers
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveNestedContainers
    }

    mutating func superDecoder() throws -> Decoder {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveSuper
    }
}

struct EmptyKeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] { return [] }

    var allKeys: [Key] { return [] }

    func contains(_ key: Key) -> Bool {
        return false
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveKeyedValues
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveNestedContainers
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveNestedContainers
    }

    func superDecoder() throws -> Decoder {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveSuper
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        throw EmptyObjectDecodingError.emptyObjectCannotHaveSuper
    }
}
