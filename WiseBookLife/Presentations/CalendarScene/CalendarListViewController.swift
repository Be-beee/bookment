//
//  AddBookViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/10.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class CalendarListViewController: UIViewController {

    var currentDate: String = "yyyy-MM-dd" // format
    var booklist: [BookInfo] = []
    @IBOutlet weak var todayBookTableView: UITableView!
    @IBOutlet weak var emptyResultView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBarLine()
        
        refreshBookListView()
        todayBookTableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBookListView()
    }
    
    func refreshBookListView() {
        todayBookTableView.reloadData()
        if booklist.isEmpty {
            self.emptyResultView.isHidden = false
        } else {
            self.emptyResultView.isHidden = true
        }
    }
    
    @IBAction func dismissListView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CalendarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension CalendarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = todayBookTableView.dequeueReusableCell(withIdentifier: "commonCell") as? CommonCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let item = booklist[indexPath.row]
        cell.bookCover.image = ImageDownloader.urlToImage(from: item.image)
        cell.titleLabel.text = item.title
        cell.authorLabel.text = item.author
        
        cell.addLibraryBtn.isHidden = true
        
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(onOffHeartBtn), for: .touchUpInside)
        
        if let _ = DatabaseManager.shared.findHeartContent(booklist[indexPath.row].isbn) {
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        return cell
    }
    
    @objc func onOffHeartBtn(_ sender: UIButton!) {
        let isbnKey = booklist[sender.tag].isbn
        let withBookInfo = DatabaseManager.shared.findBookInfo(isbn: isbnKey)
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            guard let willDeleteHeartContent = DatabaseManager.shared.findHeartContent(isbnKey) else { return }
            DatabaseManager.shared.deleteHeartContentToDB(willDeleteHeartContent, withBookInfo?.isbn)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            let newHeartContent = HeartContent(isbn: isbnKey, date: Date())
            DatabaseManager.shared.addHeartContentToDB(newHeartContent, withBookInfo)
        }
    }
    
    
}
