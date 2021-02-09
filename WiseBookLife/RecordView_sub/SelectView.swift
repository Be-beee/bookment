//
//  SelectView.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/15.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class SelectView: UIView {

    private let xibName = "SelectView"
    
    @IBOutlet var bookCoverView: UIImageView!
    
    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var bookAuthor: UILabel!
    @IBOutlet var bookDate: UILabel!
    @IBOutlet var bookPublisher: UILabel!
    
    
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
