//
//  AddRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/03/11.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {

    var inputData: (date: Date, text: String) = (Date(), "")
    var placeholderText = "기록을 작성해보세요!"
    
    @IBOutlet weak var recordInputView: UITextView!
    @IBOutlet weak var recordDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        recordInputView.delegate = self
        settingTextView()
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
        self.inputData.date = recordDatePicker.date
        self.inputData.text = recordInputView.text
        if !inputData.text.isEmpty, recordInputView.textColor == .label {
            self.performSegue(withIdentifier: "toDetailViewFromAddView", sender: self)
        } else {
            let alert = UIAlertController(title: "알림", message: "내용을 입력해주세요!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
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
