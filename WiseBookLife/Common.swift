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

class RecordModel: NSObject, NSCoding, NSSecureCoding {
    func encode(with coder: NSCoder) {
        coder.encode(bookData, forKey: "bookData")
        coder.encode(recordTitle, forKey: "recordTitle")
        coder.encode(date, forKey: "date")
        coder.encode(recordContents, forKey: "recordContents")
    }
    
    required convenience init?(coder: NSCoder) {
        let bookData = coder.decodeObject(forKey: "bookData") as! SeojiData
        let recordTitle = coder.decodeObject(forKey: "recordTitle") as! String
        let date = coder.decodeObject(forKey: "date") as! String
        let recordContents = coder.decodeObject(forKey: "recordContents") as! String
        
        self.init(bookData: bookData, recordTitle: recordTitle, date: date, recordContents: recordContents)
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var bookData: SeojiData
    var recordTitle: String
    var date: String // yyyy-MM-dd
    var recordContents: String
    
    override init() {
        let voidData = SeojiData()
        bookData = voidData
        recordTitle = ""
        date = "yyyy.MM.dd"
        recordContents = ""
        
    }
    
    init(bookData: SeojiData, recordTitle: String, date: String, recordContents: String) {
        self.bookData = bookData
        self.recordTitle = recordTitle
        self.date = date
        self.recordContents = recordContents
    }
    
}

class SeojiData: NSObject, Codable, NSCoding, NSSecureCoding{
    static var supportsSecureCoding: Bool {
        return true
    }

    func encode(with coder: NSCoder) {
        coder.encode(TITLE, forKey: "TITLE")
        coder.encode(VOL, forKey: "VOL")
        coder.encode(SERIES_TITLE, forKey: "SERIES_TITLE")
        coder.encode(AUTHOR, forKey: "AUTHOR")
        coder.encode(EA_ISBN, forKey: "EA_ISBN")
        coder.encode(EA_ADD_CODE, forKey: "EA_ADD_CODE")
        coder.encode(SET_ISBN, forKey: "SET_ISBN")
        coder.encode(SET_ADD_CODE, forKey: "SET_ADD_CODE")
        coder.encode(SET_EXPRESSION, forKey: "SET_EXPRESSION")
        coder.encode(PUBLISHER, forKey: "PUBLISHER")
        coder.encode(PRE_PRICE, forKey: "PRE_PRICE")
        coder.encode(PAGE, forKey: "PAGE")
        coder.encode(BOOK_SIZE, forKey: "BOOK_SIZE")
        coder.encode(FORM, forKey: "FORM")
        coder.encode(PUBLISH_PREDATE, forKey: "PUBLISH_PREDATE")
        coder.encode(EBOOK_YN, forKey: "EBOOK_YN")
        coder.encode(TITLE_URL, forKey: "TITLE_URL")
        coder.encode(BOOK_TB_CNT_URL, forKey: "BOOK_TB_CNT_URL")
        coder.encode(BOOK_INTRODUCTION_URL, forKey: "BOOK_INTRODUCTION_URL")
        coder.encode(BOOK_SUMMARY_URL, forKey: "BOOK_SUMMARY_URL")
    }

