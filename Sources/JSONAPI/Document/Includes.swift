//
//  Includes.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

import Poly

public typealias Include = EncodableJSONPoly

/// A structure holding zero or more included Resource Objects.
/// The resources are accessed by their type using a subscript.
///
/// If you have
///
///     let includes: Includes<Include2<Thing1, Thing2>> = ...
///
/// then you can access all `Thing1` included resources with
///
///     let includedThings = includes[Thing1.self]
public struct Includes<I: Include>: Encodable, Equatable {
    public static var none: Includes { return .init(values: []) }

    public let values: [I]

    public init(values: [I]) {
        self.values = values
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        guard I.self != NoIncludes.self else {
            throw JSONAPICodingError.illegalEncoding("Attempting to encode Include0, which should be represented by the absense of an 'included' entry altogether.", path: encoder.codingPath)
        }

        for value in values {
            try container.encode(value)
        }
    }

    public var count: Int {
        return values.count
    }
}

extension Includes: Decodable where I: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        // If not parsing includes, no need to loop over them.
        guard I.self != NoIncludes.self else {
            values = []
            return
        }

        var valueAggregator = [I]()
        var idx = 0
        while !container.isAtEnd {
            do {
                valueAggregator.append(try container.decode(I.self))
                idx = idx + 1
            } catch let error as PolyDecodeNoTypesMatchedError {
                let errors: [ResourceObjectDecodingError] = error
                    .individualTypeFailures
                    .compactMap { decodingError in
                        switch decodingError.error {
                        case .typeMismatch(_, let context),
                             .valueNotFound(_, let context),
                             .keyNotFound(_, let context),
                             .dataCorrupted(let context):
                            return context.underlyingError as? ResourceObjectDecodingError
                        @unknown default:
                            return nil
                        }
                }
                guard errors.count == error.individualTypeFailures.count else {
                    throw IncludesDecodingError(error: error, idx: idx, totalIncludesCount: container.count ?? 0)
                }
                throw IncludesDecodingError(
                    error: IncludeDecodingError(failures: errors),
                    idx: idx,
                    totalIncludesCount: container.count ?? 0
                )
            } catch let error {
                throw IncludesDecodingError(error: error, idx: idx, totalIncludesCount: container.count ?? 0)
            }
        }

        values = valueAggregator
    }
}

extension Includes {
    public func appending(_ other: Includes<I>) -> Includes {
        return Includes(values: values + other.values)
    }
}

public func +<I: Include>(_ left: Includes<I>, _ right: Includes<I>) -> Includes<I> {
    return left.appending(right)
}

extension Includes: CustomStringConvertible {
    public var description: String {
        return "Includes(\(String(describing: values))"
    }
}

extension Includes where I == NoIncludes {
    public init() {
        values = []
    }
}

// MARK: - 0 includes
public typealias Include0 = Poly0
public typealias NoIncludes = Include0

// MARK: - 1 include
public typealias Include1 = Poly1
extension Includes where I: _Poly1 {
    public subscript(_ lookup: I.A.Type) -> [I.A] {
        return values.compactMap(\.a)
    }
}

// MARK: - 2 includes
public typealias Include2 = Poly2
extension Includes where I: _Poly2 {
    public subscript(_ lookup: I.B.Type) -> [I.B] {
        return values.compactMap(\.b)
    }
}

// MARK: - 3 includes
public typealias Include3 = Poly3
extension Includes where I: _Poly3 {
    public subscript(_ lookup: I.C.Type) -> [I.C] {
        return values.compactMap(\.c)
    }
}

// MARK: - 4 includes
public typealias Include4 = Poly4
extension Includes where I: _Poly4 {
    public subscript(_ lookup: I.D.Type) -> [I.D] {
        return values.compactMap(\.d)
    }
}

// MARK: - 5 includes
public typealias Include5 = Poly5
extension Includes where I: _Poly5 {
    public subscript(_ lookup: I.E.Type) -> [I.E] {
        return values.compactMap(\.e)
    }
}

// MARK: - 6 includes
public typealias Include6 = Poly6
extension Includes where I: _Poly6 {
    public subscript(_ lookup: I.F.Type) -> [I.F] {
        return values.compactMap(\.f)
    }
}

// MARK: - 7 includes
public typealias Include7 = Poly7
extension Includes where I: _Poly7 {
    public subscript(_ lookup: I.G.Type) -> [I.G] {
        return values.compactMap(\.g)
    }
}

