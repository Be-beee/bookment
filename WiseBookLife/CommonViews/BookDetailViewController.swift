//
//  BookDetailViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit
import SafariServices

class BookDetailViewController: UIViewController {

    var bookData = BookInfo()
    var isHeartBtnSelected = false
    
    @IBOutlet weak var selectedBookView: SelectView!
    @IBOutlet weak var bookIntroduction: UILabel!
    @IBOutlet var heartBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHeartBtnSelected {
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        configureSelectedBookView()
        bookIntroduction.text = bookData.descriptionText
    }
    
    func configureSelectedBookView() {
        selectedBookView.bookCoverView.image = urlToImage(from: bookData.image)
        selectedBookView.bookTitle.text = bookData.title
        selectedBookView.bookAuthor.text = bookData.author
        selectedBookView.bookPublisher.text = "출판사: " + bookData.publisher
        selectedBookView.bookDate.text = "출판일: " + bookData.pubdate
//        prepriceLabel.text = "가격: " + bookData.price
    }

    @IBAction func addDeleteHeart(_ sender: UIButton) {
        if isHeartBtnSelected {
            guard let foundHeartContent = DatabaseManager.shared.findHeartContent(bookData.isbn) else { return }
            DatabaseManager.shared.deleteHeartContentToDB(foundHeartContent, bookData)
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            let newHeartContent = HeartContent(isbn: bookData.isbn, date: Date())
            DatabaseManager.shared.addHeartContentToDB(newHeartContent, bookData)
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        isHeartBtnSelected.toggle()
    }
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToMyLibrary(_ sender: UIButton) {
        guard let addVC = UIStoryboard(name: "AddBookViewController", bundle: nil).instantiateViewController(withIdentifier: "AddBookViewController") as? AddBookViewController else { return }
        addVC.selectedBookInfo = self.bookData
        self.present(addVC, animated: true, completion: nil)
    }
    
    @IBAction func showDetailWebSite(_ sender: UIButton) {
        guard let detailURL = URL(string: bookData.link) else { return }
        let detailSafariVC = SFSafariViewController(url: detailURL)

        self.present(detailSafariVC, animated: true, completion: nil)
    }
}
