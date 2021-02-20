//
//  PageViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/06.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var recordContainerView: UIView!
    @IBOutlet weak var wishListContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // navigation bar bottom line 삭제하기
        
        recordContainerView.isHidden = false
        wishListContainerView.isHidden = true
    
//        segmentedControl.setTitleTextAttributes(<#T##attributes: [NSAttributedString.Key : Any]?##[NSAttributedString.Key : Any]?#>, for: <#T##UIControl.State#>)
        
    }
    @IBAction func goToSearchMenu(_ sender: Any) {
        guard let searchVC = UIStoryboard(name: "MainSearchResultVC", bundle: nil).instantiateViewController(withIdentifier: "mainSearchResultVC") as? MainSearchResultViewController else { return }
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func changePages(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            recordContainerView.isHidden = true
            wishListContainerView.isHidden = false
        default:
            recordContainerView.isHidden = false
            wishListContainerView.isHidden = true
        }
    }
}
