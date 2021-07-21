//
//  Model.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/22.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

struct BookItem: Codable, Hashable {
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
    var contents: [Date: String] = [:]
}

extension Date {
    func dateToString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        return df.string(from: self)
    }
}

// MARK:- Heart Dictionary / Search Condition Model Array

struct CommonData {
    static var shared = CommonData()
    
    var heartDic: [String: BookItem] = [:] // ISBN: Item
    var records: [String: Record] = [:] // ISBN: Record
    // 최신순으로 정렬하기 위한 기준이 필요함
    var latest: [String] = []
    
    
    func sortRecords(isbn: String) -> [(Date, String)] {
        guard let data = records[isbn] else { return [] }
        
        return data.contents.sorted { $0.key < $1.key }
    }
    
    func createCalendarModel() -> [String: [BookItem]] { // date_string: [Item]
        
        var calendarModel: [String: [BookItem]] = [:]
        let values = records.values
        
        for item in values {
            let bookitem = item.bookData
            for data in item.contents {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                let calendarKey = df.string(from: data.key)
                
                var newItemSets: Set<BookItem> = []
                
                if let prevItem = calendarModel[calendarKey] {
                    newItemSets = Set(prevItem)
                }
                newItemSets.insert(bookitem)
                let newItem = newItemSets.sorted { $0.title < $1.title }
                // 기록 업데이트 순으로 정렬할 방법?
                
                calendarModel.updateValue(newItem, forKey: df.string(from: data.key))
                
            }
        }
        
        return calendarModel
    }
    
    func createMyLibraryList() -> [BookItem] {
        var librarylist = records.map { $0.value.bookData }
        librarylist.sort { $0.title < $1.title }
        // records 데이터 변경 최신 순으로 정렬이 필요함
        // 현재는 이름 순 정렬 중
        return librarylist
    }
}
