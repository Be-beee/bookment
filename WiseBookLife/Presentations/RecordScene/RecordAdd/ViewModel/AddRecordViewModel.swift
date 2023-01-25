//
//  AddRecordViewModel.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/24.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

final class AddRecordViewModel {
    
    // MARK: - Properties
    
    private var isbn: String
    private var recordContent: RecordContent? {
        didSet {
            guard let recordContent else { return }
            repository.add(recordContent, with: nil)
        }
    }
    
    private let repository: RecordRepository
    
    // MARK: - Init(s)
    
    init(isbn: String, recordContent: RecordContent? = nil) {
        self.isbn = isbn
        self.recordContent = recordContent
        
        self.repository = RecordLocalRepository()
    }
    
    // MARK: - Functions
    
    func add(date: Date, text: String) {
        let newRecordContent = RecordContent(isbn: isbn, date: date, text: text)
        self.recordContent = newRecordContent
    }
    
}
