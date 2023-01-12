//
//  BookInfo.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/05/29.
//  Copyright © 2022 서보경. All rights reserved.
//

import UIKit

import RealmSwift

class BookInfoLocalDTO: Object, Codable {
    
    // MARK: - Properties
    
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var publisher: String = ""
    @objc dynamic var isbn: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var pubdate: String = ""
    
    // MARK: - Init(s)
    
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
    
    // MARK: - Entity Function
    
    func entity() -> BookInfo {
        return BookInfo(
            title: title, link: link, image: image,
            author: author, price: price,
            publisher: publisher, isbn: isbn,
            description: descriptionText, pubdate: pubdate
        )
    }
    
}
