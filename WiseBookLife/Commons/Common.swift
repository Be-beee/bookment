//
//  Model.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/22.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit
import RealmSwift

struct BookItem: Codable, Hashable {
    var title: String = ""
    var link: String = ""
    var image: String = ""
    var author: String = ""
    var price: String = ""
    var discount: String = ""
    var publisher: String = ""
    var isbn: String = ""
    var description: String = ""
    var pubdate: String = ""
    
    mutating func modifySearchedData() {
        let title = self.title.removeHTMLTag()
        let author = self.author.removeHTMLTag()
        
        self.title = title
        self.author = author
    }
}

class BookInfo: Object, Codable {
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var price: String = ""
//    @objc dynamic var discount: String = ""
    @objc dynamic var publisher: String = ""
    @objc dynamic var isbn: String = ""
    @objc dynamic var descriptionBook: String = ""
    @objc dynamic var pubdate: String = ""
    
    func modifySearchedData() {
        let title = self.title.removeHTMLTag()
        let author = self.author.removeHTMLTag()
        
        self.title = title
        self.author = author
    }
}

class RecordContent: Object {
    @objc dynamic var isbn: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var text: String = ""
}


extension Date {
    func dateToString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        return df.string(from: self)
    }
}
