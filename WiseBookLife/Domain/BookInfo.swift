//
//  BookInfo.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/12.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

struct BookInfo {
    
    // MARK: - Properties
    
    private(set) var title: String = ""
    private(set) var link: String = ""
    private(set) var image: String = ""
    private(set) var author: String = ""
    private(set) var price: String = ""
    private(set) var publisher: String = ""
    private(set) var isbn: String = ""
    private(set) var description: String = ""
    private(set) var pubdate: String = ""
    
    // MARK: - Computed Properties
    
    var dto: BookInfoLocalDTO {
        return BookInfoLocalDTO(
            title: title, link: link, image: image,
            author: author, price: price, publisher: publisher,
            isbn: isbn, descriptionText: description, pubdate: pubdate
        )
    }
    
    // MARK: - Tag Functions
    
    mutating func modifySearchedData() {
        let title = self.title.removeHTMLTag()
        let author = self.author.removeHTMLTag()
        
        self.title = title
        self.author = author
    }
    
    
}
