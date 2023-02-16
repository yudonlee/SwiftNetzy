//
//  File.swift
//  
//
//  Created by 이유돈 on 2023/02/16.
//

import Foundation

enum SNError: Error {
    case invalidURL(url: URLEnable)
    case invalidHttpResponse(statusCode: Int)
}

extension SNError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "URL \(url) is not valid"
        case .invalidHttpResponse(let statusCode):
            return "Http Request is not valid. Error Status code is \(statusCode)"
        }
    }
}
