//
//  File.swift
//  
//
//  Created by 이유돈 on 2023/02/16.
//

import Foundation

protocol URLEnable {
    func toURL() throws -> URL
}

extension String: URLEnable {
    func toURL() throws -> URL {
        guard let url = URL(string: self) else { throw SNError.invalidURL(url: self) }
        return url
    }
}

extension URL: URLEnable {
    func toURL() throws -> URL {
        return self
    }
}
extension URLComponents: URLEnable {
    func toURL() throws -> URL {
        guard let url = url else { throw SNError.invalidURL(url: self) }
        return url
    }
}









