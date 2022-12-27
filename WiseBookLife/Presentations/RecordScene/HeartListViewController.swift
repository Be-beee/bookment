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
    
    private let cellID = CommonCell.name
    var heartList: [HeartContent] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heartView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
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
        guard let cell = heartView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CommonCell,
              let loadedBookInfo = DatabaseManager.shared.findBookInfo(isbn: heartList[indexPath.row].isbn) else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.bookInfo = loadedBookInfo
        cell.readonly = false

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDetailViewID = BookDetailViewController.name
        guard let detailVC = UIStoryboard(name: bookDetailViewID, bundle: nil).instantiateViewController(withIdentifier: bookDetailViewID) as? BookDetailViewController,
              let fromHeartListISBN = DatabaseManager.shared.findBookInfo(isbn: heartList[indexPath.row].isbn)
        else { return }
        
        detailVC.bookData = fromHeartListISBN
        detailVC.modalPresentationStyle = .fullScreen
        
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
}


// MARK: - CommonCellDelegate

extension HeartListViewController: CommonCellDelegate {
    func heartButtonDidTouch() {
        refreshData()
    }
    
    func addBookButtonDidTouched(destinationView: UIViewController) {
        present(destinationView, animated: true)
    }
}
