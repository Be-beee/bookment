//
//  AddRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/25.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {

    var recordModel = Record()
    
    @IBOutlet var recordContents: UITextView!
    @IBOutlet var selectedBookView: SelectView!
    @IBOutlet weak var readDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTextView()
        presentSelectView()
        
    }
    
    func presentSelectView() {
        selectedBookView.bookCoverView.image = urlToImage(from: recordModel.bookData.image)
        selectedBookView.bookTitle.text = recordModel.bookData.title
        selectedBookView.bookAuthor.text =  recordModel.bookData.author
        selectedBookView.bookPublisher.text = "출판사: " + recordModel.bookData.publisher
        
        selectedBookView.bookDate.text = "출간일: " + recordModel.bookData.pubdate
    }
    
    func settingTextView() {
        recordContents.layer.borderWidth = 0.3
        recordContents.layer.borderColor = Theme.main.mainColor.cgColor
        recordContents.backgroundColor = .systemBackground
    }
    
    
    // MARK:- Action Methods
    @IBAction func saveRecords(_ sender: UIButton) {
        if !recordContents.text.isEmpty {
            recordModel.contents.append(recordContents.text)
        }
        recordModel.date = readDatePicker.date
        self.performSegue(withIdentifier: "toRecordView", sender: self)
    }
    @IBAction func backToRecordsView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
