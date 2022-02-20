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
    
    func changeToBookInfo() -> BookInfo {
        return BookInfo(title: self.title, link: self.link, image: self.image, author: self.author, price: self.price, publisher: self.publisher, isbn: self.isbn, descriptionText: self.description, pubdate: self.pubdate)
    }
}

class BookInfo: Object, Codable {
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var publisher: String = ""
    @objc dynamic var isbn: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var pubdate: String = ""
    
    convenience init(title: String, link: String, image: String, author: String, price: String, publisher: String, isbn: String, descriptionText: String, pubdate: String) {
        self.init()
        self.title = title
        self.link = link
        self.image = image
        self.author = author
        self.price = price
        self.publisher = publisher
        self.isbn = isbn
        self.descriptionText = descriptionText
        self.pubdate = pubdate
    }
    
    func modifySearchedData() {
        let title = self.title.removeHTMLTag()
        let author = self.author.removeHTMLTag()
        
        self.title = title
        self.author = author
    }
    func changeToBookItem() -> BookItem {
        return BookItem(title: self.title, link: self.link, image: self.image, author: self.author, price: self.price, publisher: self.publisher, isbn: self.isbn, description: self.descriptionText, pubdate: self.pubdate)
    }
}

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

class HeartContent: Object {
    @objc dynamic var isbn: String = ""
    @objc dynamic var date: Date = Date()
    
    convenience init(isbn: String, date: Date) {
        self.init()
        self.isbn = isbn
        self.date = date
    }
}


extension Date {
    func dateToString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        return df.string(from: self)
    }
}