    required convenience init?(coder: NSCoder) {
        let TITLE = coder.decodeObject(forKey: "TITLE") as! String
        let VOL = coder.decodeObject(forKey: "VOL") as! String
        let SERIES_TITLE = coder.decodeObject(forKey: "SERIES_TITLE") as! String
        let AUTHOR = coder.decodeObject(forKey: "AUTHOR") as! String
        let EA_ISBN = coder.decodeObject(forKey: "EA_ISBN") as! String
        let EA_ADD_CODE = coder.decodeObject(forKey: "EA_ADD_CODE") as! String
        let SET_ISBN = coder.decodeObject(forKey: "SET_ISBN") as! String
        let SET_ADD_CODE = coder.decodeObject(forKey: "SET_ADD_CODE") as! String
        let SET_EXPRESSION = coder.decodeObject(forKey: "SET_EXPRESSION") as! String
        let PUBLISHER = coder.decodeObject(forKey: "PUBLISHER") as! String
        let PRE_PRICE = coder.decodeObject(forKey: "PRE_PRICE") as! String
        let PAGE = coder.decodeObject(forKey: "PAGE") as! String
        let BOOK_SIZE = coder.decodeObject(forKey: "BOOK_SIZE") as! String
        let FORM = coder.decodeObject(forKey: "FORM") as! String
        let PUBLISH_PREDATE = coder.decodeObject(forKey: "PUBLISH_PREDATE") as! String
        let EBOOK_YN = coder.decodeObject(forKey: "EBOOK_YN") as! String
        let TITLE_URL = coder.decodeObject(forKey: "TITLE_URL") as! String
        let BOOK_TB_CNT_URL = coder.decodeObject(forKey: "BOOK_TB_CNT_URL") as! String
        let BOOK_INTRODUCTION_URL = coder.decodeObject(forKey: "BOOK_INTRODUCTION_URL") as! String
        let BOOK_SUMMARY_URL = coder.decodeObject(forKey: "BOOK_SUMMARY_URL") as! String
        
        self.init(TITLE: TITLE, VOL: VOL, SERIES_TITLE: SERIES_TITLE, AUTHOR: AUTHOR, EA_ISBN: EA_ISBN, EA_ADD_CODE: EA_ADD_CODE, SET_ISBN: SET_ISBN, SET_ADD_CODE: SET_ADD_CODE, SET_EXPRESSION: SET_EXPRESSION, PUBLISHER: PUBLISHER, PRE_PRICE: PRE_PRICE, PAGE: PAGE, BOOK_SIZE: BOOK_SIZE, FORM: FORM, PUBLISH_PREDATE: PUBLISH_PREDATE, EBOOK_YN: EBOOK_YN, TITLE_URL: TITLE_URL, BOOK_TB_CNT_URL: BOOK_TB_CNT_URL, BOOK_INTRODUCTION_URL: BOOK_INTRODUCTION_URL, BOOK_SUMMARY_URL: BOOK_SUMMARY_URL)
    }
    
    var TITLE: String
    var VOL: String
    var SERIES_TITLE: String
    var AUTHOR: String
    var EA_ISBN: String
    var EA_ADD_CODE: String
    var SET_ISBN: String
    var SET_ADD_CODE: String
    var SET_EXPRESSION: String
    var PUBLISHER: String
    var PRE_PRICE: String
    var PAGE: String
    var BOOK_SIZE: String
    var FORM: String
    var PUBLISH_PREDATE: String
    var EBOOK_YN: String
    var TITLE_URL: String
    var BOOK_TB_CNT_URL: String
    var BOOK_INTRODUCTION_URL: String
    var BOOK_SUMMARY_URL: String
    
    override init() {
        TITLE = "NO_TITLE"
        VOL = ""
        SERIES_TITLE = ""
        AUTHOR = ""
        EA_ISBN = ""
        EA_ADD_CODE = ""
        SET_ISBN = ""
        SET_ADD_CODE = ""
        SET_EXPRESSION = ""
        PUBLISHER = ""
        PRE_PRICE = ""
        PAGE = ""
        BOOK_SIZE = ""
        FORM = ""
        PUBLISH_PREDATE = ""
        EBOOK_YN = ""
        TITLE_URL = ""
        BOOK_TB_CNT_URL = ""
        BOOK_INTRODUCTION_URL = ""
        BOOK_SUMMARY_URL = ""
    }
    
