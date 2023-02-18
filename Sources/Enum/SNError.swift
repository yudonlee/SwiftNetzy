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
