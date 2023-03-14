//
//  File.swift
//  
//
//  Created by 이유돈 on 2023/02/16.
//

import Foundation

public protocol URLEnable {
    func toURL() throws -> URL
}

extension String: URLEnable {
    public func toURL() throws -> URL {
        guard let url = URL(string: self) else { throw SNError.invalidURL(url: self) }
        return url
    }
}

extension URL: URLEnable {
    public func toURL() throws -> URL {
        return self
    }
}

extension URLComponents: URLEnable {
    public func toURL() throws -> URL {
        guard let url = url else { throw SNError.invalidURL(url: self) }
        return url
    }
}

extension URLRequest {
    /// Creates URL Request with "url", "method", headers"
    /// - Parameters:
    ///   - url: The URLEnable  Value
    ///   - method: The Http method(ex. get, post, put, delete)
    ///   - headers: The Http headers
    /// - Throws: Error thrown when converting URLEnable to a URL has failed
    public init(url: URLEnable, method: HTTPMethod, headers: [String: String] = [:]) throws {
        let url = try url.toURL()
        
        self.init(url: url)
        
        httpMethod = method.rawValue
        allHTTPHeaderFields = headers
    }
}




