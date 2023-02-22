//
//  BookInfoRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/17.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

protocol BookInfoRepository {
    func find(with content: HeartContent) -> BookInfo?
}
