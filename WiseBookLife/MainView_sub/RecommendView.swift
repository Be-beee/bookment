//
//  RecommendView.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/24.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class RecommendView: UIView {

    let xibName = "RecommendView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.common()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.common()
    }

    func common() {
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
