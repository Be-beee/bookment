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
    
    
    let seojiURL = "http://seoji.nl.go.kr/landingPage/SearchApi.do"
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchResultView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
//        selectedView <- take selected data, and view
//        searchApiCall(method: "title", text: "sample")
        
    }
    
    
    func searchApiCall(method: String, text: String) {
        let param: [String: String] = [
            "cert_key" : "5d01bbea58ffb91aeff99991a691eae9687af5bf7bece6abe67f6058cbaf364c",
            "result_style" : "json",
            "page_no" : "1",
            "page_size" : "10",
            method : text
        ]
        
        
        // title: text, author: text
        // isSearched = true
        // remove method param
        
        var urlComponents = URLComponents(string: seojiURL)
        urlComponents?.query = param.queryString
        
        guard let hasURL = urlComponents?.url else {
            return
        }
        
        // model
        // codable
        
        
        
        URLSession.shared.dataTask(with: hasURL) { (data, response, error) in
            guard let dataFromTitle = data else{
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(SearchData.self, from: dataFromTitle)
                let result = user.docs
                DispatchQueue.main.async {
                    for item in result {
                        self.searchResult.append(item)
                    }
                    self.searchResultView.reloadData()
                }
                
            } catch {
                // error 처리
                print("error ==> \(error)")
            }
        }.resume()
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
        cell.publisherLabel.text = searchResult[indexPath.row].PUBLISHER
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
            self.searchApiCall(method: "title", text: searchBar.text!)
            self.searchApiCall(method: "author", text: searchBar.text!)
            
        } else {
            // 그냥 searchResult 비워두기
        }
    }
}
