//
//  RecordContentCell.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/13.
//  Copyright © 2023 서보경. All rights reserved.
//

import UIKit

final class RecordContentCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with record: RecordContent) {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd."
        
        contentLabel.text = record.text
        dateLabel.text = df.string(from: record.date)
    }
}

