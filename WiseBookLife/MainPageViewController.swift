//
//  PageViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/06.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    @IBOutlet weak var recordContainerView: UIView!
    @IBOutlet weak var wishListContainerView: UIView!
    @IBOutlet weak var recordViewMenu: UILabel!
    @IBOutlet weak var wishListViewMenu: UILabel!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // navigation bar bottom line 삭제하기
        settingInitialView()
        settingMenuGesture()
    }
    
    func settingInitialView() {
        recordContainerView.isHidden = false
        wishListContainerView.isHidden = true
        
        recordViewMenu.textColor = .systemOrange
        wishListViewMenu.textColor = .label
    }
    
    func settingMenuGesture() {
        let recordViewGesture = UITapGestureRecognizer(target: self, action: #selector(showRecordView))
        let wishListViewGesture = UITapGestureRecognizer(target: self, action: #selector(showWishListView))
        
        recordViewMenu.addGestureRecognizer(recordViewGesture)
        wishListViewMenu.addGestureRecognizer(wishListViewGesture)
    }
    
    @IBAction func goToSearchMenu(_ sender: Any) {
        guard let searchVC = UIStoryboard(name: "MainSearchResultVC", bundle: nil).instantiateViewController(withIdentifier: "mainSearchResultVC") as? MainSearchResultViewController else { return }
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func showRecordView() {
        recordContainerView.isHidden = false
        wishListContainerView.isHidden = true
        
        recordViewMenu.textColor = .systemOrange
        wishListViewMenu.textColor = .label
    }
    @objc func showWishListView() {
        recordContainerView.isHidden = true
        wishListContainerView.isHidden = false
        
        recordViewMenu.textColor = .label
        wishListViewMenu.textColor = .systemOrange
    }
}
