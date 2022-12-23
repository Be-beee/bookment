//
//  SearchResponseDTO.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/05/29.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

struct SearchResponseDTO: Codable {
    var lastBuildDate: String = ""
    var total: Int = 0
    var start: Int = 0
    var display: Int = 0
    var items: [BookInfoResponseDTO] = []
}
