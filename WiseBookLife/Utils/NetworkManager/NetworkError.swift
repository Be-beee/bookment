//
//  NetworkError.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

enum NetworkError: String, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("엔드포인트 설정이 잘못되었습니다.", comment: "Invalid URL")
        case .invalidResponse:
            return NSLocalizedString("정상 응답 코드가 아닙니다.", comment: "Invalid Response")
        case .decodingFailed:
            return NSLocalizedString("디코딩에 실패했습니다.", comment: "Decoding Failed")
        }
    }
}
