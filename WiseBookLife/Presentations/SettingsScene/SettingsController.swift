//
//  SettingsController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/25.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class SettingsController: UIViewController {
    
    var backupSection: [String] = [
        "백업 및 복원", // json 파일 생성 --> ISBN 정보, 독서기록 저장
//        "내 독서기록 내보내기" // pdf 파일 생성
    ]
    
    var feedbackSection: [String] = [
        "피드백 보내기",
//        "리뷰 남기기"
    ]
    
    var infoSection: [String] = [
        "애플리케이션 정보",
        "오픈소스 라이선스"
    ]
    
    @IBOutlet weak var settingsView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBarLine()
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
            return backupSection.count
        case 1:
            return feedbackSection.count
        default:
            return infoSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingsView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingCell else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            cell.settingTitle.text = backupSection[indexPath.row]
        case 1:
            cell.settingTitle.text = feedbackSection[indexPath.row]
        default:
            cell.settingTitle.text = infoSection[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let updateAlert = UIAlertController(title: "알림", message: "추후 지원될 예정입니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                updateAlert.addAction(ok)
                self.present(updateAlert, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                guard let exportVC = UIStoryboard(name: "ExportManagerViewController", bundle: nil).instantiateViewController(withIdentifier: "ExportManagerViewController") as? ExportManagerViewController else { return }
                
                self.navigationController?.pushViewController(exportVC, animated: true)
            }
            
        case 1:
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
            } else {
                
            }
        default:
            if indexPath.row == 0 {
                guard let appInfoVC = UIStoryboard(name: "AppInfoViewController", bundle: nil).instantiateViewController(withIdentifier: "AppInfoViewController") as? AppInfoViewController else { return }
                
                self.navigationController?.pushViewController(appInfoVC, animated: true)
            } else if indexPath.row == 1 {
                guard let showLicenseVC = UIStoryboard(name: "ShowLicenseController", bundle: nil).instantiateViewController(withIdentifier: "ShowLicenseController") as? ShowLicenseController else { return }
                self.navigationController?.pushViewController(showLicenseVC, animated: true)
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
