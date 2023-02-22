//
//  CommonCellViewModel.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/18.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

final class CommonCellViewModel {
    
    // MARK: - Properties
    
    private(set) var bookInfo: BookInfo? {
        didSet {
            guard let _ = bookInfo else { return }
            delegate?.bookInfoDidChange()
        }
    }
    private(set) var readonly: Bool = false {
        didSet {
            delegate?.commonCellModeDidChange()
        }
    }
    
    private let repository: HeartContentRepository
    
    weak var delegate: CommonCellViewModelDelegate?
    
    // MARK: - Init(s)
    
    init() {
        self.repository = HeartContentLocalRepository()
    }
    
    // MARK: - Configure Functions
    
    func configure(bookInfo: BookInfo, readonly: Bool? = nil) {
        self.bookInfo = bookInfo
        if let readonly {
            self.readonly = readonly
        }
    }
    
    // MARK: - Functions
    
    func checkHeartList(isbn: String) -> Bool {
        return repository.find(with: isbn) != nil
    }
    
    func addToHeartList(_ content: HeartContent, with bookInfo: BookInfo?) {
        repository.add(content, with: bookInfo)
    }
    
    func deleteFromHeartList(with isbn: String) {
        repository.delete(with: isbn)
    }
    
}
