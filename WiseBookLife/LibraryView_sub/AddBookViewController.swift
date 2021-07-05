//
//  AddRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/25.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {

    var recordDate = Date()
    var selectedBookItem = BookItem()
    var contents = ""
    
    var placeholderText = "기록을 작성해보세요! (선택)"
    
    @IBOutlet var recordContents: UITextView!
    @IBOutlet var selectedBookView: SelectView!
    @IBOutlet weak var readDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTextView()
        presentSelectView()
        recordContents.delegate = self
        
    }
    
    func presentSelectView() {
        selectedBookView.bookCoverView.image = urlToImage(from: selectedBookItem.image)
        selectedBookView.bookTitle.text = selectedBookItem.title
        selectedBookView.bookAuthor.text =  selectedBookItem.author
        selectedBookView.bookPublisher.text = "출판사: " + selectedBookItem.publisher
        
        selectedBookView.bookDate.text = "출간일: " + selectedBookItem.pubdate
    }
    
    func settingTextView() {
        recordContents.layer.borderWidth = 0.3
        recordContents.layer.borderColor = Theme.main.mainColor.cgColor
        recordContents.backgroundColor = .systemBackground
        recordContents.text = placeholderText
        recordContents.textColor = .systemGray
    }
    
    
    // MARK:- Action Methods
    @IBAction func saveRecords(_ sender: UIButton) {
        recordDate = readDatePicker.date
        if !recordContents.text.isEmpty, recordContents.textColor == .label {
            contents = recordContents.text
        }
        self.performSegue(withIdentifier: "toRecordView", sender: self)
    }
    @IBAction func backToRecordsView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddBookViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholderText {
            textView.text = ""
            
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.textColor = .label
        if textView.text == self.placeholderText {
            textView.text = ""
        }
        return true
    }
}
