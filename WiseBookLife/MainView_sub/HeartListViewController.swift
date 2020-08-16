//
//  HeartListViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit


class HeartListViewController: UIViewController {

    @IBOutlet var heartView: UITableView!
    
    var heartList: [SeojiData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "나의 찜리스트 😍"
        heartView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
        
        
//        heartList = heartDic.values
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if let loadedData = loadHeartList() {
//            heartDic = loadedData
//        }
        for (_, value) in heartDic {
            heartList.append(value)
        }
        heartView.reloadData()
    }

    
    // MARK:- cell button action methods
    
    @objc func onOffHeartBtn(_ sender: UIButton!) {
//        sender.isSelected = !sender.isSelected
        if sender.imageView?.image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            heartDic.removeValue(forKey: heartList[sender.tag].EA_ISBN)
            saveHeartList()
            refreshData()
        }
    }
    
    func refreshData() {
        heartList = []
        for (_, value) in heartDic {
            heartList.append(value)
        }
        
        heartView.reloadData()
    }
    
    
    @objc func onOffBellBtn(_ sender: UIButton!) {
        if sender.imageView?.image == UIImage(systemName: "bell.fill") {
            sender.setImage(UIImage(systemName: "bell"), for: .normal)
            bellDic.removeValue(forKey: heartList[sender.tag].EA_ISBN)
        } else {
            sender.setImage(UIImage(systemName: "bell.fill"), for: .normal)
            bellDic.updateValue(heartList[sender.tag].TITLE, forKey: heartList[sender.tag].EA_ISBN)
        }
        print(bellDic.count)
        saveBellList()
    }
}


// MARK:- Extensions
extension HeartListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension HeartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = heartView.dequeueReusableCell(withIdentifier: "commonCell", for: indexPath) as! CommonCell
        
        cell.bookCover.image = urlToImage(from: heartList[indexPath.row].TITLE_URL)
        
        if heartList[indexPath.row].TITLE == "" {
            cell.titleLabel.text = "[NO TITLE]"
            cell.titleLabel.textColor = .lightGray
        } else {
            cell.titleLabel.text = heartList[indexPath.row].TITLE
        }
        
        cell.authorLabel.text = heartList[indexPath.row].AUTHOR
        
        cell.heartBtn.tag = indexPath.row
        cell.heartBtn.addTarget(self, action: #selector(onOffHeartBtn), for: .touchUpInside)
        cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        
        cell.bellBtn.tag = indexPath.row
        cell.bellBtn.addTarget(self, action: #selector(onOffBellBtn), for: .touchUpInside)
        
        if bellDic[heartList[indexPath.row].EA_ISBN] != nil {
            cell.bellBtn.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        } else {
            cell.bellBtn.setImage(UIImage(systemName: "bell"), for: .normal)
        }

        return cell
    }
}

