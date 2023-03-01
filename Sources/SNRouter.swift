//
//  File.swift
//  
//
//  Created by yudonlee on 2023/03/01.
//

import Foundation

public class SNRouter<Target: URLTarget> {
    
    func request<T: Codable>(target: Target, type: T.Type) async throws -> T {
        let url = "\(target.baseURL)\(target.path)"
        return try await SwiftNetzy.request(type, url, method: target.method, headers: target.headers, params: target.params, body: target.body, encoding: target.encoding)
    }

}

