//
//  CommonCell.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/01.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

final class CommonCell: UITableViewCell {

    // MARK: - UI Properties
    
    @IBOutlet var bookCover: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var heartBtn: UIButton!
    @IBOutlet weak var addLibraryBtn: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: CommonCellDelegate?
    
    var bookInfo: BookInfo? {
        didSet {
            configure()
        }
    }
    
    var readonly: Bool = false {
        didSet {
            addLibraryBtn.isHidden = readonly
            if !readonly { configureAddButtonAction() }
        }
    }
    
    var isHeartOn = false
    
    // MARK: - Configure Functions
    
    private func configure() {
        configureViews()
        configureHeartButtonAction()
    }
    
    private func configureViews() {
        guard let bookInfo else { return }
        
        let imagePath = bookInfo.image
        Task {
            bookCover.image = await ImageDownloader.urlToImage(from: imagePath)
        }
        if bookInfo.title.isEmpty {
            titleLabel.text = StringLiteral.emptyTitle
            titleLabel.textColor = .lightGray
        } else {
            titleLabel.text = bookInfo.title
        }
        
        authorLabel.text = bookInfo.author
        
        let databaseManager = DatabaseManager.shared
        let heartType = (databaseManager.findHeartContent(bookInfo.isbn) != nil)
                            ? StringLiteral.heartFill : StringLiteral.heartEmpty
        heartBtn.setImage(UIImage(systemName: heartType), for: .normal)
    }
    
    private func configureHeartButtonAction() {
        heartBtn.addTarget(self, action: #selector(heartButtonDidTouch), for: .touchUpInside)
    }
    
    private func configureAddButtonAction() {
        addLibraryBtn.addTarget(self, action: #selector(addLibraryButtonDidTouch), for: .touchUpInside)
    }
}

// MARK: - objc Functions

extension CommonCell {
    
    @objc func heartButtonDidTouch(_ sender: UIButton!) {
        // TODO: button이 눌렸는지 아닌지에 따라 이미지 바뀌도록 수정
        guard let bookInfo else { return }
        
        if let foundHeartContent = DatabaseManager.shared.findHeartContent(bookInfo.isbn) {
            sender.setImage(UIImage(systemName: StringLiteral.heartEmpty), for: .normal)
            DatabaseManager.shared.deleteHeartContentToDB(foundHeartContent, bookInfo.isbn)
        } else {
            sender.setImage(UIImage(systemName: StringLiteral.heartFill), for: .normal)
            let newHeartContent = HeartContent(isbn: bookInfo.isbn, date: Date())
            DatabaseManager.shared.addHeartContentToDB(newHeartContent, bookInfo)
        }
        
        delegate?.heartButtonDidTouch()
    }
    
    
    @objc func addLibraryButtonDidTouch() {
        let addBookViewID = AddBookViewController.name
        guard let addLibraryVC = loadViewController(with: addBookViewID) as? AddBookViewController,
              let bookInfo = bookInfo
        else { return }
        
        addLibraryVC.selectedBookInfo = bookInfo
        delegate?.addBookButtonDidTouched(destinationView: addLibraryVC)
    }
}

// MARK: - Namespaces

extension CommonCell {
    enum StringLiteral {
        static let emptyTitle = "[NO TITLE]"
        static let heartFill = "heart.fill"
        static let heartEmpty = "heart"
    }
}
