//
//  RecordViewModelDelegate.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/13.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

protocol RecordViewModelDelegate: AnyObject {
    func recordsDidChange()
}
