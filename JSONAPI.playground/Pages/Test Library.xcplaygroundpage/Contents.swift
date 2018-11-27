//: [Previous](@previous)

import Foundation
import JSONAPI
import JSONAPITestLib

/*******

Please enjoy these examples, but allow me the forced casting and the lack of error checking for the sake of brevity.

********/

// MARK: - Literal Expressibility
// The JSONAPITestLib provides literal expressibility for key types to
// make creating tests easier
let dog = Dog(id: "1234", attributes: Dog.Attributes(name: "Buddy"), relationships: Dog.Relationships(owner: nil))
