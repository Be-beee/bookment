//
//  BookDetailViewModel.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/27.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

final class BookDetailViewModel {
    // MARK: - Properties
    
    private let heartContentRepository: HeartContentRepository
    
    weak var delegate: BookDetailViewModelDelegate?

    var bookData: BookInfo
    var isHeartBtnSelected: Bool = false {
        didSet {
            delegate?.heartButtonStatusChanged()
        }
    }
    
    // MARK: - Init(s)
    
    init(bookData: BookInfo = BookInfo()) {
        self.bookData = bookData
        heartContentRepository = HeartContentLocalRepository()
        
        configureHeartButtonStatus()
    }
    
    // MARK: - Configure Functions
    
    private func configureHeartButtonStatus() {
        let found: HeartContent? = DatabaseManager.shared.find(with: bookData.isbn)
        self.isHeartBtnSelected = found != nil
    }
    
    // MARK: - Functions
    
    // TODO: UseCase, Repository로 분리
    func addToHeartList() {
        let newHeartContent = HeartContent(isbn: bookData.isbn, date: Date())
        heartContentRepository.add(newHeartContent, with: bookData)
        isHeartBtnSelected.toggle()
    }
    
    // TODO: UseCase, Repository로 분리
    func deleteFromHeartList() {
        heartContentRepository.delete(with: bookData.isbn)
        isHeartBtnSelected.toggle()
    }
    
}
