//
//  PageViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/06.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    lazy var vcs: [UIViewController] = {
        return [
            self.importViewControllers(name: "RecordViewController"),
            self.importViewControllers(name: "CalendarController"),
            self.importViewControllers(name: "HeartListViewController")
        ]
    }()
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = vcs.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
//        if let superVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainPageViewController") as? MainPageViewController {
//            superVC.delegate = self
//        }
    }
    
    func importViewControllers(name: String) -> UIViewController {
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: name)
    }

}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = vcs.firstIndex(of: viewController) else { return nil }
        let prevIdx = idx - 1
        
        if prevIdx < 0 {
            return vcs.last
        } else {
            return vcs[prevIdx]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = vcs.firstIndex(of: viewController) else { return nil }
        let nextIdx = idx + 1
        
        if nextIdx >= vcs.count {
            return vcs.first
        } else {
            return vcs[nextIdx]
        }
    }
}

//extension PageViewController: SegControlDelegate {
//    func modifyIndex(_ idx: Int) {
//        print("modify \(idx)")
//        setViewControllers([vcs[idx]], direction: .forward, animated: true, completion: nil)
//    }
//}
