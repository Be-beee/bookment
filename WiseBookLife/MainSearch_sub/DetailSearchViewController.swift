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
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var authorField: UITextField!
    @IBOutlet var publisherField: UITextField!
    @IBOutlet var isbnField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBarButton = UIBarButtonItem(title: "검색", style: .plain, target: self, action: #selector(searchDetail))
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "상세 검색"
        self.navigationItem.rightBarButtonItem = searchBarButton
    }
    
    @objc func searchDetail() {
        let mainSearchResultVC = UIStoryboard(name: "MainSearchResultVC", bundle: nil).instantiateViewController(withIdentifier: "mainSearchResultVC") as! MainSearchResultViewController
        
        if let title = titleField.text, !title.isEmpty {
            params.updateValue(title, forKey: "title")
        }
        
        if let author = authorField.text, !author.isEmpty {
            params.updateValue(author, forKey: "author")
        }
        
        if let publisher = publisherField.text, !publisher.isEmpty {
            params.updateValue(publisher, forKey: "publisher")
        }
        
        if let isbn = isbnField.text, !isbn.isEmpty {
            params.updateValue(isbn, forKey: "isbn")
        }
        // 추후 효율적인 코드로 수정할 것
        
        mainSearchResultVC.detailSearchQuery = params
        self.navigationController?.pushViewController(mainSearchResultVC, animated: true)
    }
    // 검색 대상: 제목, 저자, 발행처, 키워드, ISBN, 출판예정일 (시작, 끝)
    // AND OR NOT
    
}
