//
//  AddNewBookRecordViewModel.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/23.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

final class AddNewBookRecordViewModel {
    
    // MARK: - Properties
    
    private(set) var selectedBookInfo: BookInfo
    private var newRecordContent: RecordContent
    
    private let repository: RecordRepository
    
    // MARK: - Init(s)
    
    init(bookInfo: BookInfo, record: RecordContent = RecordContent()) {
        self.selectedBookInfo = bookInfo
        self.newRecordContent = record
        
        self.repository = RecordLocalRepository()
    }
    
    // MARK: - Functions
    
    func saveRecord(date: Date, text: String? = nil) {
        let recordContent = RecordContent(
            isbn: selectedBookInfo.isbn,
            date: date,
            text: text ?? ""
        )
        self.newRecordContent = recordContent
        
        repository.add(newRecordContent, with: selectedBookInfo.dto)
    }
}
