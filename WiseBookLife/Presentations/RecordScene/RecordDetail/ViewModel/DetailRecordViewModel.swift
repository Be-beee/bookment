//
//  DetailRecordViewModel.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/13.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

final class DetailRecordViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DetailRecordViewModelDelegate?
    
    private(set) var records: [RecordContent] = [] {
        didSet {
            delegate?.recordDetailDidChange()
        }
    }
    let bookInfo: BookInfo
    
    // MARK: - Computed Properties
    
    var recordsCount: Int { records.count }
    
    // MARK: - Init(s)
    
    init(bookInfo: BookInfo) {
        self.bookInfo = bookInfo
        configureRecords()
    }
    
    // MARK: - Configure Functions
    
    private func configureRecords() {
        let databaseManager = DatabaseManager.shared
        let records = databaseManager.sortRecords(isbn: bookInfo.isbn)
        
        self.records = records
    }
    
    // MARK: - Add Function
    
    func addRecord(_ record: RecordContent) {
        let databaseManager = DatabaseManager.shared
        databaseManager.addRecordToDB(record, bookInfo.dto)
        
        reloadRecords()
    }
    
    // MARK: - Delete Function
    
    func deleteRecord(at index: Int) {
        let databaseManager = DatabaseManager.shared
        let selectedRecord = records[index]
        
        // TODO: 오류 생길 수도 있음 확인 필요
        databaseManager.deleteRecordToDB(selectedRecord, bookInfo.dto)
    }
    
    
    // MARK: - Reload Function
    
    func reloadRecords() {
        let databaseManager = DatabaseManager.shared
        records = databaseManager.sortRecords(isbn: bookInfo.isbn)
    }
    
}
