//
//  BookDetailViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    var bookData = SeojiData()
    var isHeartBtnSelected = false
    
    @IBOutlet var bookCover: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var publishDateLabel: UILabel!
    @IBOutlet var publisherLabel: UILabel!
    @IBOutlet var prepriceLabel: UILabel!
    @IBOutlet var isbnLabel: UILabel!
    @IBOutlet var ebookYNLabel: UILabel!
    
    @IBOutlet var bookIntroduction: UITextView!
    @IBOutlet var bookSummary: UITextView!
    @IBOutlet var bookTB: UITextView!
    
    @IBOutlet var heartBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHeartBtnSelected {
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        bookCover.image = urlToImage(from: bookData.TITLE_URL)
        titleLabel.text = bookData.TITLE
        authorLabel.text = bookData.AUTHOR
        publishDateLabel.text = bookData.PUBLISH_PREDATE
        publisherLabel.text = bookData.PUBLISHER
        prepriceLabel.text = bookData.PRE_PRICE
        isbnLabel.text = bookData.EA_ISBN
        ebookYNLabel.text = bookData.EBOOK_YN
        
        if bookData.BOOK_INTRODUCTION_URL.isEmpty {
            bookIntroduction.text = "등록된 책소개가 없습니다."
        } else {
            bookIntroduction.text = bookData.BOOK_INTRODUCTION_URL
        }
        
        if bookData.BOOK_SUMMARY_URL.isEmpty {
            bookSummary.text = "등록된 책요약이 없습니다."
        } else {
            bookSummary.text = bookData.BOOK_SUMMARY_URL
        }
        
        if bookData.BOOK_TB_CNT_URL.isEmpty {
            bookTB.text = "등록된 목차가 없습니다."
        } else {
            bookTB.text = bookData.BOOK_TB_CNT_URL
        }
        
        
    }

    @IBAction func addDeleteHeart(_ sender: UIButton) {
        if isHeartBtnSelected {
            heartDic.removeValue(forKey: bookData.EA_ISBN)
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            heartDic.updateValue(bookData, forKey: bookData.EA_ISBN)
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        saveData(data: heartDic, at: "heart")
        isHeartBtnSelected.toggle()
    }
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
