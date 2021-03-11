//
//  AddRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/03/11.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {

    var inputData = ""
    @IBOutlet weak var recordInputView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTextView()
    }
    
    func settingTextView() {
        recordInputView.layer.borderWidth = 0.3
        recordInputView.layer.borderColor = Theme.main.mainColor.cgColor
    }
    
    @IBAction func dismissThisView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRecord(_ sender: UIButton) {
        self.inputData = recordInputView.text
        if !inputData.isEmpty {
            self.performSegue(withIdentifier: "toDetailViewFromAddView", sender: self)
        } else {
            print("내용을 입력해주세요")
        }
    }
}
