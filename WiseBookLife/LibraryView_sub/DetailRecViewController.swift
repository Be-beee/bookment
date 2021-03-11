//
//  DetailRecViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/16.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class DetailRecViewController: UIViewController {

    var selectedIndex = -1
    lazy var selectedItem = CommonData.shared.records[selectedIndex]
    @IBOutlet var bookInfoView: SelectView!
    @IBOutlet weak var bookRecordsView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedItem.date.dateToString()
        self.navigationItem.largeTitleDisplayMode = .never
        let deleteButton = UIBarButtonItem(title: "삭제", style: .done, target: self, action: #selector(deleteThisBookData))
        self.navigationItem.rightBarButtonItem = deleteButton
        self.navigationController?.navigationBar.tintColor = Theme.main.mainColor
        presentData()
        settingResultFooter()
    }
    
    func presentData() {
        // book data 가져오기
        bookInfoView.bookCoverView.image = urlToImage(from: selectedItem.bookData.image)
        bookInfoView.bookTitle.text = selectedItem.bookData.title
        bookInfoView.bookAuthor.text = selectedItem.bookData.author
        bookInfoView.bookDate.text = "출간일: " + selectedItem.bookData.pubdate
        bookInfoView.bookPublisher.text = "출판사: " + selectedItem.bookData.publisher
    }
    
    func settingResultFooter() {
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        settingFooterForTableView(for: tableFooter, action: #selector(addRecordToBookData), title: nil, image: UIImage(systemName: "plus"), bgColor: Theme.main.mainColor)
        
        bookRecordsView.tableFooterView = tableFooter
    }
    
    @objc func addRecordToBookData() {
        let addRecordVC = UIStoryboard(name: "AddRecordViewController", bundle: nil).instantiateViewController(withIdentifier: "AddRecordViewController") as! AddRecordViewController
        
        self.present(addRecordVC, animated: true, completion: nil)
    }
    
    @objc func deleteThisBookData() {
        let deleteAlert = UIAlertController(title: "경고", message: "정말 삭제하시겠습니까?\n삭제된 책정보와 기록은 복구할 수 없습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            self.performSegue(withIdentifier: "toRecordListByDeleting", sender: self)
            return
        }
        deleteAlert.addAction(cancel)
        deleteAlert.addAction(ok)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    // MARK: - unwind segue
    
    @IBAction func saveRecordsToLibrary(sender: UIStoryboardSegue) {
        let start = sender.source as! AddRecordViewController
        CommonData.shared.records[selectedIndex].contents.append(start.inputData)
        self.bookRecordsView.reloadData()
    }
}

extension DetailRecViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommonData.shared.records[selectedIndex].contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bookRecordsView.dequeueReusableCell(withIdentifier: "RecordContentCell", for: indexPath) as? RecordContentCell else {
            return UITableViewCell()
        }
        cell.contentLabel.text = CommonData.shared.records[selectedIndex].contents[indexPath.row]
        
        return cell
    }
}

class RecordContentCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
}
