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
        let dbFormData = bookData.dto
        let newHeartContent = HeartContent(isbn: bookData.isbn, date: Date())
        DatabaseManager.shared.addHeartContentToDB(newHeartContent, dbFormData)
        isHeartBtnSelected.toggle()
    }
    
    // TODO: UseCase, Repository로 분리
    func deleteFromHeartList() {
        let willDeleteData = bookData
        guard let foundHeartContent: HeartContent = DatabaseManager.shared.find(with: willDeleteData.isbn)
        else { return }
        DatabaseManager.shared.deleteHeartContentToDB(
            foundHeartContent,
            willDeleteData.isbn
        )
        isHeartBtnSelected.toggle()
    }
    
}
