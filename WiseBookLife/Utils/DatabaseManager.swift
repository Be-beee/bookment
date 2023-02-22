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
