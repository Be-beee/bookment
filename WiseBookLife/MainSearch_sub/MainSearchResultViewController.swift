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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyResultView: UIView!
    
    var searchTool = SearchBook()
    var searchedWord = ""
    var curPageNo = 1
    var pageSize = 10
    
    var detailSearchQuery: [String: String] = [:]
    
    var isSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = Theme.main.mainColor
        self.indicator.stopAnimating()
        resultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        settingSearchBar()
        settingResultFooter()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        curPageNo = 1
        self.resultView.reloadData()
    }
    
    func settingSearchBar() {
        searchBar.backgroundColor = .systemBackground
        searchBar.delegate = self
    }
    
    func settingResultFooter() {
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        settingFooterForTableView(for: tableFooter, action: #selector(showMoreResult))
        
        resultView.tableFooterView = tableFooter
        resultView.tableFooterView?.isHidden = true
    }
    
    @objc func onOffHeartBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            CommonData.shared.heartDic.removeValue(forKey: resultList[sender.tag].contents.isbn)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            CommonData.shared.heartDic.updateValue(resultList[sender.tag].contents, forKey: resultList[sender.tag].contents.isbn)
        }
//        saveData(data: heartDic, at: "heart")
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
        
        if CommonData.shared.heartDic[resultList[indexPath.row].contents.isbn] != nil {
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        cell.addLibraryBtn.tag = indexPath.row
        cell.addLibraryBtn.addTarget(self, action: #selector(addToLibrary), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addToLibrary(_ sender: UIButton!) {
        let addLibraryVC = UIStoryboard(name: "AddBookViewController", bundle: nil).instantiateViewController(withIdentifier: "AddBookViewController") as! AddBookViewController
        addLibraryVC.recordModel = Record(bookData: self.resultList[sender.tag].contents, date: Date(), contents: [])
        
        self.present(addLibraryVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "BookDetailVC", bundle: nil).instantiateViewController(withIdentifier: "bookDetailVC") as! BookDetailViewController
        
        detailVC.bookData = resultList[indexPath.row].contents
        detailVC.modalPresentationStyle = .fullScreen
        if CommonData.shared.heartDic[resultList[indexPath.row].contents.isbn] != nil {
            detailVC.isHeartBtnSelected = true
        } else {
            detailVC.isHeartBtnSelected = false
        }
        
        present(detailVC, animated: true, completion: nil)
    }
    
    
}

extension MainSearchResultViewController: UISearchBarDelegate {
    @objc func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        self.curPageNo = 1
        self.resultList = []
        self.resultView.reloadData()
        if let hasText = searchBar.text {
            if !hasText.isEmpty {
                self.resultView.tableFooterView?.isHidden = false
                self.searchedWord = hasText
                searchBar.text = self.searchedWord
                searchBar.enablesReturnKeyAutomatically = true
                let query_param: [String: String] = [
                    "query" : hasText,
                    "start" : String(curPageNo)
                ]
                self.searchTool.callAPI(additional_param: query_param, target: self) {
                    self.indicator.startAnimating()
                    for item in self.searchTool.results {
                        let image = item.image.isEmpty ? UIImage(named: "No_Img.png") : self.urlToImage(from: item.image)
                        self.resultList.append((image: image!, contents: item))
                    }
                    if self.resultList.isEmpty {
                        self.emptyResultView.isHidden = false
                    } else {
                        self.emptyResultView.isHidden = true
                    }
                    self.resultView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            

        } else {
            self.indicator.isHidden = true
            self.emptyResultView.isHidden = false
        }
    }
}
