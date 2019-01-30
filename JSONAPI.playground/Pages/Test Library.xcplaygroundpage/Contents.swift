//: [Previous](@previous)

import Foundation
import JSONAPI
import JSONAPITesting

/*******

Please enjoy these examples, but allow me the forced casting and the lack of error checking for the sake of brevity.

********/

// MARK: - Literal Expressibility
// The JSONAPITesting framework provides literal expressibility for key types to
// make creating tests easier
let dog = Dog(id: "1234", attributes: Dog.Attributes(name: "Buddy"), relationships: Dog.Relationships(owner: nil), meta: .none, links: .none)

// MARK: - JSON API structure checking
// The JSONAPITesting framework provides a `check` function for each Entity type
// that uses reflection to catch mistakes that are not forbidden by
// Swift's type system but will result in unexpected results when
// encoding/decoding. It is a good idea to add a `check` to each of
// your unit tests that create Entities.
try Dog.check(dog)
