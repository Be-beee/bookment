//
//  CommonCell.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/01.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class CommonCell: UITableViewCell {

    @IBOutlet var bookCover: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var heartBtn: UIButton!
    
    var isHeartOn = false
}
