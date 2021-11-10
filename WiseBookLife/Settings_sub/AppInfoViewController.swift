//
//  AppInfoViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/25.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = Theme.main.mainColor
        self.removeNavigationBarLine()
        self.navigationItem.title = "애플리케이션 정보"
        
        settingAppInfoView()
    }
    
    func settingAppInfoView() {
        guard let currentVer = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return }
        versionLabel.text = "ver. "+currentVer
    }

    @IBAction func confirmUpdate(_ sender: UIButton) {
        let appID = ""
        guard let appstoreURL = URL(string: "itms-apps://itunes.apple.com/app/\(appID)") else { return }
        UIApplication.shared.open(appstoreURL, options: [:], completionHandler: nil)
    }
}
