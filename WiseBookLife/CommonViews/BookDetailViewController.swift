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

    var bookData = BookItem()
    var isHeartBtnSelected = false
    
    @IBOutlet var bookCover: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var publishDateLabel: UILabel!
    @IBOutlet var publisherLabel: UILabel!
    @IBOutlet var prepriceLabel: UILabel!
    
    @IBOutlet weak var bookIntroduction: UILabel!
    
    @IBOutlet var heartBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHeartBtnSelected {
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        bookCover.image = urlToImage(from: bookData.image)
        titleLabel.text = bookData.title
        authorLabel.text = bookData.author
        publishDateLabel.text = "출판일: " + bookData.pubdate
        publisherLabel.text = "출판사: " + bookData.publisher
        prepriceLabel.text = "가격: " + bookData.price
        
        bookIntroduction.text = bookData.description
    }

    @IBAction func addDeleteHeart(_ sender: UIButton) {
        if isHeartBtnSelected {
            CommonData.shared.heartDic.removeValue(forKey: bookData.isbn)
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            CommonData.shared.heartDic.updateValue(bookData, forKey: bookData.isbn)
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        isHeartBtnSelected.toggle()
    }
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToMyLibrary(_ sender: UIButton) {
        guard let addVC = UIStoryboard(name: "AddBookViewController", bundle: nil).instantiateViewController(withIdentifier: "AddBookViewController") as? AddBookViewController else { return }
        addVC.selectedBookItem = BookInfo(title: self.bookData.title, link: self.bookData.link, image: self.bookData.image, author: self.bookData.author, price: self.bookData.price, publisher: self.bookData.publisher, isbn: self.bookData.isbn, descriptionBook: self.bookData.description, pubdate: self.bookData.pubdate)
        self.present(addVC, animated: true, completion: nil)
    }
    
    @IBAction func showDetailWebSite(_ sender: UIButton) {
        guard let detailURL = URL(string: bookData.link) else { return }
        let detailSafariVC = SFSafariViewController(url: detailURL)

        self.present(detailSafariVC, animated: true, completion: nil)
    }
}
