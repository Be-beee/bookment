//
//  SearchRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

protocol SearchRepository {
    func search(with keyword: String, at page: Int) async throws -> [BookInfoResponseDTO]
}
