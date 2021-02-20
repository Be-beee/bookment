//
//  AddRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/25.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {

    var recordModel = Record()
    
    @IBOutlet var todayDate: UILabel!
    @IBOutlet var recordTitle: UITextField!
    @IBOutlet var recordContents: UITextView!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var selectedBookView: SelectView!
    
    var editmode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        let today = df.string(from: Date())
        
        
        switch editmode {
        case true:
            searchBtn.isHidden = true
            presentSelectView()
            recordTitle.text = recordModel.recTitle
            recordContents.text = recordModel.recordContents
            todayDate.text = recordModel.date.dateToString()
        default:
            todayDate.text = today
//            recordModel.date = today
        }
        
    }
    
    func presentSelectView() {
        selectedBookView.bookCoverView.image = urlToImage(from: recordModel.bookData.image)
        selectedBookView.bookTitle.text = recordModel.bookData.title
        selectedBookView.bookAuthor.text =  recordModel.bookData.author
        selectedBookView.bookPublisher.text = "출판사: " + recordModel.bookData.publisher
        
        selectedBookView.bookDate.text = "출간일: " + recordModel.bookData.pubdate
    }
    
    // MARK:- Unwind Segue
    
    @IBAction func unwindSearchView(sender: UIStoryboardSegue) {
        searchBtn.isHidden = true
        
        guard let searchresultVC = sender.source as? SubSearchViewController else {
            return
        }
        recordModel.bookData = searchresultVC.selected
        presentSelectView()
    }
    
    
    // MARK:- Action Methods
    @IBAction func searchBook(_ sender: UIButton) {
        let recBookSearchVC = UIStoryboard(name: "SubSearchViewController", bundle: nil).instantiateViewController(withIdentifier: "SubSearchViewController") as! SubSearchViewController
        
        self.present(recBookSearchVC, animated: true, completion: nil)
    }
    
    
    @IBAction func saveRecords(_ sender: UIButton) {
        
        if let title = recordTitle.text, title != "" {
            recordModel.recTitle = title
            recordModel.recordContents = recordContents.text
            
            if !recordModel.bookData.isbn.isEmpty || !recordModel.bookData.title.isEmpty {
                self.performSegue(withIdentifier: "toRecordView", sender: self)
                // ISSUE - Unbalanced calls to begin/end appearance transitions
                
            } else {
                let bookAlert = UIAlertController(title: "에러", message: "기록을 작성할 책을 선택해주세요!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)

                bookAlert.addAction(ok)
                self.present(bookAlert, animated: true, completion: nil)
            }
            
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
