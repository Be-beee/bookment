//
//  RecordViewModel.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/13.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

import RealmSwift

final class RecordViewModel {
    
    // MARK: - Properties
    
    private let recordRepository: RecordRepository
    
    private var books: [BookInfo] = [] {
        didSet {
            delegate?.recordsDidChange()
        }
    }
    
    weak var delegate: RecordViewModelDelegate?
    
    
    // MARK: - Computed Properties
    
    var count: Int { books.count }
    
    // MARK: - Subscript
    
    subscript(_ index: Int) -> BookInfo {
        return books[index]
    }
    
    // MARK: - Init(s)
    
    init() {
        recordRepository = RecordLocalRepository()
        configureThumbnailList()
    }
    
    // MARK: - Configure Function
    
    private func configureThumbnailList() {
        self.books = recordRepository.loadThumbnails()
    }
    
    // MARK: - Add Function
    
    func add(record: RecordContent, bookInfo: BookInfo) {
        recordRepository.add(record, with: bookInfo.dto)
        configureThumbnailList()
    }
    
    // MARK: - Delete Functions
    
    func delete(at index: Int) {
        recordRepository.deleteAll(with: books[index].isbn)
        configureThumbnailList()
    }
    
}