// MARK: - 8 includes
public typealias Include8 = Poly8
extension Includes where I: _Poly8 {
    public subscript(_ lookup: I.H.Type) -> [I.H] {
        return values.compactMap(\.h)
    }
}

// MARK: - 9 includes
public typealias Include9 = Poly9
extension Includes where I: _Poly9 {
    public subscript(_ lookup: I.I.Type) -> [I.I] {
        return values.compactMap(\.i)
    }
}

// MARK: - 10 includes
public typealias Include10 = Poly10
extension Includes where I: _Poly10 {
    public subscript(_ lookup: I.J.Type) -> [I.J] {
        return values.compactMap(\.j)
    }
}

// MARK: - 11 includes
public typealias Include11 = Poly11
extension Includes where I: _Poly11 {
    public subscript(_ lookup: I.K.Type) -> [I.K] {
        return values.compactMap(\.k)
    }
}

// MARK: - 12 includes
public typealias Include12 = Poly12
extension Includes where I: _Poly12 {
    public subscript(_ lookup: I.L.Type) -> [I.L] {
        return values.compactMap(\.l)
    }
}

// MARK: - 13 includes
public typealias Include13 = Poly13
extension Includes where I: _Poly13 {
    public subscript(_ lookup: I.M.Type) -> [I.M] {
        return values.compactMap(\.m)
    }
}

// MARK: - 14 includes
public typealias Include14 = Poly14
extension Includes where I: _Poly14 {
    public subscript(_ lookup: I.N.Type) -> [I.N] {
        return values.compactMap(\.n)
    }
}

// MARK: - 15 includes
public typealias Include15 = Poly15
extension Includes where I: _Poly15 {
    public subscript(_ lookup: I.O.Type) -> [I.O] {
        return values.compactMap(\.o)
    }
}

// MARK: - DecodingError
public struct IncludesDecodingError: Swift.Error, Equatable {
    public let error: Swift.Error
    /// The zero-based index of the include that failed to decode.
    public let idx: Int
    /// The total count of includes in the document that failed to decode.
    ///
    /// In other words, "of `totalIncludesCount` includes, the `(idx + 1)`th
    /// include failed to decode.
    public let totalIncludesCount: Int

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.idx == rhs.idx
            && String(describing: lhs) == String(describing: rhs)
    }
}

extension IncludesDecodingError: CustomStringConvertible {
    public var description: String {
        let ordinalSuffix: String
        if (idx % 100) + 1 > 9 && (idx % 100) + 1 < 20 {
            // the teens
            ordinalSuffix = "th"
        } else {
            switch ((idx % 10) + 1) {
            case 1:
                ordinalSuffix = "st"
            case 2:
                ordinalSuffix = "nd"
            case 3:
                ordinalSuffix = "rd"
            default:
                ordinalSuffix = "th"
            }
        }
        let ordinalDescription = "\(idx + 1)\(ordinalSuffix)"

        return "Out of the \(totalIncludesCount) includes in the document, the \(ordinalDescription) one failed to parse: \(error)"
    }
}

public struct IncludeDecodingError: Swift.Error, Equatable, CustomStringConvertible {
    public let failures: [ResourceObjectDecodingError]

    public var description: String {
        // concise error when all failures are mismatched JSON:API types:
        if case let .jsonTypeMismatch(foundType: foundType)? = failures.first?.cause,
           failures.allSatisfy({ $0.cause.isTypeMismatch }) {
            let expectedTypes = failures
                .compactMap { "'\($0.resourceObjectJsonAPIType)'" }
                .joined(separator: ", ")

            return "Found JSON:API type '\(foundType)' but expected one of \(expectedTypes)"
        }

        // concise error when all but failures but one are type mismatches because
        // we can assume the correct type was found but there was some other error:
        let nonTypeMismatches = failures.filter({ !$0.cause.isTypeMismatch})
        if nonTypeMismatches.count == 1, let nonTypeMismatch = nonTypeMismatches.first {
            return String(describing: nonTypeMismatch)
        }

        // fall back to just describing all of the reasons it could not have been any of the available
        // types:
        return failures
            .enumerated()
            .map {
                "\nCould not have been Include Type `\($0.element.resourceObjectJsonAPIType)` because:\n\($0.element)"
        }.joined(separator: "\n")
    }
}
