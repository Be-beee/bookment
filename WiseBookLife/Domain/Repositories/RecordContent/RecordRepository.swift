//
//  RecordRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/15.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

protocol RecordRepository {
    func loadThumbnails() -> [BookInfo]
    
    func loadRecords(with isbn: String, sorted: Bool) -> [RecordContent]
    
    @discardableResult
    func add(_ record: RecordContent, with book: BookInfoLocalDTO?) -> Bool
    
    @discardableResult
    func delete(_ record: RecordContent) -> Bool
    
    func deleteAll(with isbn: String)
}
