//
//  MainSearchViewModelDelegate.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/24.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

protocol MainSearchViewModelDelegate: AnyObject {
    func searchResultDidChange()
    func searchResultLoadFailed()
}
