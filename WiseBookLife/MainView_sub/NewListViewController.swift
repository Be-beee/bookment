//
//  NewListViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class NewListViewController: UIViewController {

    var newbooksList:[SeojiData] = []
    @IBOutlet var newbooksView: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    var searchTool = SearchBook()
    var pageNo = 1
    var pageSize = 20
    
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting navigation bar
        self.navigationItem.title = "오늘의 신간 😎"
        newbooksView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        // calling data
        df.dateFormat = "yyyyMMdd"
        
        let param: [String: String] = [
            "start_publish_date" : df.string(from: Date()),
            "end_publish_date" : df.string(from: Date())
        ]
        
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: param) {
            self.indicator.startAnimating()
            self.newbooksList.append(contentsOf: self.searchTool.results)
            self.newbooksView.reloadData()
            self.indicator.stopAnimating()
        }
        
        // setting table footer
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let footerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        footerBtn.setTitle("결과 더보기", for: .normal)
        footerBtn.addTarget(self, action: #selector(showMoreResult), for: .touchUpInside)
        tableFooter.addSubview(footerBtn)
        
        newbooksView.tableFooterView = tableFooter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pageNo = 1
        self.newbooksView.reloadData()
    }
    
    
    // MARK:- Cell button action
    @objc func onOffHeartBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            heartDic.removeValue(forKey: newbooksList[sender.tag].EA_ISBN)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartDic.updateValue(newbooksList[sender.tag], forKey: newbooksList[sender.tag].EA_ISBN)
        }
        saveData(data: heartDic, at: "heart")
    }
    
    @objc func showMoreResult() {
        let param: [String: String] = [
            "start_publish_date" : df.string(from: Date()),
            "end_publish_date" : df.string(from: Date())
        ]
        pageNo += 1
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: param) {
            self.newbooksList.append(contentsOf: self.searchTool.results)
            self.newbooksView.reloadData()
        }
    }

}


// MARK:- Extensions
extension NewListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension NewListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newbooksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newbooksView.dequeueReusableCell(withIdentifier: "commonCell", for: indexPath) as! CommonCell

        cell.bookCover.image = urlToImage(from: newbooksList[indexPath.row].TITLE_URL)
        
        cell.titleLabel.text = newbooksList[indexPath.row].TITLE
        cell.authorLabel.text = newbooksList[indexPath.row].AUTHOR
        
        
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(onOffHeartBtn), for: .touchUpInside)
        
        if heartDic[newbooksList[indexPath.row].EA_ISBN] != nil {
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "BookDetailVC", bundle: nil).instantiateViewController(withIdentifier: "bookDetailVC") as! BookDetailViewController
        detailVC.bookData = newbooksList[indexPath.row]
        detailVC.modalPresentationStyle = .fullScreen
        if heartDic[newbooksList[indexPath.row].EA_ISBN] != nil {
            detailVC.isHeartBtnSelected = true
        } else {
            detailVC.isHeartBtnSelected = false
        }
        
        present(detailVC, animated: true, completion: nil)
    }
}
