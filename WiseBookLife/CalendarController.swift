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
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCalendarHeader()
        calendarView.collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // navigation bar bottom line 삭제하기
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reloadData()
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
        selectDateVC.modalPresentationStyle = .popover
        selectDateVC.preferredContentSize = CGSize(width: 200, height: UIScreen.main.bounds.height/3)
        
        self.present(selectDateVC, animated: true, completion: nil)
        
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
        guard let bookListVC = UIStoryboard(name: "CalendarListViewController", bundle: nil).instantiateViewController(withIdentifier: "CalendarListViewController") as? CalendarListViewController else { return }

        if let bookdatas = CommonData.calendarModel[key] {
            bookListVC.booklist = bookdatas
        }
        let withNavVC = UINavigationController(rootViewController: bookListVC)
        withNavVC.modalPresentationStyle = .fullScreen
        self.present(withNavVC, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendarView.dequeueReusableCell(withIdentifier: "CustomCell", for: date, at: position) as? CustomCell else {
            return FSCalendarCell()
        }
        cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
}
