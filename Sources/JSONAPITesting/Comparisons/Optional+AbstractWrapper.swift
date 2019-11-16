//
//  Optional+AbstractWrapper.swift
//  JSONAPITesting
//
//  Created by Mathew Polzin on 11/15/19.
//

protocol _AbstractWrapper {
    var abstractSelf: Any? { get }
}

extension Optional: _AbstractWrapper {
    var abstractSelf: Any? {
        return self
    }
}
