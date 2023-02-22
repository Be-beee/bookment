//
//  BookInfoLocalRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/17.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

import RealmSwift

final class BookInfoLocalRepository: BookInfoRepository {
    
    // MARK: - Properties
    
    let databaseManager = DatabaseManager.shared
    
    
    // MARK: - Find Functions
    
    func find(with content: HeartContent) -> BookInfo? {
        let loadedBookInfo: BookInfoLocalDTO? = databaseManager.find(with: content.isbn)
        
        return loadedBookInfo?.entity()
    }
    
}
