//
//  ViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/21.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    typealias BookSimple = (title: String, image: String)
    var heartImgList: [BookSimple] = []
    @IBOutlet var heartbookView: UICollectionView!
    @IBOutlet var noBookLabel: UILabel!
    
    var newImgList: [String] = []
    @IBOutlet var newbookView: UICollectionView!
    
    var searchTool = SearchBook()
    
    @IBOutlet var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        
        let param: [String: String] = [
            "start_publish_date" : df.string(from: Date()),
            "end_publish_date" : df.string(from: Date())
        ]
        print(df.string(from: Date()))
        searchTool.callAPI(page_no: 1, page_size: 10, additional_param: param) {
            for item in self.searchTool.results {
                self.newImgList.append(item.TITLE_URL)
            }
            self.newbookView.reloadData()
            // 추후 activity indicator 추가하기
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewHeartImgList()
        searchBar.text = ""
        if heartImgList.count == 0 {
            noBookLabel.isHidden = false
        } else {
            noBookLabel.isHidden = true
        }
    }
    
    // MARK:- Create Image List
    
    func viewHeartImgList() {
        if let loadedData = loadData(at: "heart") {
            heartDic = loadedData as! [String: SeojiData]
        }
        heartImgList = []
        for (_, value) in heartDic {
            heartImgList.append((title: value.TITLE, image: value.TITLE_URL))
        }
        heartImgList.sort(by: {$0.title < $1.title})
        heartbookView.reloadData()
    }
    
    // MARK:- Action
    
    @IBAction func toDetailSearchView(_ sender: UIButton) {
        let detailSearchVC = UIStoryboard(name: "DetailSearchVC", bundle: nil).instantiateViewController(withIdentifier: "detailSearchVC") as! DetailSearchViewController
        self.navigationController?.pushViewController(detailSearchVC, animated: true)
        
    }
    
    @IBAction func toMyList(_ sender: UIButton) {
        let heartListVC = UIStoryboard(name: "HeartListVC", bundle: nil).instantiateViewController(withIdentifier: "heartListVC") as! HeartListViewController
        self.navigationController?.pushViewController(heartListVC, animated: true)
    }
    
    @IBAction func toNewbookList(_ sender: UIButton) {
        let newListVC = UIStoryboard(name: "NewListVC", bundle: nil).instantiateViewController(withIdentifier: "newListVC") as! NewListViewController
        self.navigationController?.pushViewController(newListVC, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3 - 30, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension MainViewController: UICollectionViewDelegate {}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case self.heartbookView:
            return heartImgList.count
        default:
            return newImgList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.heartbookView {
            let heartCell = heartbookView.dequeueReusableCell(withReuseIdentifier: "newbookCell", for: indexPath) as! NewbookCell
            heartCell.bookImgView.image = urlToImage(from: heartImgList[indexPath.row].image)
            
            return heartCell
        } else {
            let newbookCell = newbookView.dequeueReusableCell(withReuseIdentifier: "newbookCell", for: indexPath) as! NewbookCell
            
            newbookCell.bookImgView.image = urlToImage(from: newImgList[indexPath.row])
            
            return newbookCell
        }
        
    }
    
    
}

extension MainViewController: UISearchBarDelegate {
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        if !searchBar.text!.isEmpty {
            let mainSearchResultVC = UIStoryboard(name: "MainSearchResultVC", bundle: nil).instantiateViewController(withIdentifier: "mainSearchResultVC") as! MainSearchResultViewController
            
            mainSearchResultVC.searchedWord = searchBar.text!
            
            self.navigationController?.pushViewController(mainSearchResultVC, animated: true)
            
        }
    }
}


