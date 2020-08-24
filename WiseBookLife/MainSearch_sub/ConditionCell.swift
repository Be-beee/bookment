//
//  ConditionCell.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/20.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class ConditionCell: UITableViewCell {

    @IBOutlet var conditionTitle: UILabel!
    @IBOutlet var searchBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
