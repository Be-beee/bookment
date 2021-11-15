//
//  DetailRecViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/16.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class DetailRecViewController: UIViewController {

    var selectedISBN = ""
    var cachedBookInfo = BookInfo()
    var selectedBookRecords: [RecordContent] = []
    @IBOutlet var bookInfoView: SelectView!
    @IBOutlet weak var bookRecordsView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        let deleteButton = UIBarButtonItem(title: "삭제", style: .done, target: self, action: #selector(deleteThisBookData))
        self.navigationItem.rightBarButtonItem = deleteButton
        self.navigationController?.navigationBar.tintColor = Theme.main.mainColor
        presentData()
        settingResultFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshRecordList()
    }
    
    func presentData() {
        guard let selectedItem = DatabaseManager.shared.findBookInfo(isbn: selectedISBN) else { return }
        bookInfoView.configure(selectedItem)
        
        self.cachedBookInfo = BookInfo(title: selectedItem.title, link: selectedItem.link, image: selectedItem.image, author: selectedItem.author, price: selectedItem.price, publisher: selectedItem.publisher, isbn: selectedItem.isbn, descriptionText: selectedItem.descriptionText, pubdate: selectedItem.pubdate)
    }
    
    func refreshRecordList() {
        selectedBookRecords = DatabaseManager.shared.sortRecords(isbn: selectedISBN)
        self.bookRecordsView.reloadData()
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
        start.newRecordContent.isbn = selectedISBN
        if let withBookInfo = DatabaseManager.shared.findBookInfo(isbn: selectedISBN) {
            DatabaseManager.shared.addRecordToDB(start.newRecordContent, withBookInfo)
        } else {
            DatabaseManager.shared.addRecordToDB(start.newRecordContent, cachedBookInfo)
        }
        self.bookRecordsView.reloadData()
    }
}

extension DetailRecViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedBookRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bookRecordsView.dequeueReusableCell(withIdentifier: "RecordContentCell", for: indexPath) as? RecordContentCell else {
            return UITableViewCell()
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd."
        
        cell.contentLabel.text = selectedBookRecords[indexPath.row].text
        cell.dateLabel.text = df.string(from: selectedBookRecords[indexPath.row].date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "독서 기록"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let willDelete = selectedBookRecords[indexPath.row]
            let withBookInfo = DatabaseManager.shared.findBookInfo(isbn: selectedISBN)
            DatabaseManager.shared.deleteRecordToDB(willDelete, withBookInfo)
        }
        self.refreshRecordList()
    }
}

class RecordContentCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
