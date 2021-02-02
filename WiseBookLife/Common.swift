//
//  Model.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/22.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

struct ClientData: Codable {
    var requestURL: String
    var requestHeader: [String: String]
    init() {
        guard let path = Bundle.main.path(forResource: "ApplicationInfo", ofType: "plist") else {
            requestURL = "None"
            requestHeader = [:]
            return
        }
        guard let xml = FileManager.default.contents(atPath: path) else {
            requestURL = "None"
            requestHeader = [:]
            return
        }
        guard let data = try? PropertyListDecoder().decode(ClientData.self, from: xml) else {
            requestURL = "None"
            requestHeader = [:]
            return
        }
        
        requestURL = data.requestURL
        requestHeader = data.requestHeader
    }
}

struct RequestParam {
    var query: String
    var display: Int?
    var start: Int?
    var sort: String?
    // 이후 상세 검색 시 필요한 요청 쿼리
}

struct ResultModel: Codable {
    var total: String = ""
    var start: String = ""
    var display: String = ""
    var items: [BookItem] = []
}

struct BookItem: Codable {
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
}
// 이전 seojidata에서 사용하던 데이터: title, author, publish date, publisher, preprice, isbn, ebook_yn, 책소개, 책요약, 목차

struct Record: Codable {
    var bookData: BookItem = BookItem()
    var recTitle: String = ""
    var date: Date = Date()
    var recordContents: String = ""
    
    
}

extension Date {
    func dateToString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        return df.string(from: self)
    }
}

/*
 *
 *
 객체 변경 중~
 *
 *
 */

//class RecordModel: NSObject, NSCoding, NSSecureCoding {
//    func encode(with coder: NSCoder) {
//        coder.encode(bookData, forKey: "bookData")
//        coder.encode(recordTitle, forKey: "recordTitle")
//        coder.encode(date, forKey: "date")
//        coder.encode(recordContents, forKey: "recordContents")
//    }
//
//    required convenience init?(coder: NSCoder) {
//        let bookData = coder.decodeObject(forKey: "bookData") as! SeojiData
//        let recordTitle = coder.decodeObject(forKey: "recordTitle") as! String
//        let date = coder.decodeObject(forKey: "date") as! String
//        let recordContents = coder.decodeObject(forKey: "recordContents") as! String
//
//        self.init(bookData: bookData, recordTitle: recordTitle, date: date, recordContents: recordContents)
//    }
//
//    static var supportsSecureCoding: Bool {
//        return true
//    }
//
//    var bookData: SeojiData
//    var recordTitle: String
//    var date: String // yyyy-MM-dd
//    var recordContents: String
//
//    override init() {
//        let voidData = SeojiData()
//        bookData = voidData
//        recordTitle = ""
//        date = "yyyy.MM.dd"
//        recordContents = ""
//
//    }
//
//    init(bookData: SeojiData, recordTitle: String, date: String, recordContents: String) {
//        self.bookData = bookData
//        self.recordTitle = recordTitle
//        self.date = date
//        self.recordContents = recordContents
//    }
//
//}

