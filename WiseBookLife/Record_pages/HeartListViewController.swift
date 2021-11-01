//
//  HeartListViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit


class HeartListViewController: UIViewController {

    @IBOutlet var heartView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var heartList: [HeartContent] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        heartView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        settingEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    func settingEmptyView() {
        emptyView.backgroundColor = .systemBackground
        emptyView.alpha = 1
        reloadEmptyView()
    }
    
    func reloadEmptyView() {
        if heartList.count > 0 {
            emptyView.isHidden = true
        } else {
            emptyView.isHidden = false
        }
    }

    
    // MARK:- cell button action methods
    
    @objc func onOffHeartBtn(_ sender: UIButton!) {
//        sender.isSelected = !sender.isSelected
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            guard let willDeleteHeartContent = DatabaseManager.shared.findHeartContent(heartList[sender.tag].isbn) else { return }
            let withBookInfo = DatabaseManager.shared.findBookInfo(isbn: heartList[sender.tag].isbn)
            DatabaseManager.shared.deleteHeartContentToDB(willDeleteHeartContent, withBookInfo)
            refreshData()
        }
    }
    
    func refreshData() {
        let loaded = DatabaseManager.shared.loadHeartContent()
        heartList = Array(loaded)
        // title sorting 생략됨
        heartView.reloadData()
        reloadEmptyView()
    }
    
}


// MARK:- Extensions
extension HeartListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = heartView.dequeueReusableCell(withIdentifier: "commonCell", for: indexPath) as! CommonCell
        
        let loadedBookInfo = DatabaseManager.shared.findBookInfo(isbn: heartList[indexPath.row].isbn)!
        cell.bookCover.image = urlToImage(from: loadedBookInfo.image)
        
        if loadedBookInfo.title == "" {
            cell.titleLabel.text = "[NO TITLE]"
            cell.titleLabel.textColor = .lightGray
        } else {
            cell.titleLabel.text = loadedBookInfo.title
        }
        
        cell.authorLabel.text = loadedBookInfo.author
        
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(onOffHeartBtn), for: .touchUpInside)
        cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        cell.addLibraryBtn.tag = indexPath.row
        cell.addLibraryBtn.addTarget(self, action: #selector(addToLibrary), for: .touchUpInside)

        return cell
    }
    
    @objc func addToLibrary(_ sender: UIButton!) {
        let addLibraryVC = UIStoryboard(name: "AddBookViewController", bundle: nil).instantiateViewController(withIdentifier: "AddBookViewController") as! AddBookViewController
        let bookInfo = DatabaseManager.shared.findBookInfo(isbn: self.heartList[sender.tag].isbn)!
        addLibraryVC.selectedBookItem = bookInfo
        
        self.present(addLibraryVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "BookDetailVC", bundle: nil).instantiateViewController(withIdentifier: "bookDetailVC") as! BookDetailViewController
        guard let fromHeartListISBN = DatabaseManager.shared.findBookInfo(isbn: heartList[indexPath.row].isbn) else { return }
        detailVC.bookData = fromHeartListISBN
        detailVC.modalPresentationStyle = .fullScreen
        if let _ = DatabaseManager.shared.findHeartContent(heartList[indexPath.row].isbn) {
            detailVC.isHeartBtnSelected = true
        } else {
            detailVC.isHeartBtnSelected = false
        }
        
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    
}

