//
//  NewListViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class NewListViewController: UIViewController {

    var newbooksList:[SeojiData] = []
    @IBOutlet var newbooksView: UITableView!
    
    let seojiURL = "http://seoji.nl.go.kr/landingPage/SearchApi.do"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "오늘의 신간 😎"
        newbooksView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        viewApiCall()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        let df = DateFormatter()
//        df.dateFormat = "yyyyMMdd"
//        let param: [String:String] = [
//            "cert_key" : "5d01bbea58ffb91aeff99991a691eae9687af5bf7bece6abe67f6058cbaf364c",
//            "result_style" : "json",
//            "page_no" : "1",
//            "page_size" : "1000",
//            "start_publish_date" : df.string(from: Date()),
//            "end_publish_date" : df.string(from: Date())
//        ]
//
//        newbooksList = apiCall(param: param) ?? []
//        print(newbooksList.count)
//        newbooksView.reloadData()
//    }
    
    
    
    // MARK:- URL Session
    func viewApiCall() { // function -> UIViewController extension?
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        
        let param: [String:String] = [
            "cert_key" : "5d01bbea58ffb91aeff99991a691eae9687af5bf7bece6abe67f6058cbaf364c",
            "result_style" : "json",
            "page_no" : "1",
            "page_size" : "1000",
            "start_publish_date" : df.string(from: Date()),
            "end_publish_date" : df.string(from: Date())
        ]
        // query
        
        var urlComponents = URLComponents(string: seojiURL)
        urlComponents?.query = param.queryString
        
        guard let hasURL = urlComponents?.url else {
            return
        }
        
        // model
        // codable
        
        URLSession.shared.dataTask(with: hasURL) { (data, response, error) in
            guard let data = data else{
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(SearchData.self, from: data)
                let result = user.docs
                print(user.TOTAL_COUNT)
                DispatchQueue.main.async {
                    for item in result {
                        self.newbooksList.append(item)
                    }
                    self.newbooksView.reloadData()
                }
                
            } catch {
                // error 처리
                print("error ==> \(error)")
            }
            //Sign in 4_8부터
        }.resume()
    }
    
    
    @objc func onOffHeartBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            heartDic.removeValue(forKey: newbooksList[sender.tag].EA_ISBN)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartDic.updateValue(newbooksList[sender.tag], forKey: newbooksList[sender.tag].EA_ISBN)
        }
        
        // 다시 들어갈 때 찜리스트에 추가된 도서 정보도 그대로 표시 되도록 설정하기
    }
}


extension NewListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension NewListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newbooksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newbooksView.dequeueReusableCell(withIdentifier: "commonCell", for: indexPath) as! CommonCell

        cell.bookCover.image = urlToImage(from: newbooksList[indexPath.row].TITLE_URL)
        
        cell.titleLabel.text = newbooksList[indexPath.row].TITLE
        cell.authorLabel.text = newbooksList[indexPath.row].AUTHOR
//        cell.publisherLabel.text = newbooksList[indexPath.row].PUBLISHER
        
        
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(onOffHeartBtn), for: .touchUpInside)
        
        
        if heartDic[newbooksList[indexPath.row].EA_ISBN] != nil {
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        return cell
    }
}