    init(TITLE: String, VOL: String, SERIES_TITLE: String, AUTHOR: String, EA_ISBN: String, EA_ADD_CODE: String, SET_ISBN: String, SET_ADD_CODE: String, SET_EXPRESSION: String, PUBLISHER: String, PRE_PRICE: String, PAGE: String, BOOK_SIZE: String, FORM: String, PUBLISH_PREDATE: String, EBOOK_YN: String, TITLE_URL: String, BOOK_TB_CNT_URL: String, BOOK_INTRODUCTION_URL: String, BOOK_SUMMARY_URL: String) {
        self.TITLE = TITLE
        self.VOL = VOL
        self.SERIES_TITLE = SERIES_TITLE
        self.AUTHOR = AUTHOR
        self.EA_ISBN = EA_ISBN
        self.EA_ADD_CODE = EA_ADD_CODE
        self.SET_ISBN = SET_ISBN
        self.SET_ADD_CODE = SET_ADD_CODE
        self.SET_EXPRESSION = SET_EXPRESSION
        self.PUBLISHER = PUBLISHER
        self.PRE_PRICE = PRE_PRICE
        self.PAGE = PAGE
        self.BOOK_SIZE = BOOK_SIZE
        self.FORM = FORM
        self.PUBLISH_PREDATE = PUBLISH_PREDATE
        self.EBOOK_YN = EBOOK_YN
        self.TITLE_URL = TITLE_URL
        self.BOOK_TB_CNT_URL = BOOK_TB_CNT_URL
        self.BOOK_INTRODUCTION_URL = BOOK_INTRODUCTION_URL
        self.BOOK_SUMMARY_URL = BOOK_SUMMARY_URL
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

class SearchBook {
    var results: [SeojiData] = []
    
    func callAPI(page_no: Int, page_size: Int, additional_param: [String:String], completion: @escaping (() -> Void)) {
        let seojiURL = "http://seoji.nl.go.kr/landingPage/SearchApi.do"
        var mustParam: [String:String] = [
            "cert_key" : "5d01bbea58ffb91aeff99991a691eae9687af5bf7bece6abe67f6058cbaf364c",
            "result_style" : "json",
            "page_no" : String(page_no),
            "page_size" : String(page_size)
        ]
        for (key, value) in additional_param {
            mustParam.updateValue(value, forKey: key)
        }
        // query
        
        var urlComponents = URLComponents(string: seojiURL)
        urlComponents?.query = mustParam.queryString
        
        guard let hasURL = urlComponents?.url else {
            return
        }
        
        
        URLSession.shared.dataTask(with: hasURL) { (data, response, error) in
            guard let data = data else{
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(SearchData.self, from: data)
                self.results = user.docs
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch {
                // error 처리
                print("error ==> \(error)")
            }
        }.resume()
            
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


// MARK:- Heart List Dictionary

var heartDic: [String: SeojiData] = [:]

func saveHeartList() {
    DispatchQueue.global().async {
        let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        guard let archivedURL = documentDirectory?.appendingPathComponent("heart") else {
            return
        }
        
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: heartDic, requiringSecureCoding: true)
            try archivedData.write(to: archivedURL)
        } catch {
            print(error)
        }
    }
}

func loadHeartList() -> [String: SeojiData]? {
    let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    
    guard let archiveURL = documentDirectory?.appendingPathComponent("heart") else {
        return nil
    }
    
    guard let codedData = try? Data(contentsOf: archiveURL) else {
        return nil
    }
    
    guard let unarchivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) else {
        return nil
    }
    
    return unarchivedData as? [String: SeojiData]
}


// MARK:- Bell List Dictionary

var bellDic: [String: String] = [:]
// ISBN: Title

func saveBellList() {
    DispatchQueue.global().async {
        let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        guard let archivedURL = documentDirectory?.appendingPathComponent("bell") else {
            return
        }
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: bellDic, requiringSecureCoding: true)
            try archivedData.write(to: archivedURL)
        } catch {
            print(error)
        }
    }
}

func loadBellList() -> [String: String]? {
    let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    
    guard let archiveURL = documentDirectory?.appendingPathComponent("bell") else {
        return nil
    }
    
    guard let codedData = try? Data(contentsOf: archiveURL) else {
        return nil
    }
    
    guard let unarchivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) else {
        return nil
    }
    
    return unarchivedData as? [String: String]
}
