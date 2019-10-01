//
//  TransformedAttribute.swift
//
//  Created by Mathew Polzin on 9/30/19.
//

public protocol AttrType {
    associatedtype SerializedType
}

@propertyWrapper
public struct Attr<Serializer, Deserializer, Value>: AttrType where Serializer: Transformer, Deserializer: Transformer, Serializer.From == Value, Deserializer.To == Value {

    public typealias SerializedType = Value

    private var _wrappedValue: Value?
    public var wrappedValue: Value {
        guard let ret = _wrappedValue else {
            fatalError("Accessed Transformed Value prior to initializing or decoding it.")
        }
        return ret
    }

    public init(wrappedValue: Value) {
        _wrappedValue = wrappedValue
    }

    public init(wrappedValue: Value, serializer: Serializer.Type, deserializer: Deserializer.Type) {
        _wrappedValue = wrappedValue
    }

    public init(serializer: Serializer.Type, deserializer: Deserializer.Type) {
        _wrappedValue = nil
    }
}

extension Attr where
    Serializer == IdentityTransformer<Value>,
    Deserializer == IdentityTransformer<Value> {
    public init(wrappedValue: Value) {
        _wrappedValue = wrappedValue
    }

    public init() {
        _wrappedValue = nil
    }
}

extension Attr where
    Deserializer == IdentityTransformer<Value>,
    Serializer: Transformer, Serializer.From == Value {

    public init(wrappedValue: Value, serializer: Serializer.Type) {
        _wrappedValue = wrappedValue
    }

    public init(serializer: Serializer.Type) {
        _wrappedValue = nil
    }
}

extension Attr where
    Serializer == IdentityTransformer<Value>,
    Deserializer: Transformer, Deserializer.To == Value {

    public init(wrappedValue: Value, deserializer: Deserializer.Type) {
        _wrappedValue = wrappedValue
    }

    public init(deserializer: Deserializer.Type) {
        _wrappedValue = nil
    }
}

extension Attr: Encodable where
    Serializer: Transformer, Serializer.To: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(Serializer.transform(wrappedValue))
    }
}

extension Attr: Decodable where
    Deserializer: Transformer, Deserializer.From: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let anyNil: Any? = nil
        if container.decodeNil(),
            let val = anyNil as? Value {
            _wrappedValue = val
        } else {
            _wrappedValue = try Deserializer.transform(container.decode(Deserializer.From.self))
        }
    }
}

public protocol _Omittable {
    static var nilValue: Self { get }
}

@propertyWrapper
public struct Omittable<T>: AttrType, _Omittable {

    public typealias SerializedType = T?

    public let wrappedValue: T?

    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }

    public static var nilValue: Omittable<T> { return .init(wrappedValue: nil) }
}

extension Omittable: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        if Optional(wrappedValue) != nil {
            try container.encode(wrappedValue)
        }
    }
}

extension Omittable: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        self = .init(wrappedValue: try container.decode(T.self))
    }
}

extension KeyedDecodingContainer {
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : Decodable, T: _Omittable {
        return try decodeIfPresent(T.self, forKey: key) ?? T.nilValue
    }
}
