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
    
    private let repository: RecordLocalRepository
    private(set) var records: [RecordContent] = [] {
        didSet {
            delegate?.recordDetailDidChange()
        }
    }
    
    let bookInfo: BookInfo
    
    weak var delegate: DetailRecordViewModelDelegate?
    
    // MARK: - Computed Properties
    
    var recordsCount: Int { records.count }
    
    // MARK: - Init(s)
    
    init(bookInfo: BookInfo) {
        self.bookInfo = bookInfo
        repository = RecordLocalRepository()
        
        configureRecords()
    }
    
    // MARK: - Configure Functions
    
    private func configureRecords() {
        let records = repository.loadRecords(with: bookInfo.isbn)
        
        self.records = records
    }
    
    // MARK: - Add Function
    
    func addRecord(_ record: RecordContent) {
        repository.add(record, with: bookInfo.dto)
        
        configureRecords()
    }
    
    // MARK: - Delete Function
    
    func deleteRecord(at index: Int) {
        let selectedRecord = records[index]
        repository.delete(selectedRecord)
        
        configureRecords()
    }
    
}
