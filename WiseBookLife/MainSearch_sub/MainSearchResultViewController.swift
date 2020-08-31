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
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    var searchTool = SearchBook()
    var searchedWord = ""
    var pageNo = 1
    var pageSize = 20
    
    var detailSearchQuery: [String: String] = [:]
    
    var isSearched = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.hidesSearchBarWhenScrolling = false
        resultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        
        searchController.searchBar.text = searchedWord
        self.navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        if searchedWord.isEmpty, detailSearchQuery.count != 0 {
            searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: detailSearchQuery) {
                self.indicator.startAnimating()
                self.resultList.append(contentsOf: self.searchTool.results)
                self.resultView.reloadData()
                self.indicator.stopAnimating()
            }
        } else {
            let titleParam = [
                "title" : searchedWord
            ]
            let authorParam = [
                "author" : searchedWord
            ]
            searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: titleParam) {
                self.indicator.startAnimating()
                self.resultList.append(contentsOf: self.searchTool.results)
                self.resultView.reloadData()
                self.indicator.stopAnimating()
            }
            searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: authorParam) {
                self.indicator.startAnimating()
                self.resultList.append(contentsOf: self.searchTool.results)
                self.resultView.reloadData()
                self.indicator.stopAnimating()
                
            }
        }
        
        // setting table footer
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let footerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        footerBtn.setTitle("결과 더보기", for: .normal)
        footerBtn.addTarget(self, action: #selector(showMoreResult), for: .touchUpInside)
        tableFooter.addSubview(footerBtn)
        
        resultView.tableFooterView = tableFooter
        
    }
    override func viewWillAppear(_ animated: Bool) {
        pageNo = 1
    }
    
    @objc func onOffHeartBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            heartDic.removeValue(forKey: resultList[sender.tag].EA_ISBN)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartDic.updateValue(resultList[sender.tag], forKey: resultList[sender.tag].EA_ISBN)
        }
        saveData(data: heartDic, at: "heart")
    }
    
    @objc func showMoreResult() {
        let title_param: [String: String] = [
            "title" : searchedWord
        ]
        let author_param: [String: String] = [
            "author" : searchedWord
        ]
        pageNo += 1
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: title_param) {
            self.indicator.startAnimating()
            self.resultList.append(contentsOf: self.searchTool.results)
            self.resultView.reloadData()
            self.indicator.stopAnimating()
        }
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: author_param) {
            self.indicator.startAnimating()
            self.resultList.append(contentsOf: self.searchTool.results)
            self.resultView.reloadData()
            self.indicator.stopAnimating()
        }
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "BookDetailVC", bundle: nil).instantiateViewController(withIdentifier: "bookDetailVC") as! BookDetailViewController
        
        detailVC.bookData = resultList[indexPath.row]
        detailVC.modalPresentationStyle = .fullScreen
        if heartDic[resultList[indexPath.row].EA_ISBN] != nil {
            detailVC.isHeartBtnSelected = true
        } else {
            detailVC.isHeartBtnSelected = false
        }
        
        present(detailVC, animated: true, completion: nil)
    }
    
    
}

extension MainSearchResultViewController: UISearchBarDelegate {
    @objc func dismissKeyboard() {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        pageNo = 1
        if let hasText = searchBar.text {
            self.resultList = []
            self.resultView.reloadData()
            if !hasText.isEmpty {
                let titleParam: [String: String] = [
                    "title" : hasText
                ]
                let authorParam: [String: String] = [
                    "author": hasText
                ]
                self.searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: titleParam) {
                    self.indicator.startAnimating()
                    self.resultList.append(contentsOf: self.searchTool.results)
                    self.resultView.reloadData()
                    self.indicator.stopAnimating()
                }
                self.searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: authorParam) {
                    self.indicator.startAnimating()
                    self.resultList.append(contentsOf: self.searchTool.results)
                    self.resultView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            

        }
    }
}
