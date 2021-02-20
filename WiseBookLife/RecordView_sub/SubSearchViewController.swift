//
//  RecBookSearchViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/16.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class SubSearchViewController: UIViewController {

    var selected = BookItem()
    var searchResult: [(image: UIImage, contents: BookItem)] = []
    var isSearched = false
    
    var searchTool = SearchBook()
    var searchedWord = ""
    var curPageNo = 1
    var pageSize = 10
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultView: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        settingResultFooter()// setting table footer
        
    }
    override func viewWillAppear(_ animated: Bool) {
        curPageNo = 1
    }

    func settingResultFooter() {
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        settingFooterForTableView(for: tableFooter, action: #selector(showMoreResult))
        
        searchResultView.tableFooterView = tableFooter
        indicator.isHidden = true
        
        if searchResult.count == 0 {
            searchResultView.tableFooterView?.isHidden = true
        }
    }
    
    @objc func showMoreResult() {
        curPageNo += pageSize
        let query_param: [String: String] = [
            "query" : searchedWord,
            "start" : String(curPageNo)
        ]
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
                    self.searchResult.append((image: image!, contents: item))
                }
                self.searchResultView.reloadData()
            }
            self.indicator.stopAnimating()
        }
    }
}

// MARK:- Extensions
extension SubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension SubSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultView.dequeueReusableCell(withIdentifier: "commonCell") as! CommonCell
        
        cell.bookCover.image = searchResult[indexPath.row].image
        cell.titleLabel.text = searchResult[indexPath.row].contents.title
        cell.authorLabel.text = searchResult[indexPath.row].contents.author
        cell.heartBtn.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selected = searchResult[indexPath.row].contents
        self.performSegue(withIdentifier: "toAddView", sender: self)
    }
    
    
}

extension SubSearchViewController: UISearchBarDelegate {
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        self.curPageNo = 1
        
        if !searchBar.text!.isEmpty {
            self.indicator.isHidden = false
            self.searchResultView.tableFooterView?.isHidden = false
            self.searchResult = []
            self.searchedWord = searchBar.text!
            self.searchTool.callAPI(additional_param: ["query" : searchBar.text!], target: self) {
                self.indicator.startAnimating()
                for item in self.searchTool.results {
                    let image = item.image.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.image)
                    self.searchResult.append((image: image!, contents: item))
                }
                self.searchResultView.reloadData()
                self.indicator.stopAnimating()
            }
            
        } else {
            self.searchResult = []
            self.indicator.isHidden = true
            self.searchResultView.tableFooterView?.isHidden = true
        }
    }
}
