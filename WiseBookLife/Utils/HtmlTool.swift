//
//  HtmlTool.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/05/29.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

extension String {
    func removeHTMLTag() -> String {
        let rmFirst = self.replacingOccurrences(of: "<b>", with: "")
        let result = rmFirst.replacingOccurrences(of: "</b>", with: "")
        return result
    }
}
