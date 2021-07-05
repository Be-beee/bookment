//
//  UI_Extensions.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/07/05.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

extension UIViewController {
    func removeNavigationBarLine() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // navigation bottom line 없애기
    }
}
