//
//  BookInfoResponseDTO.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/05/29.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation


struct BookInfoResponseDTO: Codable, Hashable {
    
    // MARK: - Properties
    
    var title: String = ""
    var link: String = ""
    var image: String = ""
    var author: String = ""
    var discount: String = ""
    var publisher: String = ""
    var isbn: String = ""
    var description: String = ""
    var pubdate: String = ""
    
    // MARK: - Entity Functions
    
    func entity() -> BookInfo {
        return BookInfo(
            title: title, link: link, image: image,
            author: author, price: discount, publisher: publisher,
            isbn: isbn, description: description, pubdate: pubdate
        )
    }
}
