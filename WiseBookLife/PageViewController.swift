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
            self.importViewControllers(name: "HeartListViewController")
        ]
    }()
    var selectedIdx = 0
    private var mainPageViewController: MainPageViewController!
    
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
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainPageViewController") as? MainPageViewController else { return }
        mainPageViewController = vc
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
            return nil
        } else {
            selectedIdx = prevIdx
        }
        return vcs[selectedIdx]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = vcs.firstIndex(of: viewController) else { return nil }
        let nextIdx = idx + 1
        
        if nextIdx >= vcs.count {
            return nil
        } else {
            selectedIdx = nextIdx
            mainPageViewController.segmentedControl?.selectedSegmentIndex = selectedIdx
            // 페이지가 이동할 때 세그먼트 컨트롤의 값을 어떻게 바꿀 것인지???
            // 일단 위의 방법은 안먹힘
            // 델리게이트 패턴? 써야하나
        }
        return vcs[selectedIdx]
    }
}
