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
}

struct ResultModel: Codable {
    var lastBuildDate: String = ""
    var total: Int = 0
    var start: Int = 0
    var display: Int = 0
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
    
    mutating func modifySearchedData() {
        let title = self.title.removeHTMLTag()
        let author = self.author.removeHTMLTag()
        
        self.title = title
        self.author = author
    }
}

struct Record: Codable {
    var bookData: BookItem = BookItem()
    var date: Date = Date()
    var contents: [String] = []
}

struct CalendarModel: Codable {
    var date = Date()
    var bookDatas: [BookItem] = []
}

extension Date {
    func dateToString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        return df.string(from: self)
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
    var results: [BookItem] = []
    
    func callAPI(additional_param: [String: String], target: UIViewController, completion: @escaping (() -> Void)) {
        let clientData = ClientData()
        let naver_book_url = clientData.requestURL
        
        var urlComponents = URLComponents(string: naver_book_url)
        urlComponents?.query = additional_param.queryString
        
        guard let hasURL = urlComponents?.url else { return }
        var request = URLRequest(url: hasURL)
        request.addValue(clientData.requestHeader["X-Naver-Client-Id"] ?? "", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientData.requestHeader["X-Naver-Client-Secret"] ?? "", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "알림", message: "네트워크 에러가 발생했습니다\n잠시 후 다시 시도해 주세요.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(ok)

                    target.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(ResultModel.self, from: data)
                var datas: [BookItem] = []
                for item in user.items {
                    let newItem = BookItem(title: item.title.removeHTMLTag(), link: item.link, image: item.image, author: item.author.removeHTMLTag(), price: item.price, discount: item.discount, publisher: item.publisher, isbn: item.isbn, description: item.description.removeHTMLTag(), pubdate: item.pubdate)
                    datas.append(newItem)
                }
                self.results = datas
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch let error {
                // error 처리
                print(error.localizedDescription)
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
    
    func settingFooterForTableView(for footer: UIView, action selector: Selector, title str: String? = "결과 더보기", image: UIImage? = nil, bgColor: UIColor? = nil, drawBorder: Bool = false) {
        let footerBtn = UIButton(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 20, height: 50))
        if let title = str {
            footerBtn.setTitle(title, for: .normal)
            footerBtn.setTitleColor(.label, for: .normal)
        }
        if let image = image {
            footerBtn.setImage(image, for: .normal)
            footerBtn.tintColor = .white
        }
        if let bgColor = bgColor {
            footerBtn.backgroundColor = bgColor
        }
        
        if drawBorder {
            footerBtn.layer.borderWidth = 0.3
            footerBtn.layer.borderColor = Theme.main.mainColor.cgColor
            footerBtn.tintColor = Theme.main.mainColor
        }
        
        footerBtn.addTarget(self, action: selector, for: .touchUpInside)
        footer.addSubview(footerBtn)
    }
    
}

extension String {
    func removeHTMLTag() -> String {
        let rmFirst = self.replacingOccurrences(of: "<b>", with: "")
        let result = rmFirst.replacingOccurrences(of: "</b>", with: "")
        return result
    }
}


// MARK:- Heart Dictionary / Search Condition Model Array

struct CommonData {
    static var shared = CommonData()
    
    var heartDic: [String: BookItem] = [:] // ISBN: Item
    var calendarModel: [String: [BookItem]] = [:] // date_string: [Item]
    var records: [Record] = []
}


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

// MARK: - Main Theme Color

struct Theme {
    static let main = Theme()
    let mainColor = UIColor(red: 239/255, green: 190/255, blue: 91/255, alpha: 1) //#EFBE5B
}
