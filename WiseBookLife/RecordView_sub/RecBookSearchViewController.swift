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
    var searchResult: [SeojiData] = []
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
        let footerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        footerBtn.setTitle("결과 더보기", for: .normal)
        footerBtn.addTarget(self, action: #selector(showMoreResult), for: .touchUpInside)
        tableFooter.addSubview(footerBtn)
        
        searchResultView.tableFooterView = tableFooter
        if searchResult.count == 0 {
            tableFooter.isHidden = true
        }
        // 결과는 제대로 나타나지만 table footer가 보이지 않음..
        // 빈 화면에서부터 activity indicator가 작동 중임
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
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: title_param) {
            self.searchResult.append(contentsOf: self.searchTool.results)
            self.searchResultView.reloadData()
        }
        searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: author_param) {
            self.searchResult.append(contentsOf: self.searchTool.results)
            self.searchResultView.reloadData()
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
        
        cell.bookCover.image = urlToImage(from: searchResult[indexPath.row].TITLE_URL)
        cell.titleLabel.text = searchResult[indexPath.row].TITLE
        cell.authorLabel.text = searchResult[indexPath.row].AUTHOR
        cell.heartBtn.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selected = searchResult[indexPath.row]
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
            self.searchResult = []
            self.searchedWord = searchBar.text!
            self.searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: ["title" : searchBar.text!]) {
                self.indicator.startAnimating()
                self.searchResult.append(contentsOf: self.searchTool.results)
                self.searchResultView.reloadData()
                self.indicator.stopAnimating()
            }
            self.searchTool.callAPI(page_no: pageNo, page_size: pageSize, additional_param: ["author" : searchBar.text!]) {
                self.indicator.startAnimating()
                self.searchResult.append(contentsOf: self.searchTool.results)
                self.searchResultView.reloadData()
                self.indicator.stopAnimating()
            }
            
        } else {
            // searchResult 비워두기
            self.searchResult = []
            self.indicator.stopAnimating()
        }
    }
}
