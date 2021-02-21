//
//  AddBookViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/10.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class CalendarListViewController: UIViewController {

    var booklist: [BookItem] = []
    @IBOutlet weak var todayBookTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        todayBookTableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        settingCalendarListFooter()// setting table footer
    }
    
    func settingCalendarListFooter() {
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        settingFooterForTableView(for: tableFooter, action: #selector(addBookToCalendar), title: "책 추가")
        
        todayBookTableView.tableFooterView = tableFooter
    }
    
    @IBAction func unwindToThisDateBookList(sender: UIStoryboardSegue) {
        guard let searchresultVC = sender.source as? SubSearchViewController else {
            return
        }
        booklist.append(searchresultVC.selected)
        todayBookTableView.reloadData()
        // add archive code
    }
    
    @IBAction func dismissListView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addBookToCalendar() {
        guard let subSearchVC = UIStoryboard(name: "SubSearchViewController", bundle: nil).instantiateViewController(withIdentifier: "SubSearchViewController") as? SubSearchViewController else { return }
        subSearchVC.from = .calendar
        self.present(subSearchVC, animated: true, completion: nil)
    }
    
    
}

extension CalendarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension CalendarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = todayBookTableView.dequeueReusableCell(withIdentifier: "commonCell") as? CommonCell else { return UITableViewCell() }
        let item = booklist[indexPath.row]
        cell.bookCover.image = urlToImage(from: item.image)
        cell.titleLabel.text = item.title
        cell.authorLabel.text = item.author
        
        
        return cell
    }
    
    
}
