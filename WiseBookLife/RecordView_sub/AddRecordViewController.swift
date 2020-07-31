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
    var searchedData: SeojiData = SeojiData() // 불필요한 변수
    
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
        recordModel.date = today
        
    }
    
    @IBAction func unwindSearchView(sender: UIStoryboardSegue) {
        searchBtn.isHidden = true
        
        guard let searchresultVC = sender.source as? RecBookSearchViewController else {
            return
        }
        self.searchedData = searchresultVC.selected
        recordModel.bookData = searchresultVC.selected
//        print(searchedData)
        selectedBookView.bookCoverView.image = urlToImage(from: searchresultVC.selected.TITLE_URL)
        selectedBookView.bookTitle.text = searchresultVC.selected.TITLE
        selectedBookView.bookAuthor.text =  searchresultVC.selected.AUTHOR
        selectedBookView.bookPublisher.text = searchresultVC.selected.PUBLISHER
        selectedBookView.bookDate.text = searchresultVC.selected.PUBLISH_PREDATE
        selectedBookView.bookISBN.text = searchresultVC.selected.EA_ISBN
        
        // 선택된 책 정보가 표시되지 않음
    }
    
    @IBAction func searchBook(_ sender: UIButton) {
        let recBookSearchVC = UIStoryboard(name: "RecBookSearchVC", bundle: nil).instantiateViewController(withIdentifier: "recBookSearchVC") as! RecBookSearchViewController
        
        self.present(recBookSearchVC, animated: true, completion: nil)
    }
    
    
    @IBAction func saveRecords(_ sender: UIButton) {
        
        if let title = recordTitle.text, title != "" {
            recordModel.recordTitle = title
            recordModel.recordContents = recordContents.text
            
            print(recordModel.bookData)
            if !recordModel.bookData.EA_ISBN.isEmpty {
//                recordModel.bookData = searchedData
                // book data 불러오기
                self.performSegue(withIdentifier: "toRecordView", sender: self)
                // perform segue
            } else {
                let bookAlert = UIAlertController(title: "에러", message: "기록을 작성할 책을 선택해주세요!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)

                bookAlert.addAction(ok)
                self.present(bookAlert, animated: true, completion: nil)
            } // 이 주석 나중에 살리고 밑에거 지우기
//            recordModel.bookData = searchedData
//            self.performSegue(withIdentifier: "toRecordView", sender: self)
            
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
