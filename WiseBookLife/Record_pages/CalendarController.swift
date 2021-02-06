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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension CalendarController: FSCalendarDelegate {}
extension CalendarController: FSCalendarDataSource {}