//class SeojiData: NSObject, Codable, NSCoding, NSSecureCoding{
//    static var supportsSecureCoding: Bool {
//        return true
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(TITLE, forKey: "TITLE")
//        coder.encode(VOL, forKey: "VOL")
//        coder.encode(SERIES_TITLE, forKey: "SERIES_TITLE")
//        coder.encode(AUTHOR, forKey: "AUTHOR")
//        coder.encode(EA_ISBN, forKey: "EA_ISBN")
//        coder.encode(EA_ADD_CODE, forKey: "EA_ADD_CODE")
//        coder.encode(SET_ISBN, forKey: "SET_ISBN")
//        coder.encode(SET_ADD_CODE, forKey: "SET_ADD_CODE")
//        coder.encode(SET_EXPRESSION, forKey: "SET_EXPRESSION")
//        coder.encode(PUBLISHER, forKey: "PUBLISHER")
//        coder.encode(PRE_PRICE, forKey: "PRE_PRICE")
//        coder.encode(PUBLISH_PREDATE, forKey: "PUBLISH_PREDATE")
//        coder.encode(EBOOK_YN, forKey: "EBOOK_YN")
//        coder.encode(TITLE_URL, forKey: "TITLE_URL")
//        coder.encode(BOOK_TB_CNT_URL, forKey: "BOOK_TB_CNT_URL")
//        coder.encode(BOOK_INTRODUCTION_URL, forKey: "BOOK_INTRODUCTION_URL")
//        coder.encode(BOOK_SUMMARY_URL, forKey: "BOOK_SUMMARY_URL")
//    }
//
//    required convenience init?(coder: NSCoder) {
//        let TITLE = coder.decodeObject(forKey: "TITLE") as! String
//        let VOL = coder.decodeObject(forKey: "VOL") as! String
//        let SERIES_TITLE = coder.decodeObject(forKey: "SERIES_TITLE") as! String
//        let AUTHOR = coder.decodeObject(forKey: "AUTHOR") as! String
//        let EA_ISBN = coder.decodeObject(forKey: "EA_ISBN") as! String
//        let EA_ADD_CODE = coder.decodeObject(forKey: "EA_ADD_CODE") as! String
//        let SET_ISBN = coder.decodeObject(forKey: "SET_ISBN") as! String
//        let SET_ADD_CODE = coder.decodeObject(forKey: "SET_ADD_CODE") as! String
//        let SET_EXPRESSION = coder.decodeObject(forKey: "SET_EXPRESSION") as! String
//        let PUBLISHER = coder.decodeObject(forKey: "PUBLISHER") as! String
//        let PRE_PRICE = coder.decodeObject(forKey: "PRE_PRICE") as! String
//        let PUBLISH_PREDATE = coder.decodeObject(forKey: "PUBLISH_PREDATE") as! String
//        let EBOOK_YN = coder.decodeObject(forKey: "EBOOK_YN") as! String
//        let TITLE_URL = coder.decodeObject(forKey: "TITLE_URL") as! String
//        let BOOK_TB_CNT_URL = coder.decodeObject(forKey: "BOOK_TB_CNT_URL") as! String
//        let BOOK_INTRODUCTION_URL = coder.decodeObject(forKey: "BOOK_INTRODUCTION_URL") as! String
//        let BOOK_SUMMARY_URL = coder.decodeObject(forKey: "BOOK_SUMMARY_URL") as! String
//
//        self.init(TITLE: TITLE, VOL: VOL, SERIES_TITLE: SERIES_TITLE, AUTHOR: AUTHOR, EA_ISBN: EA_ISBN, EA_ADD_CODE: EA_ADD_CODE, SET_ISBN: SET_ISBN, SET_ADD_CODE: SET_ADD_CODE, SET_EXPRESSION: SET_EXPRESSION, PUBLISHER: PUBLISHER, PRE_PRICE: PRE_PRICE, PUBLISH_PREDATE: PUBLISH_PREDATE, EBOOK_YN: EBOOK_YN, TITLE_URL: TITLE_URL, BOOK_TB_CNT_URL: BOOK_TB_CNT_URL, BOOK_INTRODUCTION_URL: BOOK_INTRODUCTION_URL, BOOK_SUMMARY_URL: BOOK_SUMMARY_URL)
//    }
//
//    var TITLE: String
//    var VOL: String
//    var SERIES_TITLE: String
//    var AUTHOR: String
//    var EA_ISBN: String
//    var EA_ADD_CODE: String
//    var SET_ISBN: String
//    var SET_ADD_CODE: String
//    var SET_EXPRESSION: String
//    var PUBLISHER: String
//    var PRE_PRICE: String
//    var PUBLISH_PREDATE: String
//    var EBOOK_YN: String
//    var TITLE_URL: String
//    var BOOK_TB_CNT_URL: String // 목차
//    var BOOK_INTRODUCTION_URL: String
//    var BOOK_SUMMARY_URL: String
//
//    override init() {
//        TITLE = "NO_TITLE"
//        VOL = ""
//        SERIES_TITLE = ""
//        AUTHOR = ""
//        EA_ISBN = ""
//        EA_ADD_CODE = ""
//        SET_ISBN = ""
//        SET_ADD_CODE = ""
//        SET_EXPRESSION = ""
//        PUBLISHER = ""
//        PRE_PRICE = ""
//        PUBLISH_PREDATE = ""
//        EBOOK_YN = ""
//        TITLE_URL = ""
//        BOOK_TB_CNT_URL = ""
//        BOOK_INTRODUCTION_URL = ""
//        BOOK_SUMMARY_URL = ""
//    }
//
//    init(TITLE: String, VOL: String, SERIES_TITLE: String, AUTHOR: String, EA_ISBN: String, EA_ADD_CODE: String, SET_ISBN: String, SET_ADD_CODE: String, SET_EXPRESSION: String, PUBLISHER: String, PRE_PRICE: String, PUBLISH_PREDATE: String, EBOOK_YN: String, TITLE_URL: String, BOOK_TB_CNT_URL: String, BOOK_INTRODUCTION_URL: String, BOOK_SUMMARY_URL: String) {
//        self.TITLE = TITLE
//        self.VOL = VOL
//        self.SERIES_TITLE = SERIES_TITLE
//        self.AUTHOR = AUTHOR
//        self.EA_ISBN = EA_ISBN
//        self.EA_ADD_CODE = EA_ADD_CODE
//        self.SET_ISBN = SET_ISBN
//        self.SET_ADD_CODE = SET_ADD_CODE
//        self.SET_EXPRESSION = SET_EXPRESSION
//        self.PUBLISHER = PUBLISHER
//        self.PRE_PRICE = PRE_PRICE
//        self.PUBLISH_PREDATE = PUBLISH_PREDATE
//        self.EBOOK_YN = EBOOK_YN
//        self.TITLE_URL = TITLE_URL
//        self.BOOK_TB_CNT_URL = BOOK_TB_CNT_URL
//        self.BOOK_INTRODUCTION_URL = BOOK_INTRODUCTION_URL
//        self.BOOK_SUMMARY_URL = BOOK_SUMMARY_URL
//    }
//
//}

