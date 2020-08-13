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
        searchTool.callAPI(page_no: "1", page_size: "50", additional_param: titleParam) {
            for item in self.searchTool.results {
                self.resultList.append(item)
            }
        }
        searchTool.callAPI(page_no: "1", page_size: "50", additional_param: authorParam) {
            for item in self.searchTool.results {
                self.resultList.append(item)
            }
            self.resultView.reloadData()
        }
        
    }

}

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
        
        
        return cell
    }
    
    
}

extension MainSearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let hasText = searchController.searchBar.text, !hasText.isEmpty {
//            let param: [String: String] = [:]
//            self.searchTool.callAPI(page_no: "1", page_size: "50", additional_param: param) {
//                <#code#>
//            }
        }
    }
    
    
}
