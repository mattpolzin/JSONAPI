//
//  Attribute+Functor.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/28/18.
//

public extension TransformedAttribute {
    /// Map an Attribute to a new wrapped type.
    /// Note that the resulting Attribute will have no transformer, even if the
    /// source Attribute has a transformer.
    /// You are mapping the output of the source transform into
    /// the RawValue of a new transformerless Attribute.
    ///
    /// Generally, this is the most useful operation. The transformer gives you
    /// control over the decoding of the Attribute, but once the Attribute exists,
    /// mapping on it is most useful for creating computed Attribute properties.
    func map<T: Codable>(_ transform: (Transformer.To) throws -> T) rethrows -> Attribute<T> {
        return Attribute<T>(value: try transform(value))
    }
}

public extension Attribute {
    /// Map an Attribute to a new wrapped type.
    /// Note that the resulting Attribute will have no transformer, even if the
    /// source Attribute has a transformer.
    /// You are mapping the output of the source transform into
    /// the RawValue of a new transformerless Attribute.
    ///
    /// Generally, this is the most useful operation. The transformer gives you
    /// control over the decoding of the Attribute, but once the Attribute exists,
    /// mapping on it is most useful for creating computed Attribute properties.
    func map<T: Codable>(_ transform: (ValueType) throws -> T) rethrows -> Attribute<T> {
        return Attribute<T>(value: try transform(value))
    }
}