//struct SearchData: Codable {
//    let PAGE_NO: String
//    let TOTAL_COUNT: String
//    let docs: [SeojiData]
//
//}

class SearchConditionModel: NSObject, NSCoding, NSSecureCoding {
    func encode(with coder: NSCoder) {
        coder.encode(conditionTitle, forKey: "conditionTitle")
        coder.encode(title, forKey: "title")
        coder.encode(author, forKey: "author")
        coder.encode(publisher, forKey: "publisher")
        coder.encode(isbn, forKey: "isbn")
        coder.encode(startDate, forKey: "startDate")
        coder.encode(endDate, forKey: "endDate")
    }
    
    required convenience init?(coder: NSCoder) {
        let conditionTitle = coder.decodeObject(forKey: "conditionTitle") as! String
        let title = coder.decodeObject(forKey: "title") as! String
        let author = coder.decodeObject(forKey: "author") as! String
        let publisher = coder.decodeObject(forKey: "publisher") as! String
        let isbn = coder.decodeObject(forKey: "isbn") as! String
        let startDate = coder.decodeObject(forKey: "startDate") as! String
        let endDate = coder.decodeObject(forKey: "endDate") as! String
        
        self.init(conditionTitle: conditionTitle, title: title, author: author, publisher: publisher, isbn: isbn, startDate: startDate, endDate: endDate)
        
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var conditionTitle: String
    var title: String
    var author: String
    var publisher: String
    var isbn: String
    var startDate: String
    var endDate: String
    
    override init() {
        conditionTitle = ""
        title = ""
        author = ""
        publisher = ""
        isbn = ""
        startDate = ""
        endDate = ""
    }
    
    init(conditionTitle: String, title: String, author: String, publisher: String, isbn: String, startDate: String, endDate: String) {
        self.conditionTitle = conditionTitle
        self.title = title
        self.author = author
        self.publisher = publisher
        self.isbn = isbn
        self.startDate = startDate
        self.endDate = endDate
    }
    
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
//    var results: [SeojiData] = []
    var results: [BookItem] = []
    
    func callAPI(additional_param: [String: String], target: UIViewController, completion: @escaping (() -> Void)) {
        let naver_book_url = "https://openapi.naver.com/v1/search/book.json?"+additional_param.queryString
        let header: [String:String] = [
            "X-Naver-Client-Id": "bLW73e6VVqZyoxp7EIXw",
            "X-Naver-Client-Secret": "BrccbmEZFj"
        ]
        let encodedURL = naver_book_url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        // query
        
        var urlComponents = URLComponents(string: naver_book_url)
        urlComponents?.query = additional_param.queryString
        
//        guard let hasURL = urlComponents?.url else {
//            return
//        }
        guard let hasURL = URL(string: encodedURL) else { return }
        var request = URLRequest(url: hasURL)
//        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("bLW73e6VVqZyoxp7EIXw", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("BrccbmEZFj", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            print(String(data: data, encoding: .utf8))
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(ResultModel.self, from: data)
                self.results = user.items
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch {
                // error 처리
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "알림", message: "네트워크 에러가 발생했습니다\n잠시 후 다시 시도해 주세요.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(ok)
                    
                    target.present(alert, animated: true, completion: nil)
                }
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
    
    func settingFooterForTableView(for footer: UIView, action selector: Selector) {
        let footerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        footerBtn.setTitle("결과 더보기", for: .normal)
        footerBtn.addTarget(self, action: selector, for: .touchUpInside)
        footer.addSubview(footerBtn)
    }
    
}


// MARK:- Heart Dictionary / Search Condition Model Array

var heartDic: [String: BookItem] = [:] // ISBN: Item
var conditionList: [SearchConditionModel] = []


// MARK:- Archiving
func saveData(data: Any, at: String) {
    DispatchQueue.global().async {
        let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        guard let archivedURL = documentDirectory?.appendingPathComponent(at) else {
            return
        }
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            try archivedData.write(to: archivedURL)
        } catch {
            print(error)
        }
    }
}

func loadData(at: String) -> Any? {
    let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    
    guard let archiveURL = documentDirectory?.appendingPathComponent(at) else {
        return nil
    }
    
    guard let codedData = try? Data(contentsOf: archiveURL) else {
        return nil
    }
    
    guard let unarchivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) else {
        return nil
    }
    return unarchivedData
}

