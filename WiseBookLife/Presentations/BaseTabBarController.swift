//
//  MainTabBarController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/08/16.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

final class BaseTabBarController: UITabBarController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
    
    // MARK: - Configure Functions
    
    private func configureTabBar() {
        self.tabBar.barTintColor = .systemBackground
    }

}
