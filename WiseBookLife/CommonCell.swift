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
    @IBOutlet var bellBtn: UIButton!
    
    var isHeartOn = false
    var isBellOn = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
