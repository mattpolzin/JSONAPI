//
//  SparseField.swift
//  
//
//  Created by Mathew Polzin on 8/4/19.
//

public struct SparseField<
    Description: JSONAPI.ResourceObjectDescription,
    MetaType: JSONAPI.Meta,
    LinksType: JSONAPI.Links,
    EntityRawIdType: JSONAPI.MaybeRawId
>: Encodable where Description.Attributes: SparsableAttributes {

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
    /// as a `PrimaryResource`.
    func sparse(with fields: [Description.Attributes.CodingKeys]) -> SparseField<Description, MetaType, LinksType, EntityRawIdType> {
        return SparseField(self, fields: fields)
    }
}
