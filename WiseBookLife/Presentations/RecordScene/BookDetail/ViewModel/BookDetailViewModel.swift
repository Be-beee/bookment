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
        self.isHeartBtnSelected = DatabaseManager.shared.findBookInfo(isbn: bookData.isbn) != nil
    }
    
    // MARK: - Functions
    
    // TODO: UseCase, Repository로 분리
    func addToHeartList() {
        let dbFormData = bookData
        let newHeartContent = HeartContent(isbn: bookData.isbn, date: Date())
        DatabaseManager.shared.addHeartContentToDB(newHeartContent, dbFormData)
        isHeartBtnSelected.toggle()
    }
    
    // TODO: UseCase, Repository로 분리
    func deleteFromHeartList() {
        let willDeleteData = bookData
        guard let foundHeartContent = DatabaseManager.shared.findHeartContent(willDeleteData.isbn)
        else { return }
        DatabaseManager.shared.deleteHeartContentToDB(
            foundHeartContent,
            willDeleteData.isbn
        )
        isHeartBtnSelected.toggle()
    }
    
}
