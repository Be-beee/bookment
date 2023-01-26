//
//  AddNewBookRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/25.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

final class AddNewBookRecordViewController: UIViewController {
    
    // MARK: - UI Properties
    
    @IBOutlet var recordContents: UITextView!
    @IBOutlet var selectedBookView: SelectView!
    @IBOutlet weak var readDatePicker: UIDatePicker!
    
    @IBOutlet weak var recordContentsBottom: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var viewModel: AddNewBookRecordViewModel?
    
    // MARK: - Life Cycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureSelectView()
        configureTextViewDelegate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    // MARK: - Configure Functions
    
    private func configureTextView() {
        recordContents.layer.borderWidth = Metric.textViewBorderWidth
        recordContents.layer.borderColor = UIColor.primary?.cgColor
        
        recordContents.backgroundColor = .systemBackground
        
        recordContents.text = StringLiteral.placeholderText
        recordContents.textColor = .systemGray
    }
    
    private func configureSelectView() {
        guard let viewModel else { return }
        selectedBookView.configure(viewModel.selectedBookInfo)
    }
    
    private func configureTextViewDelegate() {
        recordContents.delegate = self
    }
    
    // MARK: - Action Methods
    
    @IBAction func saveRecords(_ sender: UIButton) {
        guard let viewModel else { return }
        
        let recordText = (!recordContents.text.isEmpty && recordContents.textColor == .label) ?
                        recordContents.text : nil
        viewModel.saveRecord(date: readDatePicker.date, text: recordText)
        // TODO: 기존에 나의 노트에 책 정보가 등록 되어 있다면 추가한 노트가 갱신되어 표시되지만, 아예 새로운 책 정보에 대한 노트를 등록하면 나의 노트 화면에 바로 나타나지 않음(기록 정보 저장은 잘 됨)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func backToRecordsView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Keyboard

extension AddNewBookRecordViewController {
    
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            recordContentsBottom.constant = Metric.bottomSpacing + keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification) {
        recordContentsBottom.constant = Metric.bottomSpacing
    }
}

// MARK: - UITextViewDelegate

extension AddNewBookRecordViewController: UITextViewDelegate {
    
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

extension AddNewBookRecordViewController {
    enum Metric {
        static let bottomSpacing: CGFloat = 20
        static let textViewBorderWidth: CGFloat = 0.3
    }
    
    enum StringLiteral {
        static let placeholderText = "기록을 작성해보세요! (선택)"
        static let emptyText = ""
    }
}
