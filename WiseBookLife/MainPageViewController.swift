//
//  PageViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/06.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

protocol SegControlDelegate {
    func modifyIndex(_ idx: Int)
}

class MainPageViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
//    var delegate: SegControlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // navigation bar bottom line 삭제하기
    
//        segmentedControl.setTitleTextAttributes(<#T##attributes: [NSAttributedString.Key : Any]?##[NSAttributedString.Key : Any]?#>, for: <#T##UIControl.State#>)
        
    }
    @IBAction func goToSearchMenu(_ sender: Any) {
        
    }
    @IBAction func changePages(_ sender: UISegmentedControl) {
//        delegate?.modifyIndex(sender.selectedSegmentIndex)
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageViewController") as? PageViewController else { return }
        print("view selected")
        vc.setViewControllers([vc.vcs[sender.selectedSegmentIndex]], direction: .reverse, animated: false, completion: nil)
        
    }
}
