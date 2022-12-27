//
//  NSObject+Name.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/25.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

extension NSObject {
    static var name: String {
        return String(describing: self)
    }
}
