//
//  DetailSearchViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/09.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class DetailSearchViewController: UIViewController {

    var params: [String: String] = [:]
    var condition = SearchConditionModel()
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var authorField: UITextField!
    @IBOutlet var publisherField: UITextField!
    @IBOutlet var isbnField: UITextField!
    
    @IBOutlet var startPubDate: UITextField!
    @IBOutlet var endPubDate: UITextField!
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBarButton = UIBarButtonItem(title: "검색", style: .plain, target: self, action: #selector(searchDetail))
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "상세 검색"
        self.navigationItem.rightBarButtonItem = searchBarButton
        
        showdatePicker(sender: startPubDate, startEnd: true)
        showdatePicker(sender: endPubDate, startEnd: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        params = [:]
    }
    
    // MARK:- Unwind
    
    @IBAction func unwindToDetailSearch(sender: UIStoryboardSegue) {
        guard let from = sender.source as? SearchListViewController else {
            return
        }
        titleField.text = from.selected.title
        authorField.text = from.selected.author
        publisherField.text = from.selected.publisher
        isbnField.text = from.selected.isbn
        startPubDate.text = from.selected.startDate
        endPubDate.text = from.selected.endDate
//        searchDetail()
        
    }
    
    // MARK:- Action Methods for bar button item
    @objc func searchDetail() {
        let mainSearchResultVC = UIStoryboard(name: "MainSearchResultVC", bundle: nil).instantiateViewController(withIdentifier: "mainSearchResultVC") as! MainSearchResultViewController
        
        var empty = 0
        
        if let title = titleField.text, !title.isEmpty {
            params.updateValue(title, forKey: "title")
        } else {
            empty += 1
        }
        
        if let author = authorField.text, !author.isEmpty {
            params.updateValue(author, forKey: "author")
        } else {
            empty += 1
        }
        
        if let publisher = publisherField.text, !publisher.isEmpty {
            params.updateValue(publisher, forKey: "publisher")
        } else {
            empty += 1
        }
        
        if let isbn = isbnField.text, !isbn.isEmpty {
            params.updateValue(isbn, forKey: "isbn")
        } else {
            empty += 1
        }
        
        if let startdate = startPubDate.text, !startdate.isEmpty {
            let date = startdate.components(separatedBy: ".").joined()
            params.updateValue(date, forKey: "start_publish_date")
        } else {
            empty += 1
        }
        
        if let enddate = endPubDate.text, !enddate.isEmpty {
            let date = enddate.components(separatedBy: ".").joined()
            params.updateValue(date, forKey: "end_publish_date")
        } else {
            empty += 1
        }
        print(params)
        if empty == 6 {
            let alert = UIAlertController(title: "알림", message: "검색 조건을 하나 이상 입력해주세요!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
        } else if let start = params["start_publish_date"], let end = params["end_publish_date"], start > end {
            let alert = UIAlertController(title: "알림", message: "기간을 올바르게 입력해주세요!\n출판시작일이 출판종료일보다 앞서야합니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
        } else {
            mainSearchResultVC.detailSearchQuery = params
            self.navigationController?.pushViewController(mainSearchResultVC, animated: true)
        }
        
        // 추후 효율적인 코드로 수정할 것

        
    }
    // 검색 대상: 제목, 저자, 발행처, 키워드, ISBN, 출판예정일 (시작, 끝)
    
    @objc func showdatePicker(sender: UITextField, startEnd: Bool) {
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KO")
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
        toolbar.sizeToFit()
        
        
        var items: [UIBarButtonItem] = []
        let cancelBtn = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelDatePicker))
        items.append(cancelBtn)
        
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        items.append(spaceBtn)
        
        
        if startEnd {
            let startDoneBtn = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(doneStartDatePicker))
            items.append(startDoneBtn)
        } else {
            let endDoneBtn = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(doneEndDatePicker))
            items.append(endDoneBtn)
        }
        
        
        toolbar.setItems(items, animated: false)
        
        sender.inputAccessoryView = toolbar
        sender.inputView = datePicker
    }
    
    @objc func doneStartDatePicker() {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        startPubDate.text = df.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func doneEndDatePicker() {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        endPubDate.text = df.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    
    // MARK:- Button Action Methods
    @IBAction func saveSearchDetails(_ sender: UIButton) {
        // save detail to list
        
        let title = titleField.text ?? ""
        let author = authorField.text ?? ""
        let publisher = publisherField.text ?? ""
        let isbn = isbnField.text ?? ""
        let startdate = startPubDate.text ?? ""
        let enddate = endPubDate.text ?? ""
        
        let items: [String] = [ "제목:"+title, "저자:"+author, "출판사:"+publisher, "ISBN:"+isbn, "검색시작날짜:"+startdate, "검색끝날짜:"+enddate ]
        
        var conditiontitle = ""
        for item in items {
            if !item.isEmpty {
                conditiontitle += (item + "/")
            }
        }
        conditiontitle.removeLast()
        
        condition = SearchConditionModel(conditionTitle: conditiontitle, title: title, author: author, publisher: publisher, isbn: isbn, startDate: startdate, endDate: enddate)
        
        conditionList.append(condition)
//        saveData(data: conditionList, at: "conditions")
        
        // alert
        let alert = UIAlertController(title: "알림", message: "검색 조건이 저장되었습니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showSearchDetailList(_ sender: UIButton) {
        let searchListVC = UIStoryboard(name: "SearchListVC", bundle: nil).instantiateViewController(withIdentifier: "searchListVC") as! SearchListViewController
        
        searchListVC.modalPresentationStyle = .fullScreen
        present(searchListVC, animated: true, completion: nil)
    }
    
}
