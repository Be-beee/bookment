//
//  BookInfo.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/05/29.
//  Copyright © 2022 서보경. All rights reserved.
//

import UIKit
import RealmSwift

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
    func changeToBookItem() -> BookInfoResponseDTO {
        return BookInfoResponseDTO(title: self.title, link: self.link, image: self.image, author: self.author, price: self.price, publisher: self.publisher, isbn: self.isbn, description: self.descriptionText, pubdate: self.pubdate)
    }
}
