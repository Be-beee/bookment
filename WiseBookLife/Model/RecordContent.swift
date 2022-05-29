//
//  RecordContent.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/05/29.
//  Copyright © 2022 서보경. All rights reserved.
//

import UIKit
import RealmSwift

class RecordContent: Object {
    @objc dynamic var isbn: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var text: String = ""
    
    convenience init(isbn: String, date: Date, text: String) {
        self.init()
        
        self.isbn = isbn
        self.date = date
        self.text = text
    }
}
