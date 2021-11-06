//
//  AddRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/03/11.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit
import NotificationCenter

class AddRecordViewController: UIViewController {

    var newRecordContent = RecordContent()
    var placeholderText = "기록을 작성해보세요!"
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var recordInputView: UITextView!
    @IBOutlet weak var recordDatePicker: UIDatePicker!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordInputView.delegate = self
        settingTextView()
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
    
    func settingTextView() {
        recordInputView.layer.borderWidth = 0.3
        recordInputView.layer.borderColor = Theme.main.mainColor.cgColor
        recordInputView.backgroundColor = .systemBackground
        recordInputView.text = self.placeholderText
        recordInputView.textColor = .systemGray
    }
    
    @IBAction func dismissThisView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRecord(_ sender: UIButton) {
        self.newRecordContent.date = recordDatePicker.date
        self.newRecordContent.text = recordInputView.text
        if !newRecordContent.text.isEmpty, recordInputView.textColor == .label {
            self.performSegue(withIdentifier: "toDetailViewFromAddView", sender: self)
        } else {
            let alert = UIAlertController(title: "알림", message: "내용을 입력해주세요!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension AddRecordViewController {
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            textViewBottomConstraint.constant = 20 + keyboardHeight
        }
    }
    @objc func keyboardWillHide(_ noti: NSNotification) {
        textViewBottomConstraint.constant = 20
    }
}

extension AddRecordViewController: UITextViewDelegate {
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
