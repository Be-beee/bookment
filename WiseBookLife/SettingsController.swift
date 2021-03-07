//
//  SettingsController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/25.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit
import MessageUI

class SettingsController: UIViewController {

    var infoSection: [String] = [
        "애플리케이션 정보"
    ]
    
    var backupSection: [String] = [
        "iCloud 동기화",
        "백업 파일 만들기",
    ]
    
    var feedbackSection: [String] = [
        "피드백 보내기",
        "리뷰 남기기"
    ]
    
    @IBOutlet weak var settingsView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // navigation bar bottom line 삭제하기
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return infoSection.count
        case 1:
            return backupSection.count
        default:
            return feedbackSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingsView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingCell else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            cell.settingTitle.text = infoSection[indexPath.row]
        case 1:
            cell.settingTitle.text = backupSection[indexPath.row]
        default:
            cell.settingTitle.text = feedbackSection[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let appInfoVC = UIStoryboard(name: "AppInfoViewController", bundle: nil).instantiateViewController(withIdentifier: "AppInfoViewController") as? AppInfoViewController else { return }
            
            self.navigationController?.pushViewController(appInfoVC, animated: true)
        case 1:
            print("selected Index: section-\(indexPath.section) row-\(indexPath.row)")
        default:
            if indexPath.row == 0 {
                let mailComposeVC = configureMailComposer()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeVC, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "알림", message: "이메일을 보낼 수 없습니다.\n Mail에 계정이 등록되어 있는지 확인해주세요.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    print("이메일을 보낼 수 없습니다.")
                }
            }
        }
    }
    
    func configureMailComposer() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        let systemVersion = UIDevice.current.systemVersion
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["maybutter756@gmail.com"])
        mailComposeVC.setSubject("슬독생 문의")
        mailComposeVC.setMessageBody("현재 iOS 버전: \(systemVersion)\n문의 및 피드백 감사합니다!:)", isHTML: false)
        
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class SettingCell: UITableViewCell {
    @IBOutlet weak var settingTitle: UILabel!
}
