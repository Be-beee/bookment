//
//  NSObject+LoadViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/26.
//  Copyright © 2022 서보경. All rights reserved.
//

import UIKit

extension NSObject {
    func loadViewController(
        with id: String,
        presentStyle: UIModalPresentationStyle = .fullScreen
    ) -> UIViewController {
        let viewController = UIStoryboard(name: id, bundle: nil).instantiateViewController(withIdentifier: id)
        viewController.modalPresentationStyle = presentStyle
        
        return viewController
    }
}
