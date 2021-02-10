//
//  AddCalendarBookController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/11.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class AddCalendarBookController: UIViewController {
    @IBOutlet weak var resultView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
    }
}

extension AddCalendarBookController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension AddCalendarBookController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultView.dequeueReusableCell(withIdentifier: "commonCell") as? CommonCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}
