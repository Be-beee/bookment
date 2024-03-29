//
//  CalendarMainViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/06.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

import RealmSwift
import FSCalendar

class CalendarMainViewController: UIViewController {
    @IBOutlet weak var calendarView: FSCalendar!
    let datePicker = UIDatePicker()
    
    var calData: [String: [BookInfo]] = [:]
    private let cellName = CustomCell.name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCalendarHeader()
        calendarView.collectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCalendarData()
        calendarView.reloadData()
    }
    
    func setCalendarData() {
        calData = recordToCaledar()
    }
    
    func settingCalendarHeader() {
        let headerButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: calendarView.calendarHeaderView.fs_height))
        headerButton.setTitle("타이틀 구역입니다.", for: .normal)
        headerButton.setTitleColor(.clear, for: .normal)
        headerButton.isUserInteractionEnabled = true
        
        headerButton.addTarget(self, action: #selector(chooseDateWithPicker), for: .touchUpInside)
        calendarView.addSubview(headerButton)
        
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerButton.centerYAnchor.constraint(equalTo: calendarView.calendarHeaderView.centerYAnchor).isActive = true
    }
    
    @objc func chooseDateWithPicker() {
        guard let selectDateVC = UIStoryboard(name: "SelectDateController", bundle: nil).instantiateViewController(withIdentifier: "SelectDateController") as? SelectDateController else { return }
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy MM"
        selectDateVC.selectedDate = df.string(from: calendarView.currentPage)
        self.present(selectDateVC, animated: true, completion: nil)
        
    }
    
    @IBAction func unwindToCalendarFromSelectDate(sender: UIStoryboardSegue) {
        guard let selectVC = sender.source as? SelectDateController else { return }
        
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_KR")
        date.dateFormat = "yyyy년 MM월"
        calendarView.setCurrentPage(date.date(from: selectVC.selectedDate) ?? Date(), animated: false)
    }
}

extension CalendarMainViewController: FSCalendarDelegate, FSCalendarDataSource {
    // 책 표지 표시
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let key = date.dateToString()
        guard let data = calData[key] else { return nil }
        if data.count > 0 {
            let imageURL = data[0].image
            Task {
                let image = await ImageDownloader.urlToImage(from: imageURL)
                return image
            }
        }
        return nil
    }
    
    // 특정 날짜 선택 시
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let key = df.string(from: date)
        guard let bookListVC = UIStoryboard(name: "CalendarListViewController", bundle: nil).instantiateViewController(withIdentifier: "CalendarListViewController") as? CalendarListViewController else { return }

        bookListVC.currentDate = key
        if let bookdatas = calData[key] {
            bookListVC.booklist = bookdatas
        }
        let withNavVC = UINavigationController(rootViewController: bookListVC)
        withNavVC.modalPresentationStyle = .fullScreen
        self.present(withNavVC, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendarView.dequeueReusableCell(withIdentifier: cellName, for: date, at: position) as? CustomCell else {
            return FSCalendarCell()
        }
        cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
}

extension CalendarMainViewController {
    // MARK: - DatabaseManager
    
    func recordToCaledar() -> [String: [BookInfo]] { // date_string: [BookInfo]
        let loaded: Results<RecordContent> = DatabaseManager.shared.load()
        var calendarData: [String: [BookInfo]] = [:]
        for item in loaded {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let date_str = df.string(from: item.date)
            
            guard let newBookItem: BookInfoLocalDTO = DatabaseManager.shared.find(with: item.isbn)
            else { continue }
            let newBookInfo = newBookItem.entity()
            
            if var value = calendarData[date_str] {
                if value.contains(where: { $0.isbn == newBookItem.isbn }) { continue }
                value.append(newBookInfo)
                calendarData.updateValue(value, forKey: date_str)
            } else {
                calendarData.updateValue([newBookInfo], forKey: date_str)
            }
        }
        
        return calendarData
    }
}
