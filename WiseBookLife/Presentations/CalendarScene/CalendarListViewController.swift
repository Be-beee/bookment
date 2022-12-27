//
//  AddBookViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/10.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class CalendarListViewController: UIViewController {

    var currentDate: String = "yyyy-MM-dd" // format
    var booklist: [BookInfo] = []
    @IBOutlet weak var todayBookTableView: UITableView!
    @IBOutlet weak var emptyResultView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBarLine()
        
        configureTableViewCell()
        refreshBookListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBookListView()
    }
    
    func refreshBookListView() {
        todayBookTableView.reloadData()
        if booklist.isEmpty {
            self.emptyResultView.isHidden = false
        } else {
            self.emptyResultView.isHidden = true
        }
    }
    
    // MARK: - Configure Functions
    
    private func configureTableViewCell() {
        let cellID = CommonCell.name
        todayBookTableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    // MARK: - IBAction Functions
    
    @IBAction func dismissListView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CalendarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.cellHeight
    }
}

extension CalendarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = todayBookTableView.dequeueReusableCell(withIdentifier: CommonCell.name) as? CommonCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        cell.delegate = self
        cell.bookInfo = booklist[indexPath.row]
        cell.readonly = true
        
        return cell
    }
    
}

// MARK: - CommonCellDelegate

extension CalendarListViewController: CommonCellDelegate {
    func heartButtonDidTouch() {
        refreshBookListView()
    }
}

// MARK: - Namespaces

extension CalendarListViewController {
    enum Metric {
        static let cellHeight: CGFloat = 135
    }
}
