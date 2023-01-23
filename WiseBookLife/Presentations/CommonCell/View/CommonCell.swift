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
    
    private let viewModel = CommonCellViewModel()
    
    weak var delegate: CommonCellDelegate?
    
    // MARK: - Computed Properties
    
    var bookInfo: BookInfo? { viewModel.bookInfo }
    
    // MARK: - Configure Functions
    
    private func configure() {
        configureViews()
        configureHeartButtonAction()
    }
    
    private func configureViews() {
        guard let bookInfo = bookInfo else { return }
        
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
        
        let heartType = (viewModel.checkHeartList(isbn: bookInfo.isbn)) ?
                            StringLiteral.heartFill : StringLiteral.heartEmpty
        heartBtn.setImage(UIImage(systemName: heartType), for: .normal)
    }
    
    private func configureHeartButtonAction() {
        heartBtn.addTarget(self, action: #selector(heartButtonDidTouch), for: .touchUpInside)
    }
    
    private func configureAddButtonAction() {
        addLibraryBtn.addTarget(self, action: #selector(addLibraryButtonDidTouch), for: .touchUpInside)
    }
    
    // MARK: - Bind Functions
    
    private func bindToViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Setup Functions
    
    func setupInfo(bookInfo: BookInfo, readonly: Bool? = nil) {
        bindToViewModel()
        viewModel.configure(bookInfo: bookInfo, readonly: readonly)
    }
}

// MARK: - objc Functions

extension CommonCell {
    
    @objc func heartButtonDidTouch(_ sender: UIButton!) {
        guard let bookInfo = bookInfo else { return }
        
        if viewModel.checkHeartList(isbn: bookInfo.isbn) {
            sender.setImage(UIImage(systemName: StringLiteral.heartEmpty), for: .normal)
            viewModel.deleteFromHeartList(with: bookInfo.isbn)
        } else {
            sender.setImage(UIImage(systemName: StringLiteral.heartFill), for: .normal)
            let newHeartContent = HeartContent(isbn: bookInfo.isbn, date: Date())
            viewModel.addToHeartList(newHeartContent, with: bookInfo)
        }
        
        delegate?.heartButtonDidTouch()
    }
    
    
    @objc func addLibraryButtonDidTouch() {
        let addBookViewID = AddBookViewController.name
        guard let addBookView = loadViewController(with: addBookViewID) as? AddBookViewController,
              let bookInfo = bookInfo
        else { return }
        
        let addBookViewModel = AddBookViewModel(bookInfo: bookInfo)
        addBookView.viewModel = addBookViewModel
        delegate?.addBookButtonDidTouched(destinationView: addBookView)
    }
}

// MARK: - CommonCellViewModelDelegate

extension CommonCell: CommonCellViewModelDelegate {
    func bookInfoDidChange() {
        configure()
    }
    
    func commonCellModeDidChange() {
        addLibraryBtn.isHidden = viewModel.readonly
        if !viewModel.readonly { configureAddButtonAction() }
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
