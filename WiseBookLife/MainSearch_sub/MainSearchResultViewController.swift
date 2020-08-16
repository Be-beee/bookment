//
//  MainSearchResultViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/09.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class MainSearchResultViewController: UIViewController {

    var resultList: [SeojiData] = []
    @IBOutlet var resultView: UITableView!
    
    var searchTool = SearchBook()
    var searchedWord = "Sample"
    
    var isSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.hidesSearchBarWhenScrolling = false
        resultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.text = searchedWord
        self.navigationItem.searchController = searchController
        
        let titleParam = [
            "title" : searchedWord
        ]
        let authorParam = [
            "author" : searchedWord
        ]
        searchTool.callAPI(page_no: 1, page_size: 50, additional_param: titleParam) {
            self.resultList.append(contentsOf: self.searchTool.results)
            self.resultView.reloadData()
        }
        searchTool.callAPI(page_no: 1, page_size: 50, additional_param: authorParam) {
            self.resultList.append(contentsOf: self.searchTool.results)
            self.resultView.reloadData()
        }
        
    }
    
    @objc func onOffHeartBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            heartDic.removeValue(forKey: resultList[sender.tag].EA_ISBN)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartDic.updateValue(resultList[sender.tag], forKey: resultList[sender.tag].EA_ISBN)
        }
        saveHeartList()
    }
    
    @objc func onOffBellBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "bell.fill") {
            sender.setImage(UIImage(systemName: "bell"), for: .normal)
            bellDic.removeValue(forKey: resultList[sender.tag].EA_ISBN)
        } else {
            sender.setImage(UIImage(systemName: "bell.fill"), for: .normal)
            bellDic.updateValue(resultList[sender.tag].TITLE, forKey: resultList[sender.tag].EA_ISBN)
        }
        print(bellDic.count)
        saveBellList()
    }

}


// MARK: - Extensions
extension MainSearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}

extension MainSearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultView.dequeueReusableCell(withIdentifier: "commonCell", for: indexPath) as! CommonCell
        
        cell.bookCover.image = urlToImage(from: resultList[indexPath.row].TITLE_URL)
        if resultList[indexPath.row].TITLE == "" {
            cell.titleLabel.text = "[NO TITLE]"
            cell.titleLabel.textColor = .lightGray
        } else {
            cell.titleLabel.text = resultList[indexPath.row].TITLE
        }
        
        cell.authorLabel.text = resultList[indexPath.row].AUTHOR
        
        //heart button, bell button -> add Target
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(onOffHeartBtn), for: .touchUpInside)
        
        if heartDic[resultList[indexPath.row].EA_ISBN] != nil {
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        cell.bellBtn.tag = indexPath.row
        cell.bellBtn.addTarget(self, action: #selector(onOffBellBtn), for: .touchUpInside)
        
        if bellDic[resultList[indexPath.row].EA_ISBN] != nil {
            cell.bellBtn.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        } else {
            cell.bellBtn.setImage(UIImage(systemName: "bell"), for: .normal)
        }
        
        
        return cell
    }
    
    
}

extension MainSearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        if searchController.searchBar {
//            if let hasText = searchController.searchBar.text, !hasText.isEmpty {
//                let titleParam: [String: String] = [
//                    "title" : hasText
//                ]
//                let authorParam: [String: String] = [
//                    "author": hasText
//                ]
//                self.searchTool.callAPI(page_no: 1, page_size: 50, additional_param: titleParam) {
//                    self.resultList = self.searchTool.results
//                    self.resultView.reloadData()
//                }
//            }
//        }
        if let hasText = searchController.searchBar.text {
            self.resultList = []
            self.resultView.reloadData()
            if !hasText.isEmpty {
                let titleParam: [String: String] = [
                    "title" : hasText
                ]
                let authorParam: [String: String] = [
                    "author": hasText
                ]
                self.searchTool.callAPI(page_no: 1, page_size: 50, additional_param: titleParam) {
                    self.resultList.append(contentsOf: self.searchTool.results)
                    self.resultView.reloadData()
                }
                self.searchTool.callAPI(page_no: 1, page_size: 50, additional_param: authorParam) {
                    self.resultList.append(contentsOf: self.searchTool.results)
                    self.resultView.reloadData()
                }
            }
            
        }
    }
    
    
}
