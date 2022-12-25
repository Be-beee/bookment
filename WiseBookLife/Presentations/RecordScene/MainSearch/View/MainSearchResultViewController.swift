//
//  MainSearchResultViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/09.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

final class MainSearchResultViewController: UIViewController {
    
    // MARK: - UI Properties
    
    @IBOutlet var resultView: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyResultView: UIView!
    
    // MARK: - Properties

    var viewModel = MainSearchViewModel()
    var searchedWord = ""
    var curPageNo = 1
    var pageSize = 10
    
    var detailSearchQuery: [String: String] = [:]
    
    var isSearched = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = Theme.main.mainColor
        self.indicator.stopAnimating()
        resultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        settingSearchBar()
        settingResultFooter()
        
        bindToViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        curPageNo = 1
        self.resultView.reloadData()
    }
    
    // MARK: - Bind Function
    
    private func bindToViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Functions
    
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
    
    @objc func heartButtonDidTouch(_ sender: UIButton!) {
        let target = viewModel.searchResult[sender.tag]
        if let foundHeartContent = DatabaseManager.shared.findHeartContent(target.isbn) {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            DatabaseManager.shared.deleteHeartContentToDB(foundHeartContent, target.isbn)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            let newHeartContent = HeartContent(isbn: target.isbn, date: Date())
            DatabaseManager.shared.addHeartContentToDB(newHeartContent, target)
        }
    }
    
    @objc func showMoreResult() {
        indicator.startAnimating()
        curPageNo += pageSize
        Task {
            try await viewModel.search(with: searchedWord, at: curPageNo)
        }
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainSearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}

extension MainSearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultView.dequeueReusableCell(withIdentifier: "commonCell", for: indexPath) as? CommonCell
        else { return UITableViewCell()}
        
        let bookInfo = viewModel.searchResult[indexPath.row]
        
        // TODO: URL -> 이미지 처리
//        cell.bookCover.image = bookInfo.image
        if bookInfo.title == "" {
            cell.titleLabel.text = "[NO TITLE]"
            cell.titleLabel.textColor = .lightGray
        } else {
            cell.titleLabel.text = bookInfo.title
        }
        
        cell.authorLabel.text = bookInfo.author
        
        //heart button, bell button -> add Target
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(heartButtonDidTouch), for: .touchUpInside)
        
        if DatabaseManager.shared.findHeartContent(bookInfo.isbn) != nil {
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
        
        let selected = viewModel.searchResult[sender.tag]
        addLibraryVC.selectedBookInfo = selected
        
        self.present(addLibraryVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "BookDetailVC", bundle: nil).instantiateViewController(withIdentifier: "bookDetailVC") as! BookDetailViewController
        
        let bookInfo = viewModel.searchResult[indexPath.row]
        
        detailVC.bookData = bookInfo
        detailVC.modalPresentationStyle = .fullScreen
        if let _ = DatabaseManager.shared.findBookInfo(isbn: bookInfo.isbn) {
            detailVC.isHeartBtnSelected = true
        } else {
            detailVC.isHeartBtnSelected = false
        }
        
        present(detailVC, animated: true, completion: nil)
    }
    
    
}

// MARK: - UISearchBarDelegate

extension MainSearchResultViewController: UISearchBarDelegate {
    @objc func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        indicator.startAnimating()
        
        viewModel.clear()
        
        guard let hasText = searchBar.text,
              !hasText.isEmpty
        else {
            indicator.isHidden = true
            emptyResultView.isHidden = false
            return
        }
        
        self.resultView.tableFooterView?.isHidden = false
        self.searchedWord = hasText
        searchBar.text = self.searchedWord
        searchBar.enablesReturnKeyAutomatically = true
        Task {
            try await viewModel.search(with: hasText, at: curPageNo)
        }
    }
}

// MARK: - MainSearchViewModelDelegate

extension MainSearchResultViewController: MainSearchViewModelDelegate {
    
    /// 검색 결과를 정상적으로 받아왔을 때의 UI 작업 처리.
    func searchResultDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if self.viewModel.searchResult.isEmpty {
                self.presentNoticeAlert(with: StringLiteral.noMoreResultMessage)
            } else {
                self.resultView.reloadData()
            }
            self.indicator.stopAnimating()
        }
    }
    
    /// 네트워크 통신 실패, 디코딩 실패 등으로 검색 결과를 받아오지 못했을 때 이후 처리.
    func searchResultLoadFailed() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.presentNoticeAlert(with: StringLiteral.loadFailedMessage)
            self.indicator.stopAnimating()
        }
    }
    
}

// MARK: - Namespaces

extension MainSearchResultViewController {
    enum StringLiteral {
        static let noMoreResultMessage = "검색 결과가 없습니다."
        static let loadFailedMessage = "검색 결과를 불러오는 데 실패했습니다."
    }
}