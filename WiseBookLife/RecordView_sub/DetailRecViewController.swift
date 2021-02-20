//
//  DetailRecViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/16.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class DetailRecViewController: UIViewController {

    var selectedItem = Record()
    @IBOutlet var recTitle: UILabel!
    @IBOutlet var recContents: UITextView!
    @IBOutlet var bookInfoView: SelectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedItem.date.dateToString()
        self.navigationItem.largeTitleDisplayMode = .never
        let editButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editThisRecord))
        self.navigationItem.rightBarButtonItem = editButton
        self.recContents.isEditable = false
        presentData()
    }
    
    func presentData() {
        recTitle.text = selectedItem.recTitle
        recContents.text = selectedItem.recordContents
        
        // book data 가져오기
        bookInfoView.bookCoverView.image = urlToImage(from: selectedItem.bookData.image)
        bookInfoView.bookTitle.text = selectedItem.bookData.title
        bookInfoView.bookAuthor.text = selectedItem.bookData.author
        bookInfoView.bookDate.text = "출간일: " + selectedItem.bookData.pubdate
        bookInfoView.bookPublisher.text = "출판사: " + selectedItem.bookData.publisher
    }
    
    @objc func editThisRecord() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "수정", style: .default) { (action) in
            let editVC = UIStoryboard(name: "AddRecordVC", bundle: nil).instantiateViewController(withIdentifier: "addRecordVC") as! AddRecordViewController

            editVC.modalPresentationStyle = .fullScreen
            editVC.recordModel = self.selectedItem
            editVC.editmode = true
            self.present(editVC, animated: true, completion: nil)
        }
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            let deleteAlert = UIAlertController(title: "경고", message: "정말 삭제하시겠습니까?\n삭제된 기록은 복구할 수 없습니다.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "삭제", style: .destructive) { (action) in
                self.performSegue(withIdentifier: "toRecordListByDeleting", sender: self)
                return
            }
            deleteAlert.addAction(cancel)
            deleteAlert.addAction(ok)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}
