//
//  PageViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/06.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit
import RealmSwift

class MainPageViewController: UIViewController {
    @IBOutlet weak var recordContainerView: UIView!
    @IBOutlet weak var wishListContainerView: UIView!
    @IBOutlet weak var recordViewMenu: UILabel!
    @IBOutlet weak var wishListViewMenu: UILabel!
    @IBOutlet weak var floatingPlusBtn: UIButton!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBarLine()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        settingInitialView()
        settingMenuGesture()
        print(Realm.Configuration.defaultConfiguration.fileURL!) // realm file path
    }
    
    func settingInitialView() {
        recordContainerView.isHidden = false
        wishListContainerView.isHidden = true
        
        recordViewMenu.font = UIFont.boldSystemFont(ofSize: 17)
        recordViewMenu.textColor = Theme.main.mainColor
        wishListViewMenu.textColor = .label
        
        floatingPlusBtn.layer.cornerRadius = floatingPlusBtn.bounds.size.width/2
        
        floatingPlusBtn.layer.shadowColor = UIColor.systemGray.cgColor
        floatingPlusBtn.layer.shadowOpacity = 0.5
        floatingPlusBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    func settingMenuGesture() {
        let recordViewGesture = UITapGestureRecognizer(target: self, action: #selector(showRecordView))
        let wishListViewGesture = UITapGestureRecognizer(target: self, action: #selector(showWishListView))
        
        recordViewMenu.addGestureRecognizer(recordViewGesture)
        wishListViewMenu.addGestureRecognizer(wishListViewGesture)
    }
    
    @objc func showRecordView() {
        recordContainerView.isHidden = false
        wishListContainerView.isHidden = true
        
        recordViewMenu.font = UIFont.boldSystemFont(ofSize: 17)
        recordViewMenu.textColor = Theme.main.mainColor
        wishListViewMenu.font = UIFont.systemFont(ofSize: 17)
        wishListViewMenu.textColor = .label
    }
    @objc func showWishListView() {
        recordContainerView.isHidden = true
        wishListContainerView.isHidden = false
        
        recordViewMenu.font = UIFont.systemFont(ofSize: 17)
        recordViewMenu.textColor = .label
        wishListViewMenu.font = UIFont.boldSystemFont(ofSize: 17)
        wishListViewMenu.textColor = Theme.main.mainColor
    }
    
    
    @IBAction func moveToAddContentsView(_ sender: UIButton) {
        guard let searchVC = UIStoryboard(name: "MainSearchResultViewController", bundle: nil).instantiateViewController(withIdentifier: "MainSearchResultViewController") as? MainSearchResultViewController else { return }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}
