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

    var bookData: BookInfo
    var isHeartBtnSelected: Bool = false
    
    // MARK: - Init(s)
    
    init(bookData: BookInfo = BookInfo()) {
        self.bookData = bookData
        
        configureHeartButtonStatus()
    }
    
    // MARK: - Functions
    
    private func configureHeartButtonStatus() {
        self.isHeartBtnSelected = DatabaseManager.shared.findBookInfo(isbn: bookData.isbn) != nil
    }
}
