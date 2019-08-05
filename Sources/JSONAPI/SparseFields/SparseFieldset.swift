//
//  SparseFieldset.swift
//  
//
//  Created by Mathew Polzin on 8/4/19.
//

/// A SparseFieldset represents an `Encodable` subset of the fields
/// a `ResourceObject` would normally encode. Currently, you can
/// only apply sparse fieldset's to `ResourceObject.Attributes`.
public struct SparseFieldset<
    Description: JSONAPI.ResourceObjectDescription,
    MetaType: JSONAPI.Meta,
    LinksType: JSONAPI.Links,
    EntityRawIdType: JSONAPI.MaybeRawId
>: EncodablePrimaryResource where Description.Attributes: SparsableAttributes {

    /// The `ResourceObject` type this `SparseFieldset` is capable of modifying.
    public typealias Resource = JSONAPI.ResourceObject<Description, MetaType, LinksType, EntityRawIdType>

    public let resourceObject: Resource
    public let fields: [Description.Attributes.CodingKeys]

    public init(_ resourceObject: Resource, fields: [Description.Attributes.CodingKeys]) {
        self.resourceObject = resourceObject
        self.fields = fields
    }

    public func encode(to encoder: Encoder) throws {
        let sparseEncoder = SparseFieldEncoder(wrapping: encoder,
                                               encoding: fields)

        try resourceObject.encode(to: sparseEncoder)
    }
}

public extension ResourceObject where Description.Attributes: SparsableAttributes {

    /// Get a Sparse Fieldset of this `ResourceObject` that can be encoded
    /// as a `SparsePrimaryResource`.
    func sparse(with fields: [Description.Attributes.CodingKeys]) -> SparseFieldset<Description, MetaType, LinksType, EntityRawIdType> {
        return SparseFieldset(self, fields: fields)
    }
}

public extension ResourceObject where Description.Attributes: SparsableAttributes {

    /// The `SparseFieldset` type for this `ResourceObject`
    typealias SparseType = SparseFieldset<Description, MetaType, LinksType, EntityRawIdType>
}
