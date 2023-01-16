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
    
    // MARK: - Basic Functions
    
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
    
    func find<T: Object>(with key: String) -> [T] {
        let found = db.objects(T.self).filter(NSPredicate(format: "isbn = %@", key))
        return Array(found)
    }
    
    func load<T: Object>() -> Results<T> {
        return db.objects(T.self)
    }
}

// TODO: 제네릭 적용해서 하나의 메서드들만 놔두고 (add, delete, find) 나머지는 다 Repository로 이동 시키기

extension DatabaseManager {
    
    // MARK: - HeartContent
    @discardableResult
    func addHeartContentToDB(_ heart: HeartContent, _ book: BookInfoLocalDTO?) -> Bool {
        let result = add(heart)
        let foundBookInfos: [BookInfoLocalDTO] = find(with: heart.isbn)
        if foundBookInfos.count > 0 {
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
    func deleteHeartContentToDB(_ heart: HeartContent, _ bookIsbn: String?) -> Bool {
        let foundRecordContents: [RecordContent] = find(with: heart.isbn)
        
        var bookDeleteResult = true
        if Array(foundRecordContents).count == 0, let bookIsbn = bookIsbn {
            let foundBookInfo: [BookInfoLocalDTO] = find(with: bookIsbn)
            bookDeleteResult = delete(foundBookInfo)
        }
        let heartDeleteResult = delete([heart])
        return bookDeleteResult && heartDeleteResult
    }
}
