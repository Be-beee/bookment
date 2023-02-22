//
//  HeartContentRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/16.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

protocol HeartContentRepository {
    @discardableResult
    func add(_ content: HeartContent, with bookInfo: BookInfo?) -> Bool
    
    @discardableResult
    func delete(with isbn: String) -> Bool
    
    func find(with isbn: String) -> HeartContent?
}
