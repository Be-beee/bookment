//
//  Model.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/22.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class KeywordModel {
    var keywordTitle: String
    var kind: String // Title, Author
    var content: String // 내용, kind로 content의 종류를 구별한다
    
    init(keywordTitle: String, kind: String, content: String) {
        self.keywordTitle = keywordTitle
        self.kind = kind
        self.content = content
    }
}

class RecordModel {
    var bookData: SeojiData
    var recordTitle: String
    var date: String // yyyy-MM-dd
    var recordContents: String
    
    init() {
        let voidData = SeojiData()
        bookData = voidData
        recordTitle = "None"
        date = "yyyy.MM.dd"
        recordContents = "None"
        
    }
    
    init(bookData: SeojiData, recordTitle: String, date: String, recordContents: String) {
        self.bookData = bookData
        self.recordTitle = recordTitle
        self.date = date
        self.recordContents = recordContents
    }
    
}

// 도서 정보(ISBN, 도서이미지, 도서명, 저자, 역자?, 출간일), 기록 제목, 작성일, 내용, 공감 글귀?

// 검색 결과 모델도 만들어야 할듯(BookDataModel에 살만 붙이면 될 것 같다)


struct SeojiData: Codable {
    var TITLE: String
    var VOL: String
    var SERIES_TITLE: String
    var SERIES_NO: String
    var AUTHOR: String
    var EA_ISBN: String
    var EA_ADD_CODE: String
    var SET_ISBN: String
    var SET_ADD_CODE: String
    var SET_EXPRESSION: String
    var PUBLISHER: String
    var EDITION_STMT: String
    var PRE_PRICE: String
    var KDC: String
    var DDC: String
    var PAGE: String
    var BOOK_SIZE: String
    var FORM: String
    var PUBLISH_PREDATE: String
    var SUBJECT: String
    var EBOOK_YN: String
    var CIP_YN: String
    var CONTROL_NO: String
    var TITLE_URL: String
    var BOOK_TB_CNT_URL: String
    var BOOK_INTRODUCTION_URL: String
    var BOOK_SUMMARY_URL: String
    var PUBLISHER_URL: String
    var INPUT_DATE: String
    var UPDATE_DATE: String
    
    
    init() {
        TITLE = "NO_TITLE"
        VOL = ""
        SERIES_TITLE = ""
        SERIES_NO = ""
        AUTHOR = ""
        EA_ISBN = ""
        EA_ADD_CODE = ""
        SET_ISBN = ""
        SET_ADD_CODE = ""
        SET_EXPRESSION = ""
        PUBLISHER = ""
        EDITION_STMT = ""
        PRE_PRICE = ""
        KDC = ""
        DDC = ""
        PAGE = ""
        BOOK_SIZE = ""
        FORM = ""
        PUBLISH_PREDATE = ""
        SUBJECT = ""
        EBOOK_YN = ""
        CIP_YN = ""
        CONTROL_NO = ""
        TITLE_URL = ""
        BOOK_TB_CNT_URL = ""
        BOOK_INTRODUCTION_URL = ""
        BOOK_SUMMARY_URL = ""
        PUBLISHER_URL = ""
        INPUT_DATE = ""
        UPDATE_DATE = ""
    }
    
    init(TITLE: String, VOL: String, SERIES_TITLE: String, SERIES_NO: String, AUTHOR: String, EA_ISBN: String, EA_ADD_CODE: String, SET_ISBN: String, SET_ADD_CODE: String, SET_EXPRESSION: String, PUBLISHER: String, EDITION_STMT: String, PRE_PRICE: String, KDC: String, DDC: String, PAGE: String, BOOK_SIZE: String, FORM: String, PUBLISH_PREDATE: String, SUBJECT: String, EBOOK_YN: String, CIP_YN: String, CONTROL_NO: String, TITLE_URL: String, BOOK_TB_CNT_URL: String, BOOK_INTRODUCTION_URL: String, BOOK_SUMMARY_URL: String, PUBLISHER_URL: String, INPUT_DATE: String, UPDATE_DATE: String) {
        self.TITLE = TITLE
        self.VOL = VOL
        self.SERIES_TITLE = SERIES_TITLE
        self.SERIES_NO = SERIES_NO
        self.AUTHOR = AUTHOR
        self.EA_ISBN = EA_ISBN
        self.EA_ADD_CODE = EA_ADD_CODE
        self.SET_ISBN = SET_ISBN
        self.SET_ADD_CODE = SET_ADD_CODE
        self.SET_EXPRESSION = SET_EXPRESSION
        self.PUBLISHER = PUBLISHER
        self.EDITION_STMT = EDITION_STMT
        self.PRE_PRICE = PRE_PRICE
        self.KDC = KDC
        self.DDC = DDC
        self.PAGE = PAGE
        self.BOOK_SIZE = BOOK_SIZE
        self.FORM = FORM
        self.PUBLISH_PREDATE = PUBLISH_PREDATE
        self.SUBJECT = SUBJECT
        self.EBOOK_YN = EBOOK_YN
        self.CIP_YN = CIP_YN
        self.CONTROL_NO = CONTROL_NO
        self.TITLE_URL = TITLE_URL
        self.BOOK_TB_CNT_URL = BOOK_TB_CNT_URL
        self.BOOK_INTRODUCTION_URL = BOOK_INTRODUCTION_URL
        self.BOOK_SUMMARY_URL = BOOK_SUMMARY_URL
        self.PUBLISHER_URL = PUBLISHER_URL
        self.INPUT_DATE = INPUT_DATE
        self.UPDATE_DATE = UPDATE_DATE
    }
    
}

struct SearchData: Codable {
    let PAGE_NO: String
    let TOTAL_COUNT: String
    let docs: [SeojiData]
    
}

extension Dictionary {
    var queryString: String {
        var output = ""
        for (key, value) in self {
            output += "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        
        return output
    }
    
    
    
}

extension UIViewController {
    func urlToImage(from url: String) -> UIImage? {
        if let url = URL(string: url) {
            if let imgData = try? Data(contentsOf: url) {
                return UIImage(data: imgData)
            } else {
                return UIImage(named: "No_Img.png")
            }
        } else {
            return UIImage(named: "No_Img.png")
        }
    }
}

var heartDic: [String: SeojiData] = [:]
