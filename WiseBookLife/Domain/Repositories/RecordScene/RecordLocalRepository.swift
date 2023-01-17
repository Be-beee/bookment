//
//  RecordLocalRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/15.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

import RealmSwift

final class RecordLocalRepository: RecordRepository {
    
    // MARK: - Properties
    
    let databaseManager = DatabaseManager.shared
    
    // MARK: - Load Functions
    
    func loadThumbnails() -> [BookInfo] {
        let results: Results<RecordContent> = databaseManager.load()
        let loaded = results.distinct(by: ["isbn"]).map{ $0.isbn }
        let thumbnails: [BookInfo] = loaded.compactMap {
            let bookInfo: BookInfoLocalDTO? = databaseManager.find(with: $0)
            return bookInfo?.entity()
        }
        
        return thumbnails
    }
    
    func loadRecords(with isbn: String, sorted: Bool = true) -> [RecordContent] {
        let result: [RecordContent] = databaseManager.findAll(with: isbn)
        
        if sorted {
            return result.sorted { $0.date < $1.date }
        } else { return result }
    }
    
    // MARK: - Add/Delete Functions
    
    @discardableResult
    func add(_ record: RecordContent, with book: BookInfoLocalDTO?) -> Bool {
        let result = databaseManager.add(record)
        
        if let _: BookInfoLocalDTO = databaseManager.find(with: record.isbn) {
            return result
        } else {
            if let book = book {
                let result2 = databaseManager.add(book)
                return result && result2
            } else {
                return result
            }
        }
    }
    
    @discardableResult
    func delete(_ record: RecordContent) -> Bool {
        print("delete one record")
        let book: [BookInfoLocalDTO] = databaseManager.findAll(with: record.isbn)
        
        var heartContentCount = 0
        
        if let _: HeartContent = databaseManager.find(with: record.isbn) {
            heartContentCount += 1
        }
        
        let foundRecordContents: [RecordContent] = databaseManager.findAll(with: record.isbn)
        
        var bookDeleteResult = true
        if foundRecordContents.count + heartContentCount == 1 {
            bookDeleteResult = databaseManager.delete(book)
        }
        let recordDeleteResult = databaseManager.delete([record])
        return bookDeleteResult && recordDeleteResult
    }
    
    func deleteAll(with isbn: String) {
        print("delete all records")
        let deleteItems: [RecordContent] = databaseManager.load().filter {
            $0.isbn == isbn
        }
        databaseManager.delete(Array(deleteItems))
    }
    
}
