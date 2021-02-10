//
//  CalendarController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/06.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarController: UIViewController {
    @IBOutlet weak var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCalendarView()
        calendarView.collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reloadData()
    }
    
    func settingCalendarView() {
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.appearance.headerTitleColor = .label
        calendarView.appearance.weekdayTextColor = .label
        calendarView.appearance.selectionColor = .systemOrange
    }
}

extension CalendarController: FSCalendarDelegate, FSCalendarDataSource {
    // 책 표지 표시
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy-MM-dd"

        let key = df.string(from: date)
        guard let data = CommonData.calendarModel[key] else { return nil }
        let bookImg = data[0].image
        return urlToImage(from: bookImg)
    }
    
    // 특정 날짜 선택 시
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let key = df.string(from: date)
        print(key)
        guard let addBookVC = UIStoryboard(name: "AddBookViewController", bundle: nil).instantiateViewController(withIdentifier: "AddBookViewController") as? AddBookViewController else { return }
        
//        UINavigationController(rootViewController: addBookVC)
        if let bookdatas = CommonData.calendarModel[key] {
            addBookVC.booklist = bookdatas
        }
        self.present(UINavigationController(rootViewController: addBookVC), animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendarView.dequeueReusableCell(withIdentifier: "CustomCell", for: date, at: position) as? CustomCell else {
            return FSCalendarCell()
        }
        cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
}
