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
    @IBOutlet weak var floatingPlusBtn: UIButton!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // navigation bar bottom line 삭제하기
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        settingInitialView()
        settingMenuGesture()
    }
    
    func settingInitialView() {
        recordContainerView.isHidden = false
        wishListContainerView.isHidden = true
        
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
    
    @IBAction func goToSearchMenu(_ sender: Any) {
        guard let searchVC = UIStoryboard(name: "MainSearchResultVC", bundle: nil).instantiateViewController(withIdentifier: "mainSearchResultVC") as? MainSearchResultViewController else { return }
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func showRecordView() {
        recordContainerView.isHidden = false
        wishListContainerView.isHidden = true
        
        recordViewMenu.textColor = Theme.main.mainColor
        wishListViewMenu.textColor = .label
    }
    @objc func showWishListView() {
        recordContainerView.isHidden = true
        wishListContainerView.isHidden = false
        
        recordViewMenu.textColor = .label
        wishListViewMenu.textColor = Theme.main.mainColor
    }
    
    
    @IBAction func moveToAddContentsView(_ sender: UIButton) {
        let addRecordVC = UIStoryboard(name: "AddRecordVC", bundle: nil).instantiateViewController(withIdentifier: "addRecordVC") as! AddRecordViewController

        addRecordVC.modalPresentationStyle = .fullScreen
        self.present(addRecordVC, animated: true, completion: nil)
    }
}
