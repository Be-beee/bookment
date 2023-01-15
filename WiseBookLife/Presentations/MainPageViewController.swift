//
//  PageViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/06.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

import RealmSwift

final class MainPageViewController: UIViewController {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var recordContainerView: UIView!
    @IBOutlet weak var wishListContainerView: UIView!
    @IBOutlet weak var recordViewMenu: UILabel!
    @IBOutlet weak var wishListViewMenu: UILabel!
    @IBOutlet weak var floatingPlusBtn: UIButton!
    
    // MARK: - Properties
    
    private var selectedPage = MainPageType.record {
        didSet {
            configurePageView()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageView()
        configureFloatingButton()
        configureMenuGesture()
        
        print(Realm.Configuration.defaultConfiguration.fileURL) // realm file path
    }
    
    // MARK: - Configure Functions
    
    /// 처음 메인화면이 나타날 때 보여질 화면을 설정한다. 앱 최초 진입시에는 나의 노트가 먼저 보인다.
    private func configurePageView() {
        let isRecordViewHidden = (selectedPage == MainPageType.record) ? false : true
        recordContainerView.isHidden = isRecordViewHidden
        wishListContainerView.isHidden = !recordContainerView.isHidden
    }
    
    /// 도서 검색 플로팅 버튼 UI 설정
    private func configureFloatingButton() {
        floatingPlusBtn.layer.cornerRadius = floatingPlusBtn.bounds.size.width/2
        
        floatingPlusBtn.layer.shadowColor = UIColor.systemGray.cgColor
        floatingPlusBtn.layer.shadowOpacity = Metric.floatingButtonShadowOpacity
        floatingPlusBtn.layer.shadowOffset = Metric.floatingButtonShadowOffset
    }
    
    /// 메뉴 버튼의 GestureRecognizer 설정
    private func configureMenuGesture() {
        let recordViewGesture = UITapGestureRecognizer(target: self, action: #selector(showRecordView))
        let wishListViewGesture = UITapGestureRecognizer(target: self, action: #selector(showWishListView))
        
        recordViewMenu.addGestureRecognizer(recordViewGesture)
        wishListViewMenu.addGestureRecognizer(wishListViewGesture)
    }
    
    // MARK: - objc Functions
    
    @objc func showRecordView() {
        selectedPage = MainPageType.record
        
        recordViewMenu.textColor = .primary
        wishListViewMenu.textColor = .systemGray
    }
    
    @objc func showWishListView() {
        selectedPage = MainPageType.wishlist
        
        recordViewMenu.textColor = .systemGray
        wishListViewMenu.textColor = .primary
    }
    
    // MARK: - IBAction Functions
    
    @IBAction func moveToAddContentsView(_ sender: UIButton) {
        let mainSearchResultViewID = MainSearchResultViewController.name
        guard let searchVC = loadViewController(with: mainSearchResultViewID) as? MainSearchResultViewController
        else { return }
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - Pages

extension MainPageViewController {
    enum MainPageType: Int {
        case record, wishlist
    }
}

// MARK: - Namespaces

extension MainPageViewController {
    enum Metric {
        static let floatingButtonShadowOpacity: Float = 0.5
        static let floatingButtonShadowOffset = CGSize(width: 2, height: 2)
    }
}
