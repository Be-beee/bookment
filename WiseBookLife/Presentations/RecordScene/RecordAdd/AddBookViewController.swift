//
//  AddRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/25.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {
    
    var selectedBookInfo = BookInfo()
    var newRecordContent = RecordContent()
    
    var placeholderText = "기록을 작성해보세요! (선택)"
    
    @IBOutlet var recordContents: UITextView!
    @IBOutlet var selectedBookView: SelectView!
    @IBOutlet weak var readDatePicker: UIDatePicker!
    
    @IBOutlet weak var recordContentsBottom: NSLayoutConstraint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTextView()
        presentSelectView()
        recordContents.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func presentSelectView() {
        selectedBookView.configure(selectedBookInfo)
    }
    
    func settingTextView() {
        recordContents.layer.borderWidth = 0.3
        recordContents.layer.borderColor = UIColor.primary?.cgColor
        recordContents.backgroundColor = .systemBackground
        recordContents.text = placeholderText
        recordContents.textColor = .systemGray
    }
    
    
    // MARK:- Action Methods
    @IBAction func saveRecords(_ sender: UIButton) {
        newRecordContent.isbn = selectedBookInfo.isbn
        newRecordContent.date = readDatePicker.date
        if !recordContents.text.isEmpty, recordContents.textColor == .label {
            newRecordContent.text = recordContents.text
        }
        self.performSegue(withIdentifier: "toRecordView", sender: self)
    }
    @IBAction func backToRecordsView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddBookViewController {
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            recordContentsBottom.constant = 20 + keyboardHeight
        }
    }
    @objc func keyboardWillHide(_ noti: NSNotification) {
        recordContentsBottom.constant = 20
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
