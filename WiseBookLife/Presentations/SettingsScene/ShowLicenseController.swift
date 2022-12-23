//
//  ShowLicenseController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/11/11.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class ShowLicenseController: UIViewController {
    
    @IBOutlet weak var licenseTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = Theme.main.mainColor
        self.removeNavigationBarLine()
        self.navigationItem.title = "오픈소스 라이선스 정보"
        self.setLicenseTextView()
    }
    
    func setLicenseTextView() {
        self.licenseTextView.text = ""
        guard let path = Bundle.main.path(forResource: "Licenses", ofType: "plist") else {
            return
        }
        guard let xml = FileManager.default.contents(atPath: path) else {
            return
        }
        guard let licenses = try? PropertyListDecoder().decode([String:String].self, from: xml) else {
            return
        }
        
        var allLicensesInfo = ""
        let sortedByName = licenses.sorted { $0.key < $1.key }
        for license in sortedByName {
            allLicensesInfo += "\(license.key)\n"
            allLicensesInfo += "\(license.value)\n\n\n\n\n"
        }
        self.licenseTextView.text = allLicensesInfo
        
    }
    
    
}
