//
//  File.swift
//  
//
//  Created by yudonlee on 2023/03/01.
//

import Foundation

public protocol URLTarget {
    var baseURL: String { get }
    var path: String { get }
    var params: [String: String] { get }
    var body: [String: String] { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
    var encoding: Encoding { get }
}
