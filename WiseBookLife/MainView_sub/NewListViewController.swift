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
        
        searchTool.callAPI(page_no: "1", page_size: "1000", additional_param: param) {
            for item in self.searchTool.results {
                self.newbooksList.append(item)
            }
            self.newbooksView.reloadData()
        }
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
}
