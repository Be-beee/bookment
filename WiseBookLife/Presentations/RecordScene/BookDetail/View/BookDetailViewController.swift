//
//  BookDetailViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit
import SafariServices

final class BookDetailViewController: UIViewController {

    // MARK: - UI Properties
    
    @IBOutlet weak var selectedBookView: SelectView!
    @IBOutlet weak var bookIntroduction: UILabel!
    @IBOutlet var heartBtn: UIButton!
    
    // MARK: - Properties
    
    var viewModel = BookDetailViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHeartButton()
        configureSelectedBookView()
        configureBookIntroduction()
        bindToViewModel()
    }
    
    private func bindToViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Configure Functions
    
    private func configureHeartButton() {
        let heartType = viewModel.isHeartBtnSelected ? StringLiteral.heartFill : StringLiteral.heartEmpty
        heartBtn.setImage(UIImage(systemName: heartType), for: .normal)
    }
    
    private func configureSelectedBookView() {
        selectedBookView.configure(viewModel.bookData)
    }
    
    private func configureBookIntroduction() {
        bookIntroduction.text = viewModel.bookData.description
    }
    
    // MARK: - IBAction Functions

    @IBAction func addDeleteHeart(_ sender: UIButton) {
        if viewModel.isHeartBtnSelected {
            viewModel.deleteFromHeartList()
        } else {
            viewModel.addToHeartList()
        }
    }
    
    /// 이전 뷰로 돌아간다.
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 나의 노트 추가 화면을 띄운다.
    @IBAction func addToMyLibrary(_ sender: UIButton) {
        let addBookViewID = AddBookViewController.name
        guard let addVC = loadViewController(with: addBookViewID) as? AddBookViewController
        else { return }
        
        addVC.selectedBookInfo = viewModel.bookData
        self.present(addVC, animated: true, completion: nil)
    }
    
    /// 책 소개 상세 화면을 띄운다.
    @IBAction func showDetailWebSite(_ sender: UIButton) {
        guard let detailURL = URL(string: viewModel.bookData.link) else { return }
        let detailSafariVC = SFSafariViewController(url: detailURL)

        self.present(detailSafariVC, animated: true, completion: nil)
    }
}

extension BookDetailViewController: BookDetailViewModelDelegate {
    func heartButtonStatusChanged() {
        configureHeartButton()
    }
}


// MARK: - Namespaces

extension BookDetailViewController {
    enum StringLiteral {
        static let heartFill = "heart.fill"
        static let heartEmpty = "heart"
    }
}
