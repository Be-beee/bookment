//
//  HeartListViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

final class HeartListViewController: UIViewController {

    // MARK: - UI Properties
    
    @IBOutlet var heartView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: - Properties
    
    private let cellID = CommonCell.name
    private let viewModel = HeartListViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
        configureTableViewCell()
        configureEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadHeartContents()
    }
    
    // MARK: - Bind Function
    
    private func bindToViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Configure Functions
    
    private func configureTableViewCell() {
        heartView.register(
            UINib(nibName: cellID, bundle: nil),
            forCellReuseIdentifier: cellID
        )
    }
    
    private func configureEmptyView() {
        emptyView.backgroundColor = .systemBackground
        emptyView.alpha = 1
        reloadEmptyView()
    }
    
    // MARK: - Refresh Functions
    
    private func refreshData() {
        // TODO: title sorting 구현
        heartView.reloadData()
        reloadEmptyView()
    }
    
    private func reloadEmptyView() {
        emptyView.isHidden = viewModel.count > 0
    }
}

// MARK: - HeartListViewModelDelegate

extension HeartListViewController: HeartListViewModelDelegate {
    func heartListDidChange() {
        refreshData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HeartListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = heartView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CommonCell,
              let foundBookInfo = viewModel.find(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.bookInfo = foundBookInfo
        cell.readonly = false

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDetailViewID = BookDetailViewController.name
        guard let bookDetailView = UIStoryboard(name: bookDetailViewID, bundle: nil).instantiateViewController(withIdentifier: bookDetailViewID) as? BookDetailViewController,
              let foundBookInfo = viewModel.find(at: indexPath.row)
        else { return }
        
        let bookDetailViewModel = BookDetailViewModel(bookData: foundBookInfo)
        bookDetailView.viewModel = bookDetailViewModel
        bookDetailView.modalPresentationStyle = .fullScreen
        
        present(
            bookDetailView,
            animated: true,
            completion: nil
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.cellHeight
    }
    
}

// MARK: - CommonCellDelegate

extension HeartListViewController: CommonCellDelegate {
    func heartButtonDidTouch() {
        viewModel.loadHeartContents()
    }
    
    func addBookButtonDidTouched(destinationView: UIViewController) {
        present(destinationView, animated: true)
    }
}

// MARK: - Namespaces

extension HeartListViewController {
    enum Metric {
        static let cellHeight: CGFloat = 135
    }
}
