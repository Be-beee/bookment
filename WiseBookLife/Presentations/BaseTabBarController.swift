//
//  MainTabBarController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/08/16.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarBackground()
    }
    
    func setTabBarBackground() {
        self.tabBar.barTintColor = .systemBackground
//        self.tabBar.isTranslucent = false
    }

}
