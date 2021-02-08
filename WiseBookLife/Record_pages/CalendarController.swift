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
    
    var sampleDate: [Date] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCalendarView()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let tomorrow = formatter.date(from: "2021-02-01")
        let newyear = formatter.date(from: "2021-02-14")
        
        sampleDate = [tomorrow!]
        
        calendarView.collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
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
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        if self.sampleDate.contains(date) {
//            let image = UIImage(named: "No_Img")
//            return image // 이미지 사이즈 문제
//        } else {
//            return nil
//        }
//    }
    
    // 특정 날짜 선택 시
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        print(formatter.string(from: date))
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendarView.dequeueReusableCell(withIdentifier: "CustomCell", for: date, at: position) as? CustomCell else {
            print("None")
            return FSCalendarCell()
        }
        cell.imageView.contentMode = .scaleAspectFill
        if self.sampleDate.contains(date) {
            let image = UIImage(named: "No_Img")
            cell.bookCover.image = image
        }
        return cell
    }
    
    // 이벤트 표시
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        if self.sampleDate.contains(date) {
//            return 1
//        } else {
//            return 0
//        }
//    }
    
    
    
}
