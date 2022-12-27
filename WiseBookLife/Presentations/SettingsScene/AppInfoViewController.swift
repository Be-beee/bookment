//
//  AppInfoViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/25.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit
import SafariServices

class AppInfoViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .primary
        self.navigationItem.title = "애플리케이션 정보"
        
        settingAppInfoView()
    }
    
    func settingAppInfoView() {
        guard let currentVer = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return }
        versionLabel.text = "ver. "+currentVer
    }

    @IBAction func moveToDeveloperSite(_ sender: UIButton) {
        let myLink = "https://github.com/Be-beee"
        guard let detailURL = URL(string: myLink) else { return }
        let detailSafariVC = SFSafariViewController(url: detailURL)

        self.present(detailSafariVC, animated: true, completion: nil)
    }
}
