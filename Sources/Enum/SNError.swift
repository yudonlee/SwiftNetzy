//
//  File.swift
//  
//
//  Created by 이유돈 on 2023/02/16.
//

import Foundation

public enum SNError: Error {
    case invalidURL(url: URLEnable)
    case invalidHttpResponse(statusCode: Int)
    
    public enum EncodingFailure: Error {
        case contentTypeInvalid(contentType: String, encoding: Encoding)
    }
}

extension SNError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "URL is not valid: \(url)"
        case .invalidHttpResponse(let statusCode):
            return "Http Request is not valid. Error Status code is \(statusCode)"
        }
    }
}

extension SNError.EncodingFailure {
    public var errorDescription: String? {
        switch self {
        case .contentTypeInvalid(let contentType, let encoding):
            return "Content-Type header \(contentType) in an HTTP request did not match the encoding mode \(encoding.rawValue)"
        }
    }
}

extension SNError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .invalidURL(let url):
            return "URL \(url) is not valid"
        case .invalidHttpResponse(let statusCode):
            return "Http Request is not valid. Error Status code is \(statusCode)"
        }
    }
}
