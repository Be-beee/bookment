//
//  NewListViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class NewListViewController: UIViewController {

    var newbooksList:[(image: UIImage, contents: SeojiData)] = []
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
        
        // setting table footer
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        settingFooterForTableView(for: tableFooter, action: #selector(showMoreResult))
        
        newbooksView.tableFooterView = tableFooter
        self.newbooksView.tableFooterView?.isHidden = true
        
        // calling data
        df.dateFormat = "yyyyMMdd"
        
        let param: [String: String] = [
            "start_publish_date" : df.string(from: Date()),
            "end_publish_date" : df.string(from: Date())
        ]
        
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: param, target: self) {
            self.indicator.startAnimating()
            for item in self.searchTool.results {
                let image = item.TITLE_URL.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.TITLE_URL)
                self.newbooksList.append((image: image!, contents: item))
            }
            self.newbooksView.reloadData()
            self.indicator.stopAnimating()
            self.newbooksView.tableFooterView?.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pageNo = 1
        self.newbooksView.reloadData()
    }
    
    
    // MARK:- Cell button action
    @objc func onOffHeartBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            heartDic.removeValue(forKey: newbooksList[sender.tag].contents.EA_ISBN)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartDic.updateValue(newbooksList[sender.tag].contents, forKey: newbooksList[sender.tag].contents.EA_ISBN)
        }
        saveData(data: heartDic, at: "heart")
    }
    
    @objc func showMoreResult() {
        let param: [String: String] = [
            "start_publish_date" : df.string(from: Date()),
            "end_publish_date" : df.string(from: Date())
        ]
        pageNo += 1
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: param, target: self) {
            self.indicator.startAnimating()
            if self.searchTool.results.isEmpty {
                let alert = UIAlertController(title: "알림", message: "마지막 검색 결과입니다!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                for item in self.searchTool.results {
                    let image = item.TITLE_URL.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.TITLE_URL)
                    self.newbooksList.append((image: image!, contents: item))
                }
                self.newbooksView.reloadData()
            }
            self.indicator.stopAnimating()
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

        cell.bookCover.image = newbooksList[indexPath.row].image
        
        cell.titleLabel.text = newbooksList[indexPath.row].contents.TITLE
        cell.authorLabel.text = newbooksList[indexPath.row].contents.AUTHOR
        
        
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(onOffHeartBtn), for: .touchUpInside)
        
        if heartDic[newbooksList[indexPath.row].contents.EA_ISBN] != nil {
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "BookDetailVC", bundle: nil).instantiateViewController(withIdentifier: "bookDetailVC") as! BookDetailViewController
        detailVC.bookData = newbooksList[indexPath.row].contents
        detailVC.modalPresentationStyle = .fullScreen
        if heartDic[newbooksList[indexPath.row].contents.EA_ISBN] != nil {
            detailVC.isHeartBtnSelected = true
        } else {
            detailVC.isHeartBtnSelected = false
        }
        
        present(detailVC, animated: true, completion: nil)
    }
}
