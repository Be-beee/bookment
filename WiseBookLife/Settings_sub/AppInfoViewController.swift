//
//  AppInfoViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/25.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = Theme.main.mainColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // navigation bar bottom line 삭제하기
        self.navigationItem.title = "애플리케이션 정보"
    }

}
