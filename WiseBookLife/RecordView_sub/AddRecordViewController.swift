//
//  AddRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/25.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {

    var recordModel: RecordModel = RecordModel()
    var searchedData: SeojiData = SeojiData()
    
    @IBOutlet var todayDate: UILabel!
    @IBOutlet var recordTitle: UITextField!
    @IBOutlet var recordContents: UITextView!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var selectedBookView: SelectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        let today = df.string(from: Date())
        
        todayDate.text = today
        
    }
    
    @IBAction func unwindSearchView(sender: UIStoryboardSegue) {
        searchBtn.isHidden = true
        
        print(searchedData)
        selectedBookView.bookCoverView.image = urlToImage(from: searchedData.TITLE_URL)
        selectedBookView.bookTitle.text = searchedData.TITLE
        selectedBookView.bookAuthor.text =  searchedData.AUTHOR
        selectedBookView.bookPublisher.text = searchedData.PUBLISHER
        selectedBookView.bookDate.text = searchedData.PUBLISH_PREDATE
        selectedBookView.bookISBN.text = searchedData.EA_ISBN
        
    }
    
    @IBAction func searchBook(_ sender: UIButton) {
        let recBookSearchVC = UIStoryboard(name: "RecBookSearchVC", bundle: nil).instantiateViewController(withIdentifier: "recBookSearchVC") as! RecBookSearchViewController
        
        self.present(recBookSearchVC, animated: true, completion: nil)
    }
    
    
    @IBAction func saveRecords(_ sender: UIButton) {
        
        if let title = recordTitle.text, title != "" {
            recordModel.recordTitle = title
            recordModel.recordContents = recordContents.text
            
//            if recordModel.bookData.EA_ISBN != "" {
//                recordModel.bookData = searchedData
//                // book data 불러오기
//                self.performSegue(withIdentifier: "toRecordView", sender: self)
//                // perform segue
//            } else {
//                let bookAlert = UIAlertController(title: "에러", message: "기록을 작성할 책을 선택해주세요!", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
//
//                bookAlert.addAction(ok)
//                self.present(bookAlert, animated: true, completion: nil)
//            } // 이 주석 나중에 살리고 밑에거 지우기
            recordModel.bookData = searchedData
            self.performSegue(withIdentifier: "toRecordView", sender: self)
            
        } else {
            let titleAlert = UIAlertController(title: "앗!", message: "타이틀을 입력해주세요!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            titleAlert.addAction(ok)
            self.present(titleAlert, animated: true, completion: nil)
        }
        
    }
    @IBAction func backToRecordsView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
