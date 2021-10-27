//
//  Archive.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/01.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit
import RealmSwift

// 아카이빙하기

struct Archive<T: Codable> {
    func save(_ obj: T, fileName: String) {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let filePath = directory.appendingPathComponent(fileName)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(obj)
            if FileManager.default.fileExists(atPath: filePath.path) {
                try FileManager.default.removeItem(at: filePath)
            }
            FileManager.default.createFile(atPath: filePath.path, contents: data, attributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func load(fileName: String, as type: T.Type) -> T? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let filePath = directory.appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: filePath.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: filePath.path) else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
}



// MARK:- Archiving Test
func saveData(data: Any, at: String) {
    DispatchQueue.global().async {
        let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        guard let archivedURL = documentDirectory?.appendingPathComponent(at) else {
            return
        }
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            try archivedData.write(to: archivedURL)
        } catch {
            print(error)
        }
    }
}

func loadData(at: String) -> Any? {
    let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    
    guard let archiveURL = documentDirectory?.appendingPathComponent(at) else {
        return nil
    }
    
    guard let codedData = try? Data(contentsOf: archiveURL) else {
        return nil
    }
    
    guard let unarchivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) else {
        return nil
    }
    return unarchivedData
}

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

    
    // MARK: - Database Management Method
    
    func loadRecords() -> [Record] {
        let list = db.objects(Record.self)
        return Array(list)
    }

    func addRecord(data: Record) -> Bool {
        do {
            try db.write {
                db.add(data)
            }
        } catch {
            return false
        }
        return true
    }

    func updateRecord() -> Bool {
        return false
    }

    func deleteRecord(from: [Record], index: Int) -> Bool {
        do {
            try db.write {
                db.delete(from[index])
            }
        } catch {
            return false
        }
        return true
    }

    func deleteAllRecords() -> Bool {
        do {
            try db.write {
                db.deleteAll()
            }
        } catch {
            return false
        }
        return true
    }

}
