//
//  CommonCellViewModelDelegate.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/18.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

protocol CommonCellViewModelDelegate: AnyObject {
    func bookInfoDidChange()
    func commonCellModeDidChange()
}
