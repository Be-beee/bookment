//
//  UIViewController+FooterView.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/07/05.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

// MARK: - Etc.

extension UIViewController {
    func settingFooterForTableView(for footer: UIView, action selector: Selector, title str: String? = "결과 더보기", image: UIImage? = nil, bgColor: UIColor? = nil, drawBorder: Bool = false) {
        let footerBtn = UIButton(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width - 20, height: 50))
        if let title = str {
            footerBtn.setTitle(title, for: .normal)
            footerBtn.setTitleColor(.label, for: .normal)
        }
        if let image = image {
            footerBtn.setImage(image, for: .normal)
            footerBtn.tintColor = .white
        }
        if let bgColor = bgColor {
            footerBtn.backgroundColor = bgColor
        }
        
        if drawBorder {
            footerBtn.layer.borderWidth = 0.3
            footerBtn.layer.borderColor = UIColor.primary?.cgColor
            footerBtn.tintColor = .primary
        }
        
        footerBtn.addTarget(self, action: selector, for: .touchUpInside)
        footer.addSubview(footerBtn)
    }
    
}


