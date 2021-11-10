//
//  ShowLicenseController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/11/11.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class ShowLicenseController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = Theme.main.mainColor
        self.removeNavigationBarLine()
        self.navigationItem.title = "오픈소스 라이선스 정보"
    }
}
