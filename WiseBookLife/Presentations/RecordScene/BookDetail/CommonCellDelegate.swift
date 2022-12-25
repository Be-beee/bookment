//
//  CommonCellDelegate.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/26.
//  Copyright © 2022 서보경. All rights reserved.
//

import UIKit

protocol CommonCellDelegate: AnyObject {
    func heartButtonDidTouch()
}

extension CommonCellDelegate {
    func heartButtonDidTouch() {}
    func addBookButtonDidTouched(destinationView: UIViewController) {}
}
