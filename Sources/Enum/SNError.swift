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
        case invalidContentType(contentType: String, encoding: ParameterEncoding)
        case urlEncodingFailed(parameters: [String: String])
        case jsonEncodingFailed(parameters: [String: String])
    }
    
    public enum URLRequestFailure: Error {
        case isURLEmpty(urlRequest: URLRequest)
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

extension SNError.EncodingFailure: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidContentType(let contentType, let encoding):
            return "Content-Type header \(contentType) in an HTTP request did not match the encoding mode \(encoding.self)"
        case .urlEncodingFailed(let parameters):
            let failureParams = parameters.map { "key: \($0), value: \($1)"}.joined(separator: ",")
            return "The attempt to URL encode \(failureParams) has failed."
        case .jsonEncodingFailed(let parameters):
            let failureParams = parameters.map { "key: \($0), value: \($1)"}.joined(separator: ",")
            return "The attempt to JSON encode \(failureParams) has failed."
        }
    }
}

extension SNError.URLRequestFailure: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .isURLEmpty(let urlRequest):
            return "URLRequest has no URL: \(urlRequest)"
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
