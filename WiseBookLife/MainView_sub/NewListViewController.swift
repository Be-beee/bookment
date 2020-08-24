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
    
    var searchTool = SearchBook()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "오늘의 신간 😎"
        newbooksView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        
        let param: [String: String] = [
            "start_publish_date" : df.string(from: Date()),
            "end_publish_date" : df.string(from: Date())
        ]
        
        searchTool.callAPI(page_no: 1, page_size: 1000, additional_param: param) {
            self.newbooksList = self.searchTool.results
            self.newbooksView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

}


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
