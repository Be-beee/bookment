//
//  UIViewController+PresentAlert.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/25.
//  Copyright © 2022 서보경. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(with message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentNoticeAlert(with message: String) {
        presentAlert(with: message, handler: nil)
    }
}
