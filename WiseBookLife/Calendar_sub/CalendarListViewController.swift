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
    var booklist: [BookItem] = []
    @IBOutlet weak var todayBookTableView: UITableView!
    @IBOutlet weak var emptyResultView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        refreshBookListView()
        todayBookTableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
//        settingCalendarListFooter()
//        settingTapGestureAtEmptyResultView()
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
    
    func settingCalendarListFooter() {
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        settingFooterForTableView(for: tableFooter, action: #selector(addBookToCalendar), title: nil, image: UIImage(systemName: "plus"), bgColor: .systemOrange)
        
        todayBookTableView.tableFooterView = tableFooter
    }
    
    func settingTapGestureAtEmptyResultView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addBookToCalendar))
        self.emptyResultView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func unwindToThisDateBookList(sender: UIStoryboardSegue) {
        guard let searchresultVC = sender.source as? SubSearchViewController else {
            return
        }
        
        var prevData = CommonData.shared.calendarModel[currentDate] ?? [] // 선택된 날짜 정보 추가
        prevData.append(searchresultVC.selected)
        CommonData.shared.calendarModel.updateValue(prevData, forKey: currentDate)
        booklist.append(searchresultVC.selected)
        refreshBookListView()
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
        
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(onOffHeartBtn), for: .touchUpInside)
        
        if CommonData.shared.heartDic[booklist[indexPath.row].isbn] != nil {
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        return cell
    }
    
    @objc func onOffHeartBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            CommonData.shared.heartDic.removeValue(forKey: booklist[sender.tag].isbn)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            CommonData.shared.heartDic.updateValue(booklist[sender.tag], forKey: booklist[sender.tag].isbn)
        }
//        saveData(data: heartDic, at: "heart")
    }
    
    
}
