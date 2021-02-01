//
//  Archive.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/01.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

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
