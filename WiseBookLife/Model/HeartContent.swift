//
//  HeartContent.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/05/29.
//  Copyright © 2022 서보경. All rights reserved.
//

import UIKit
import RealmSwift

class HeartContent: Object {
    @objc dynamic var isbn: String = ""
    @objc dynamic var date: Date = Date()
    
    convenience init(isbn: String, date: Date) {
        self.init()
        self.isbn = isbn
        self.date = date
    }
}
