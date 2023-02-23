//
//  File.swift
//  
//
//  Created by 이유돈 on 2023/02/23.
//

import Foundation

public enum Encoding: String {
    // default http encoding is url decoded
    case parameterUrlEncoded
    case bodyJsonEncoded
    case bodyURLEncoded
}
