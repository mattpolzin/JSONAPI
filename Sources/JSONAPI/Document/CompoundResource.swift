//
//  CompoundResource.swift
//  
//
//  Created by Mathew Polzin on 5/25/20.
//

/// A Resource Object and any relevant related resources. This object
/// is helpful in the context of constructing a Document.
///
/// You can resolve a primary resource and all of the intended includes
/// for that resource and pass them around as a `CompoundResource`
/// prior to constructing a Document.
///
/// Among other things, using this abstraction means you do not need to
/// specialized for a single or batch document at the same time as you are
/// resolving (i.e. materializing or decoding) one or more resources and its
/// relatives.
public struct CompoundResource<JSONAPIModel: JSONAPI.ResourceObjectType, JSONAPIIncludeType: JSONAPI.Include>: Equatable {
    public let primary: JSONAPIModel
    public let relatives: [JSONAPIIncludeType]

    public init(primary: JSONAPIModel, relatives: [JSONAPIIncludeType]) {
        self.primary = primary
        self.relatives = relatives
    }
}

extension EncodableJSONAPIDocument where PrimaryResourceBody: EncodableResourceBody, PrimaryResourceBody.PrimaryResource: ResourceObjectType {
    public typealias CompoundResource = JSONAPI.CompoundResource<PrimaryResourceBody.PrimaryResource, IncludeType>
}

extension SucceedableJSONAPIDocument where PrimaryResourceBody: SingleResourceBodyProtocol, PrimaryResourceBody.PrimaryResource: ResourceObjectType {

    public init(
        apiDescription: APIDescription,
        resource: CompoundResource,
        meta: MetaType,
        links: LinksType
    ) {
        self.init(
            apiDescription: apiDescription,
            body: .init(resourceObject: resource.primary),
            includes: .init(values: resource.relatives),
            meta: meta,
            links: links
        )
    }
}

extension SucceedableJSONAPIDocument where PrimaryResourceBody: ManyResourceBodyProtocol, PrimaryResourceBody.PrimaryResource: ResourceObjectType, IncludeType: Hashable {

    public init(
        apiDescription: APIDescription,
        resources: [CompoundResource],
        meta: MetaType,
        links: LinksType
    ) {
        var included = Set<Int>()
        let includes = resources.reduce(into: [IncludeType]()) { (result, next) in
            for include in next.relatives {
                if !included.contains(include.hashValue) {
                    included.insert(include.hashValue)
                    result.append(include)
                }
            }
        }
        self.init(
            apiDescription: apiDescription,
            body: .init(resourceObjects: resources.map(\.primary)),
            includes: .init(values: Array(includes)),
            meta: meta,
            links: links
        )
    }
}
