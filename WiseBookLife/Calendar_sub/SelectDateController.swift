//
//  SelectDateController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/03/02.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class SelectDateController: UIViewController {

    @IBOutlet weak var calendarDatePicker: UIPickerView!
    var selectedDate: String = ""
    var calendarYearList: [String] = []
    var calendarMonthList: [String] = [
        "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSelectDateAlertView()
        settingPickerViewYearList()
    }
    
    func settingSelectDateAlertView() {
        self.view.backgroundColor = UIColor(white: 0.4, alpha: 0.8)
    }
    func settingPickerViewYearList() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let thisyear = Int(dateFormatter.string(from: Date())) ?? 1970
        for year in thisyear-20 ... thisyear+20 {
            calendarYearList.append("\(year)년")
        }
    }
    
    @IBAction func dismissSelectView(_ sender: UIButton) {
        let result = "\(calendarYearList[calendarDatePicker.selectedRow(inComponent: 0)]) \(calendarMonthList[calendarDatePicker.selectedRow(inComponent: 1)])"
        self.selectedDate = result
        self.performSegue(withIdentifier: "toCalendarFromSelectDate", sender: self)
    }
}

extension SelectDateController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return calendarYearList.count
        default:
            return calendarMonthList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return calendarYearList[row]
        default:
            return calendarMonthList[row]
        }
    }
    
}
