//
//  RecordViewModel.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/13.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

final class RecordViewModel {
    
    // MARK: - Properties
    
    private(set) var records: [BookInfo] = [] {
        didSet {
            delegate?.recordsDidChange()
        }
    }
    
    weak var delegate: RecordViewModelDelegate?
    
    // MARK: - Computed Properties
    
    var count: Int { records.count }
    
    // MARK: - Subscript
    
    subscript(_ index: Int) -> BookInfo {
        return records[index]
    }
    
    // MARK: - Init(s)
    
    init() {
        configureThumbnailList()
    }
    
    // MARK: - Configure Function
    
    // TODO: Repository, UseCase로 분리
    private func configureThumbnailList() {
        // 아카이빙 되어 있는 책 정보 불러오기
        let databaseManager = DatabaseManager.shared
        let loaded = DatabaseManager.shared.loadRecords().distinct(by: ["isbn"]).map{ $0.isbn }
        let list: [BookInfo] = loaded.compactMap {
            databaseManager.findBookInfo(isbn: $0)?.entity()
        }
        
        self.records = list
    }
    
    // MARK: - Add Function
    
    func add(record: RecordContent, bookInfo: BookInfo) {
        let databaseManager = DatabaseManager.shared
        databaseManager.addRecordToDB(record, bookInfo.dto)
        
        configureThumbnailList()
    }
    
    
    // MARK: - Delete Function
    
    func delete(at index: Int) {
        let databaseManager = DatabaseManager.shared
        
        let willDeleteISBN = records[index].isbn
        let deleteItems = databaseManager.loadRecords().filter {
            $0.isbn == willDeleteISBN
        }
        
        databaseManager.deleteRecord(Array(deleteItems))
        
        configureThumbnailList()
    }
    
}
