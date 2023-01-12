//
//  BookInfoResponseDTO.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/05/29.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation


struct BookInfoResponseDTO: Codable, Hashable {
    var title: String = ""
    var link: String = ""
    var image: String = ""
    var author: String = ""
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
    
    func changeToBookInfo() -> BookInfoLocalDTO {
        return BookInfoLocalDTO(title: self.title, link: self.link, image: self.image, author: self.author, price: self.discount, publisher: self.publisher, isbn: self.isbn, descriptionText: self.description, pubdate: self.pubdate)
    }
}
