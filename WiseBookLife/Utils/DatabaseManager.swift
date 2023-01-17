//
//  DatabaseManager.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/01.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit
import RealmSwift

class DatabaseManager {
    
    // MARK: - Properties
    
    static let shared = DatabaseManager()
    private let db: Realm!
    
    // MARK: - Init(s)
    
    private init() {
        do {
            db = try Realm()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Add Function
    
    @discardableResult
    func add<T: Object>(_ content: T) -> Bool {
        do {
            try db.write {
                db.add(content)
            }
        } catch {
            return false
        }
        return true
    }
    
    // MARK: - Delete Functions
    
    @discardableResult
    func delete<T: Object>(_ contents: [T]) -> Bool {
        do {
            try db.write {
                db.delete(contents)
            }
        } catch {
            return false
        }
        return true
    }
    
    @discardableResult
    func delete<T: Object>(_ content: T) -> Bool {
        do {
            try db.write {
                db.delete(content)
            }
        } catch {
            return false
        }
        return true
    }
    
    // MARK: - Load Function
    
    func load<T: Object>() -> Results<T> {
        return db.objects(T.self)
    }
    
    // MARK: - Find Functions
    
    func find<T: Object>(with key: String) -> T? {
        let found = db.objects(T.self).filter(NSPredicate(format: "isbn = %@", key))
        return Array(found).first
    }
    
    func findAll<T: Object>(with key: String) -> [T] {
        let found = db.objects(T.self).filter(NSPredicate(format: "isbn = %@", key))
        return Array(found)
    }
    
}

// TODO: 제네릭 적용해서 하나의 메서드들만 놔두고 (add, delete, find) 나머지는 다 Repository로 이동 시키기

extension DatabaseManager {
    
    // MARK: - HeartContent
    @discardableResult
    func addHeartContentToDB(_ heart: HeartContent, _ book: BookInfoLocalDTO?) -> Bool {
        let result = add(heart)
        
        if let _: BookInfoLocalDTO = find(with: heart.isbn) {
            return result
        } else {
            if let book = book {
                let result2 = add(book)
                return result && result2
            } else {
                return result
            }
        }
    }
    
    @discardableResult
    func deleteHeartContentToDB(_ heartContent: HeartContent, _ bookIsbn: String?) -> Bool {
        let foundRecord: RecordContent? = find(with: heartContent.isbn)
        
        var bookDeleteResult = true
        if foundRecord == nil, let bookIsbn = bookIsbn {
            guard let foundBookInfo: BookInfoLocalDTO = find(with: bookIsbn)
            else { return false }
            
            bookDeleteResult = delete(foundBookInfo)
        }
        let heartDeleteResult = delete(heartContent)
        return bookDeleteResult && heartDeleteResult
    }
}
