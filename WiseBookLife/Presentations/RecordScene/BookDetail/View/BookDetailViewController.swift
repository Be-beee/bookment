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
    var cacheData = BookInfoResponseDTO()
    var isHeartBtnSelected = false
    
    @IBOutlet weak var selectedBookView: SelectView!
    @IBOutlet weak var bookIntroduction: UILabel!
    @IBOutlet var heartBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = DatabaseManager.shared.findBookInfo(isbn: bookData.isbn) {
            isHeartBtnSelected = true
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            isHeartBtnSelected = false
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        configureSelectedBookView()
        bookIntroduction.text = bookData.descriptionText
        cacheData = bookData.changeToBookItem()
    }
    
    func configureSelectedBookView() {
        selectedBookView.configure(bookData)
    }

    @IBAction func addDeleteHeart(_ sender: UIButton) {
        if isHeartBtnSelected {
            print("executed:: heart will delete")
            guard let foundHeartContent = DatabaseManager.shared.findHeartContent(cacheData.isbn) else { return }
            DatabaseManager.shared.deleteHeartContentToDB(foundHeartContent, cacheData.isbn)
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            print("executed:: heart will add")
            let dbFormData = cacheData.changeToBookInfo()
            let newHeartContent = HeartContent(isbn: cacheData.isbn, date: Date())
            DatabaseManager.shared.addHeartContentToDB(newHeartContent, dbFormData)
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        isHeartBtnSelected.toggle()
//        print(isHeartBtnSelected)
    }
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToMyLibrary(_ sender: UIButton) {
        guard let addVC = UIStoryboard(name: "AddBookViewController", bundle: nil).instantiateViewController(withIdentifier: "AddBookViewController") as? AddBookViewController else { return }
        addVC.selectedBookInfo = self.cacheData.changeToBookInfo()
        self.present(addVC, animated: true, completion: nil)
    }
    
    @IBAction func showDetailWebSite(_ sender: UIButton) {
        guard let detailURL = URL(string: bookData.link) else { return }
        let detailSafariVC = SFSafariViewController(url: detailURL)

        self.present(detailSafariVC, animated: true, completion: nil)
    }
}
