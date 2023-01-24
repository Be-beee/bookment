//
//  AddRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/03/11.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

final class AddRecordViewController: UIViewController {

    // MARK: - UI Properties
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var recordInputView: UITextView!
    @IBOutlet weak var recordDatePicker: UIDatePicker!
    
    // MARK: - Properties
    
    var viewModel: AddRecordViewModel?
    
    var newRecordContent = RecordContent()
    
    // MARK: - Life Cycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureTextViewDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    // MARK: - Configure Functions
    
    private func configureTextView() {
        recordInputView.layer.borderWidth = Metric.textViewBorderWidth
        recordInputView.layer.borderColor = UIColor.primary?.cgColor
        recordInputView.backgroundColor = .systemBackground
        recordInputView.text = StringLiteral.placeholderText
        recordInputView.textColor = .systemGray
    }
    
    private func configureTextViewDelegate() {
        recordInputView.delegate = self
    }
    
    // MARK: - Notification Center Functions
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBAction Functions
    
    @IBAction func dismissThisView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRecord(_ sender: UIButton) {
        // TODO: ViewModel로 옮기고 presentAlert 부분은 delegate로 전달
        self.newRecordContent.date = recordDatePicker.date
        self.newRecordContent.text = recordInputView.text
        if !newRecordContent.text.isEmpty, recordInputView.textColor == .label {
            self.performSegue(withIdentifier: "toDetailViewFromAddView", sender: self)
        } else {
            presentNoticeAlert(with: StringLiteral.noticeMessage)
        }
    }
}

// MARK: - Keyboard

extension AddRecordViewController {
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            textViewBottomConstraint.constant = Metric.bottomSpacing + keyboardHeight
        }
    }
    @objc func keyboardWillHide(_ noti: NSNotification) {
        textViewBottomConstraint.constant = Metric.bottomSpacing
    }
}

// MARK: - UITextViewDelegate

extension AddRecordViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == StringLiteral.placeholderText {
            textView.text = StringLiteral.emptyText
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.textColor = .label
        if textView.text == StringLiteral.placeholderText {
            textView.text = StringLiteral.emptyText
        }
        return true
    }
}

// MARK: - Namespaces

extension AddRecordViewController {
    enum Metric {
        static let textViewBorderWidth: CGFloat = 0.3
        static let bottomSpacing: CGFloat = 20
    }
    
    enum StringLiteral {
        static let placeholderText = "기록을 작성해보세요!"
        static let emptyText = ""
        
        static let noticeMessage = "내용을 입력해주세요!"
    }
}
