//
//  Endpoint.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

enum Endpoint {
    case search
    case image(String)
    
    var path: String {
        let clientData = ClientData()
        switch self {
        case .search: return clientData.requestURL
        case .image(let url): return url
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search: return .GET
        case .image: return .GET
        }
    }
}
