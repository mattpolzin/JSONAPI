//
//  DocumentDecodingErro.swift
//  
//
//  Created by Mathew Polzin on 10/20/19.
//

public enum JSONAPIDocumentDecodingError: Swift.Error {
    case foundErrorDocumentWhenExpectingSuccess
    case foundSuccessDocumentWhenExpectingError
}
