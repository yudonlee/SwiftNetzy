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
