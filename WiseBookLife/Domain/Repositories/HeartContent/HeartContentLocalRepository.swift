//
//  HeartContentLocalRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/17.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

final class HeartContentLocalRepository: HeartContentRepository {
    
    // MARK: - Properties
    
    let databaseManager = DatabaseManager.shared
    
    // MARK: - Add Function
    
    @discardableResult
    func add(_ content: HeartContent, with bookInfo: BookInfo? = nil) -> Bool {
        let result = databaseManager.add(content)
        
        if let _: BookInfoLocalDTO = databaseManager.find(with: content.isbn) {
            return result
        } else {
            if let bookInfo {
                let result2 = databaseManager.add(bookInfo.dto)
                return result && result2
            }
            return result
        }
    }
    
    // MARK: - Delete Function
    
    @discardableResult
    func delete(with isbn: String) -> Bool {
        guard let content: HeartContent = databaseManager.find(with: isbn)
        else { return false }
        
        let foundRecord: RecordContent? = databaseManager.find(with: content.isbn)
        
        var bookDeleteResult = true
        if foundRecord == nil {
            guard let foundBookInfo: BookInfoLocalDTO = databaseManager.find(with: content.isbn)
            else { return false }
            
            bookDeleteResult = databaseManager.delete(foundBookInfo)
        }
        let heartDeleteResult = databaseManager.delete(content)
        
        return bookDeleteResult && heartDeleteResult
    }
    
    // MARK: - Find Function
    
    func find(with isbn: String) -> HeartContent? {
        let foundContent: HeartContent? = databaseManager.find(with: isbn)
        return foundContent
    }
    
}
