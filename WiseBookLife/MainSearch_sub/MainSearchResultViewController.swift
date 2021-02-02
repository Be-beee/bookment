//
//  MainSearchResultViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/09.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class MainSearchResultViewController: UIViewController {

    var resultList: [(image: UIImage, contents: BookItem)] = []
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
        
        // setting table footer
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        settingFooterForTableView(for: tableFooter, action: #selector(showMoreResult))
        
        resultView.tableFooterView = tableFooter
        resultView.tableFooterView?.isHidden = true
        
        if searchedWord.isEmpty, detailSearchQuery.count != 0 {
            searchTool.callAPI(additional_param: detailSearchQuery, target: self) {
                self.indicator.startAnimating()
                for item in self.searchTool.results {
                    let image = item.image.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.image)
                    self.resultList.append((image: image!, contents: item))
                }
                self.resultView.reloadData()
                self.indicator.stopAnimating()
                self.resultView.tableFooterView?.isHidden = false
            }
        } else {
            let query_param = [
                "query" : searchedWord
            ]
            searchTool.callAPI(additional_param: query_param, target: self) {
                self.indicator.startAnimating()
                for item in self.searchTool.results {
                    let image = item.image.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.image)
                    self.resultList.append((image: image!, contents: item))
                }
                self.resultView.reloadData()
                self.indicator.stopAnimating()
                self.resultView.tableFooterView?.isHidden = false
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        pageNo = 1
    }
    
    @objc func onOffHeartBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            heartDic.removeValue(forKey: resultList[sender.tag].contents.isbn)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartDic.updateValue(resultList[sender.tag].contents, forKey: resultList[sender.tag].contents.isbn)
        }
//        saveData(data: heartDic, at: "heart")
    }
    
    @objc func showMoreResult() {
        let query_param: [String: String] = [
            "query" : searchedWord
        ]
        pageNo += 1
        searchTool.callAPI(additional_param: query_param, target: self) {
            self.indicator.startAnimating()
            if self.searchTool.results.isEmpty {
                let alert = UIAlertController(title: "알림", message: "마지막 검색 결과입니다!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                for item in self.searchTool.results {
                    let image = item.image.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.image)
                    self.resultList.append((image: image!, contents: item))
                }
                self.resultView.reloadData()
            }
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
        
        cell.bookCover.image = resultList[indexPath.row].image
        if resultList[indexPath.row].contents.title == "" {
            cell.titleLabel.text = "[NO TITLE]"
            cell.titleLabel.textColor = .lightGray
        } else {
            cell.titleLabel.text = resultList[indexPath.row].contents.title
        }
        
        cell.authorLabel.text = resultList[indexPath.row].contents.author
        
        //heart button, bell button -> add Target
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(onOffHeartBtn), for: .touchUpInside)
        
        if heartDic[resultList[indexPath.row].contents.isbn] != nil {
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "BookDetailVC", bundle: nil).instantiateViewController(withIdentifier: "bookDetailVC") as! BookDetailViewController
        
        detailVC.bookData = resultList[indexPath.row].contents
        detailVC.modalPresentationStyle = .fullScreen
        if heartDic[resultList[indexPath.row].contents.isbn] != nil {
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
                self.searchedWord = hasText
                self.searchController.searchBar.text = self.searchedWord
                let titleParam: [String: String] = [
                    "title" : hasText
                ]
                let authorParam: [String: String] = [
                    "author": hasText
                ]
                self.searchTool.callAPI(additional_param: titleParam, target: self) {
                    self.indicator.startAnimating()
                    for item in self.searchTool.results {
                        let image = item.image.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.image)
                        self.resultList.append((image: image!, contents: item))
                    }
                    self.resultView.reloadData()
                    self.indicator.stopAnimating()
                }
                self.searchTool.callAPI(additional_param: authorParam, target: self) {
                    self.indicator.startAnimating()
                    for item in self.searchTool.results {
                        let image = item.image.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.image)
                        self.resultList.append((image: image!, contents: item))
                    }
                    self.resultView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            

        }
    }
}
