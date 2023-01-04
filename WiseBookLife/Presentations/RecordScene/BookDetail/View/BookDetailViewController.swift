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
        bookIntroduction.text = viewModel.bookData.descriptionText
    }
    
    // MARK: - IBAction Functions

    @IBAction func addDeleteHeart(_ sender: UIButton) {
        if viewModel.isHeartBtnSelected {
            print("executed:: heart will delete")
            let willDeleteData = viewModel.bookData
            guard let foundHeartContent = DatabaseManager.shared.findHeartContent(willDeleteData.isbn)
            else { return }
            DatabaseManager.shared.deleteHeartContentToDB(foundHeartContent, willDeleteData.isbn)
            heartBtn.setImage(UIImage(systemName: StringLiteral.heartEmpty), for: .normal)
        } else {
            print("executed:: heart will add")
            
            // FIXME: 버그 수정 필요
            let dbFormData = viewModel.bookData
            let newHeartContent = HeartContent(isbn: viewModel.bookData.isbn, date: Date())
            DatabaseManager.shared.addHeartContentToDB(newHeartContent, dbFormData)
            heartBtn.setImage(UIImage(systemName: StringLiteral.heartFill), for: .normal)
        }
        viewModel.isHeartBtnSelected.toggle()
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


// MARK: - Namespaces

extension BookDetailViewController {
    enum StringLiteral {
        static let heartFill = "heart.fill"
        static let heartEmpty = "heart"
    }
}
