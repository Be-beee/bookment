//
//  RecBookSearchViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/16.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class RecBookSearchViewController: UIViewController {

    var searchResult: [SeojiData] = []
    var isSearched = false
    
    
    let seojiURL = "http://seoji.nl.go.kr/landingPage/SearchApi.do"
    
    @IBOutlet var searchResultView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchResultView.tableHeaderView = searchController.searchBar
        searchController.delegate = self
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        searchApiCall(method: "title", text: "안녕")
        
    }
    
    
    func searchApiCall(method: String, text: String) {
        let param1: [String: String] = [
            "cert_key" : "5d01bbea58ffb91aeff99991a691eae9687af5bf7bece6abe67f6058cbaf364c",
            "result_style" : "json",
            "page_no" : "1",
            "page_size" : "100",
            method : text
        ]
        // title: text, author: text, isbn: text
        // isSearched = true
        
        var urlComponents = URLComponents(string: seojiURL)
        urlComponents?.query = param1.queryString
        
        guard let hasURL = urlComponents?.url else {
            return
        }
        
        // model
        // codable
        
        
        
        URLSession.shared.dataTask(with: hasURL) { (data, response, error) in
            guard let data = data else{
                return
            }
            print("data ok")
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(SearchData.self, from: data)
                let result = user.docs
                print(user.TOTAL_COUNT)
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
        // url 연결 자체가 안됨
    }

}

extension RecBookSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension RecBookSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch isSearched {
//        case true:
//            return searchResult.count
//        default:
//            return 0
//        }
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultView.dequeueReusableCell(withIdentifier: "commonCell") as! CommonCell
        
        
//        switch isSearched {
//        case true:
//            cell.bookCover.image = urlToImage(from: searchResult[indexPath.row].TITLE_URL)
//            cell.titleLabel.text = searchResult[indexPath.row].TITLE
//            cell.authorLabel.text = searchResult[indexPath.row].AUTHOR
//            cell.publisherLabel.text = searchResult[indexPath.row].PUBLISHER
//            cell.heartBtn.isHidden = true
//            cell.bellBtn.isHidden = true
//        default:
//            break
//        }
        cell.bookCover.image = urlToImage(from: searchResult[indexPath.row].TITLE_URL)
        cell.titleLabel.text = searchResult[indexPath.row].TITLE
        cell.authorLabel.text = searchResult[indexPath.row].AUTHOR
        cell.publisherLabel.text = searchResult[indexPath.row].PUBLISHER
        cell.heartBtn.isHidden = true
        cell.bellBtn.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addRecordVC = UIStoryboard(name: "AddRecordVC", bundle: nil).instantiateViewController(withIdentifier: "addRecordVC") as! AddRecordViewController
        addRecordVC.searchedData = searchResult[indexPath.row]
        //search 결과가 저장 안됨! 나중에 고쳐라
        
        self.performSegue(withIdentifier: "toAddView", sender: self)
    }
    
    
}



extension RecBookSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let hasText = searchController.searchBar.text {
            if hasText.isEmpty {
                isSearched = false
                print("not searched")
            } else {
                isSearched = true

                print("searched")
//              hasText -> url session -> author/title/isbn result -> sum -> searchResult
                searchApiCall(method: "title", text: hasText)
//                searchApiCall(method: "author", text: hasText)

            }

            searchResultView.reloadData()
        }
    }
}


extension RecBookSearchViewController: UISearchControllerDelegate {}
extension RecBookSearchViewController: UISearchBarDelegate {}

