//
//  RecBookSearchViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/16.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class RecBookSearchViewController: UIViewController {

    var selected: SeojiData = SeojiData()
    var searchResult: [(image: UIImage, contents:SeojiData)] = []
    var isSearched = false
    
    var searchTool = SearchBook()
    var searchedWord = ""
    var pageNo = 1
    var pageSize = 20
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultView: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        // setting table footer
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        settingFooterForTableView(for: tableFooter, action: #selector(showMoreResult))
        
        searchResultView.tableFooterView = tableFooter
        indicator.isHidden = true
        
        if searchResult.count == 0 {
            searchResultView.tableFooterView?.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        pageNo = 1
    }

    
    @objc func showMoreResult() {
        let title_param: [String: String] = [
            "title" : searchedWord
        ]
        let author_param: [String: String] = [
            "author" : searchedWord
        ]
        pageNo += 1
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: title_param, target: self) {
            self.indicator.startAnimating()
            if self.searchTool.results.isEmpty { // Attempt to present UIAlertController on RecBookSearchViewController which is already presenting UIAlertController
                let alert = UIAlertController(title: "알림", message: "마지막 검색 결과입니다!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                for item in self.searchTool.results {
                    let image = item.TITLE_URL.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.TITLE_URL)
                    self.searchResult.append((image: image!, contents: item))
                }
                self.searchResultView.reloadData()
            }
            self.indicator.stopAnimating()
        }
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: author_param, target: self) {
            self.indicator.startAnimating()
            if self.searchTool.results.isEmpty {
                let alert = UIAlertController(title: "알림", message: "마지막 검색 결과입니다!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                for item in self.searchTool.results {
                    let image = item.TITLE_URL.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.TITLE_URL)
                    self.searchResult.append((image: image!, contents: item))
                }
                self.searchResultView.reloadData()
            }
            self.indicator.stopAnimating()
        }
    }
}

// MARK:- Extensions
extension RecBookSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension RecBookSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultView.dequeueReusableCell(withIdentifier: "commonCell") as! CommonCell
        
        cell.bookCover.image = searchResult[indexPath.row].image
        cell.titleLabel.text = searchResult[indexPath.row].contents.TITLE
        cell.authorLabel.text = searchResult[indexPath.row].contents.AUTHOR
        cell.heartBtn.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selected = searchResult[indexPath.row].contents
        self.performSegue(withIdentifier: "toAddView", sender: self)
    }
    
    
}

extension RecBookSearchViewController: UISearchBarDelegate {
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        if !searchBar.text!.isEmpty {
            self.indicator.isHidden = false
            self.searchResultView.tableFooterView?.isHidden = false
            self.searchResult = []
            self.searchedWord = searchBar.text!
            self.searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: ["title" : searchBar.text!], target: self) {
                self.indicator.startAnimating()
                for item in self.searchTool.results {
                    let image = item.TITLE_URL.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.TITLE_URL)
                    self.searchResult.append((image: image!, contents: item))
                }
                self.searchResultView.reloadData()
                self.indicator.stopAnimating()
            }
            self.searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: ["author" : searchBar.text!], target: self) {
                self.indicator.startAnimating()
                for item in self.searchTool.results {
                    let image = item.TITLE_URL.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.TITLE_URL)
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
