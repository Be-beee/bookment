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
    @IBOutlet var newbookView: UICollectionView!
    @IBOutlet var noBookLabel: UILabel!
    
    let seojiURL = "http://seoji.nl.go.kr/landingPage/SearchApi.do"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewImgList()
        if heartImgList.count == 0 {
            noBookLabel.isHidden = false
        } else {
            noBookLabel.isHidden = true
        }
    }
    
    // MARK:- Image URL
    
    func viewImgList() {
//        heartList[index].TITLE_URL -> UIImage / count: MAX 3 ~ 6
//        Append newbookList
        heartImgList = []
        for (_, value) in heartDic {
            heartImgList.append(value.TITLE_URL)
        }
        newbookView.reloadData()
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
        return heartImgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newbookView.dequeueReusableCell(withReuseIdentifier: "newbookCell", for: indexPath) as! NewbookCell
        cell.bookImgView.image = urlToImage(from: heartImgList[indexPath.row])
        
        return cell
    }
    
    
}



