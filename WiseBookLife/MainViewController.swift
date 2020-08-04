//
//  ViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/21.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var heartImgList: [String] = []
    @IBOutlet var heartbookView: UICollectionView!
    @IBOutlet var noBookLabel: UILabel!
    
    var newImgList: [String] = []
    @IBOutlet var newbookView: UICollectionView!
    
    var searchTool = SearchBook()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        
        let param: [String: String] = [
            "start_publish_date" : df.string(from: Date()),
            "end_publish_date" : df.string(from: Date())
        ]
        searchTool.callAPI(page_no: "1", page_size: "10", additional_param: param) {
            for item in self.searchTool.results {
                self.newImgList.append(item.TITLE_URL)
            }
            self.newbookView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewHeartImgList()
        if heartImgList.count == 0 {
            noBookLabel.isHidden = false
        } else {
            noBookLabel.isHidden = true
        }
    }
    
    // MARK:- Create Image List
    
    func viewHeartImgList() {
//        heartList[index].TITLE_URL -> UIImage / count: MAX 3 ~ 6
//        Append newbookList
        heartImgList = []
        for (_, value) in heartDic {
            heartImgList.append(value.TITLE_URL)
        }
        heartbookView.reloadData()
    }
    
    // MARK:- Action
    @IBAction func toAlarmList(_ sender: UIBarButtonItem) {
        let alarmListVC = UIStoryboard(name: "AlarmListVC", bundle: nil).instantiateViewController(withIdentifier: "alarmListVC") as! AlarmListViewController
        self.navigationController?.pushViewController(alarmListVC, animated: true)
    }
    
    @IBAction func toMyList(_ sender: UIButton) {
        let heartListVC = UIStoryboard(name: "HeartListVC", bundle: nil).instantiateViewController(withIdentifier: "heartListVC") as! HeartListViewController
        self.navigationController?.pushViewController(heartListVC, animated: true)
    }
    
    @IBAction func toNewbookList(_ sender: UIButton) {
        let newListVC = UIStoryboard(name: "NewListVC", bundle: nil).instantiateViewController(withIdentifier: "newListVC") as! NewListViewController
        self.navigationController?.pushViewController(newListVC, animated: true)
    }
    
    @IBAction func toSettingView(_ sender: UIButton) {
        let settingVC = UIStoryboard(name: "SettingVC", bundle: nil).instantiateViewController(withIdentifier: "settingVC") as! SettingViewController
        settingVC.modalPresentationStyle = .fullScreen
        
        present(settingVC, animated: true, completion: nil)
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
            heartCell.bookImgView.image = urlToImage(from: heartImgList[indexPath.row])
            
            return heartCell
        } else {
            let newbookCell = newbookView.dequeueReusableCell(withReuseIdentifier: "newbookCell", for: indexPath) as! NewbookCell
            
            newbookCell.bookImgView.image = urlToImage(from: newImgList[indexPath.row])
            
            return newbookCell
        }
        
    }
    
    
}



