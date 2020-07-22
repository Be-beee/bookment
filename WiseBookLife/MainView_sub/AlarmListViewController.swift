//
//  AlarmListViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class AlarmListViewController: UIViewController {

    var pastAlarmList: [KeywordModel] = []
    @IBOutlet var alarmListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "지난 알림 🔔"
        // keywordmodel의 kind에 따라 알림을 다르게 표시한다.
        // kind - author : "작가의 신작이 출간되었습니다!"
        // kind - title : "~가 출간되었습니다!"
        // 출간 알림을 어떻게 줄 것인가?
        // Push Notification - APNs
        
        
    }
    
    

}


extension AlarmListViewController: UITableViewDelegate { }

extension AlarmListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastAlarmList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alarmListView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! AlarmCell
        
        
        return cell
    }
    
    
}
