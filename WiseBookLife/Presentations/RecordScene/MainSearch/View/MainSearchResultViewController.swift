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
    
    private let cellID = CommonCell.name

    var viewModel = MainSearchViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = Theme.main.mainColor
        self.indicator.stopAnimating()
        configureTableViewCell()
        
        settingSearchBar()
        settingResultFooter()
        
        bindToViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func configureTableViewCell() {
        resultView.register(
            UINib(nibName: cellID, bundle: nil),
            forCellReuseIdentifier: cellID
        )
    }
    
    // MARK: - objc Functions
    
    @objc func showMoreResult() {
        indicator.startAnimating()
        Task {
            await viewModel.searchMore()
        }
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainSearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.cellHeight
    }
}

extension MainSearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CommonCell
        else { return UITableViewCell()}
        
        cell.delegate = self
        cell.bookInfo = viewModel.searchResult[indexPath.row]
        cell.readonly = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CommonCell,
              let bookInfo = cell.bookInfo
        else { return }
        
        let bookDetailViewID = BookDetailViewController.name
        guard let detailVC = loadViewController(with: bookDetailViewID) as? BookDetailViewController
        else { return }
        
        detailVC.bookData = bookInfo
        detailVC.modalPresentationStyle = .fullScreen
        
        present(detailVC, animated: true, completion: nil)
    }
    
    
}

// MARK: - CommonCellDelegate

extension MainSearchResultViewController: CommonCellDelegate {
    func addBookButtonDidTouched(destinationView: UIViewController) {
        present(destinationView, animated: true)
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
        
        guard let hasText = searchBar.text, !hasText.isEmpty
        else {
            indicator.isHidden = true
            emptyResultView.isHidden = false
            return
        }
        
        self.resultView.tableFooterView?.isHidden = false
        searchBar.enablesReturnKeyAutomatically = true
        
        Task {
            await viewModel.search(with: hasText)
        }
    }
}

// MARK: - MainSearchViewModelDelegate

extension MainSearchResultViewController: MainSearchViewModelDelegate {
    
    /// 검색 결과를 정상적으로 받아왔을 때의 UI 작업 처리.
    func searchResultDidChange() {
        if viewModel.isLastPage {
            // TODO: 추후 FooterView의 버튼을 터치하여 추가적인 검색 결과를 확인하는 방식 대신 무한 스크롤 방식으로 수정하길
            presentNoticeAlert(with: StringLiteral.noMoreResultMessage)
        } else {
            emptyResultView.isHidden = !viewModel.searchResult.isEmpty
            resultView.reloadData()
        }
        
        indicator.stopAnimating()
    }
    
    /// 네트워크 통신 실패, 디코딩 실패 등으로 검색 결과를 받아오지 못했을 때 이후 처리.
    func searchResultLoadFailed() {
        presentNoticeAlert(with: StringLiteral.loadFailedMessage)
        indicator.stopAnimating()
    }
    
}

// MARK: - Namespaces

extension MainSearchResultViewController {
    
    enum Metric {
        static let cellHeight: CGFloat = 135
    }
    
    enum StringLiteral {
        static let noMoreResultMessage = "검색 결과가 없습니다."
        static let loadFailedMessage = "검색 결과를 불러오는 데 실패했습니다."
    }
}

