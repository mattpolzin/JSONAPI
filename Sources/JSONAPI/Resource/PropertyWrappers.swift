//
//  PropertyWrappers.swift
//  
//
//  Created by Mathew Polzin on 6/20/19.
//


// MARK: - Transformed
@propertyWrapper
public struct Transformed<Transformer: JSONAPI.Transformer> {

    public typealias RawValue = Transformer.From
    public typealias Value = Transformer.To

    private var _value: Value?

    public var wrappedValue: Value {
        get {
            guard let ret = _value else {
                fatalError("Attribute read from before initialization.")
            }
            return ret
        }
        set {
            _value = newValue
        }
    }

    public init(initialValue: Value, _ transformer: Transformer.Type) {
        self._value = initialValue
    }

    public init(_ transformer: Transformer.Type) {
        self._value = nil
    }

    public init(rawValue: RawValue, _ transformer: Transformer.Type) throws {
        self._value = try Transformer.transform(rawValue)
    }
}

extension Transformed: Decodable where Transformer.From: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let rawVal = try container.decode(Transformer.From.self)

        _value = try Transformer.transform(rawVal)
    }
}

extension Transformed: Encodable where Transformer: ReversibleTransformer, Transformer.From: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        guard let value = _value else {
            fatalError("Attribute encoded before initialization.")
        }

        try container.encode(Transformer.reverse(value))
    }
}

// MARK: - Nullable

public protocol _Optional {
    static var nilValue: Self { get }
    var isNilValue: Bool { get }
}

extension Optional: _Optional {
    public static var nilValue: Self {
        return .none
    }

    public var isNilValue: Bool { return self == nil }
}

protocol _Nullable {}

@propertyWrapper
public struct Nullable<T: Decodable>: Decodable, _Optional, _Nullable {
    public var wrappedValue: T?

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            wrappedValue = nil
            return
        }

        wrappedValue = try container.decode(T.self)
    }

    public init(initialValue: T? = nil) {
        wrappedValue = initialValue
    }

    public static var nilValue: Self {
        return .init()
    }

    public var isNilValue: Bool {
        return wrappedValue == nil
    }
}

extension Nullable: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
