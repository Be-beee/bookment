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
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
//        selectedView <- take selected data, and view
//        searchApiCall(method: "title", text: "sample")
        
    }

}

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
//        cell.publisherLabel.text = searchResult[indexPath.row].PUBLISHER
        cell.heartBtn.isHidden = true
        cell.bellBtn.isHidden = true
        
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
            self.searchTool.callAPI(page_no: "1", page_size: "50", additional_param: ["title" : searchBar.text!]) {
                for item in self.searchTool.results {
                    self.searchResult.append(item)
                }
                self.searchResultView.reloadData()
            }
            self.searchTool.callAPI(page_no: "1", page_size: "50", additional_param: ["author" : searchBar.text!]) {
                for item in self.searchTool.results {
                    self.searchResult.append(item)
                }
                self.searchResultView.reloadData()
            }
            
        } else {
            // 그냥 searchResult 비워두기
            self.searchResult = []
        }
    }
}
