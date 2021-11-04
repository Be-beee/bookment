//
//  Archive.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/01.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db: Realm!

    private init() {
        do {
            db = try Realm()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    
    // MARK: - Database Management Method, Record
    
    func loadRecords() -> Results<RecordContent> {
        return db.objects(RecordContent.self)
    }

    @discardableResult
    func addRecord(data: RecordContent) -> Bool {
        do {
            try db.write {
                db.add(data)
            }
        } catch {
            return false
        }
        return true
    }

    @discardableResult
    func updateRecord() -> Bool {
        return false
    }

    @discardableResult
    func deleteRecord(_ data: [RecordContent]) -> Bool {
        do {
            try db.write {
                db.delete(data)
            }
        } catch {
            return false
        }
        return true
    }
    
    func findRecordContents(_ isbn: String) -> [RecordContent] {
        let found = db.objects(RecordContent.self).filter(NSPredicate(format: "isbn = %@", isbn))
        return Array(found)
    }
    
    // MARK: - Database Management Method, HeartList
    func loadHeartContent() -> Results<HeartContent> {
        return db.objects(HeartContent.self)
    }
    
    @discardableResult
    func addHeartContent(data: HeartContent) -> Bool {
        do {
            try db.write {
                db.add(data)
            }
        } catch {
            return false
        }
        return true
    }
    
    @discardableResult
    func deleteHeartContent(_ data: [HeartContent]) -> Bool {
        do {
            try db.write {
                db.delete(data)
            }
        } catch {
            return false
        }
        return true
    }
    
    func findHeartContent(_ isbn: String) -> HeartContent? {
        guard let found = db.objects(HeartContent.self).filter(NSPredicate(format: "isbn = %@", isbn)).first else { return nil }
        return found
    }
    
    // MARK: - Database Management Method, BookInfo
    func loadBookInfos() -> [BookInfo] {
        let list = db.objects(BookInfo.self)
        return Array(list)
    }
    
    @discardableResult
    func addBookInfo(data: BookInfo) -> Bool {
        do {
            try db.write {
                db.add(data)
            }
        } catch {
            return false
        }
        return true
    }
    
    @discardableResult
    func deleteBookInfo(_ data: [BookInfo]) -> Bool {
        do {
            try db.write {
                db.delete(data)
            }
        } catch {
            return false
        }
        return true
    }
    
    
    // MARK: - Query Method
    // heartdict: [HeartContent], records: [RecordContent], AllBookData: [BookInfo]
    // CommonData 하위 메서드가 DatabaseManager 하위 메서드로 이동
    
    func findBookInfo(isbn: String) -> BookInfo? {
        guard let found = db.objects(BookInfo.self).filter(NSPredicate(format: "isbn = %@", isbn)).first else { return nil }
        return found
    }
    
    func sortRecords(isbn: String) -> [RecordContent] {
        let result = db.objects(RecordContent.self).filter(NSPredicate(format: "isbn = %@", isbn))
        
        return result.sorted { $0.date < $1.date }
    }
    
    func createMyLibraryList() -> [BookInfo] {
        let records = Array(db.objects(RecordContent.self))
        let isbnList = records.map { $0.isbn }
        var libraryList: [BookInfo] = []
        for isbn in isbnList {
            guard let result = db.objects(BookInfo.self).filter(NSPredicate(format: "isbn = %@", isbn)).first else { continue }
            libraryList.append(result)
        }
        // isbnList -> libraryList
        
        return libraryList
    }
}

extension DatabaseManager {
    
    // MARK: - RecordContent
    @discardableResult
    func addRecordToDB(_ record: RecordContent, _ book: BookInfo?) -> Bool {
        let result = DatabaseManager.shared.addRecord(data: record)
        if let _ = DatabaseManager.shared.findBookInfo(isbn: record.isbn) {
            return result
        } else {
            if let book = book {
                let result2 = DatabaseManager.shared.addBookInfo(data: book)
                return result && result2
            } else {
                return result
            }
        }
    }
    
    @discardableResult
    func deleteRecordToDB(_ record: RecordContent, _ book: BookInfo?) -> Bool {
        var heartContentCount = 0
        if let _ = DatabaseManager.shared.findHeartContent(record.isbn) {
            heartContentCount += 1
        }
        let foundRecordContents = DatabaseManager.shared.findRecordContents(record.isbn)
        
        var bookDeleteResult = true
        if Array(foundRecordContents).count + heartContentCount > 1, let book = book {
            bookDeleteResult = DatabaseManager.shared.deleteBookInfo([book])
        }
        let recordDeleteResult = DatabaseManager.shared.deleteRecord([record])
        return bookDeleteResult && recordDeleteResult
    }
    
    // MARK: - HeartContent
    @discardableResult
    func addHeartContentToDB(_ heart: HeartContent, _ book: BookInfo?) -> Bool {
        let result = DatabaseManager.shared.addHeartContent(data: heart)
        if let _ = DatabaseManager.shared.findBookInfo(isbn: heart.isbn) {
            return result
        } else {
            if let book = book {
                let result2 = DatabaseManager.shared.addBookInfo(data: book)
                return result && result2
            } else {
                return result
            }
        }
    }
    
    @discardableResult
    func deleteHeartContentToDB(_ heart: HeartContent, _ book: BookInfo?) -> Bool {
        let foundRecordContents = DatabaseManager.shared.findRecordContents(heart.isbn)
        
        var bookDeleteResult = true
        if Array(foundRecordContents).count == 0, let book = book {
            bookDeleteResult = DatabaseManager.shared.deleteBookInfo([book])
        }
        let heartDeleteResult = DatabaseManager.shared.deleteHeartContent([heart])
        return bookDeleteResult && heartDeleteResult
    }
}
