//
//  SearchRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

import RxSwift

// TODO: BookInfoRepository와 통합 및 옵셔널 메서드 정의하기
protocol SearchRepository {
    func search(with keyword: String, at page: Int) async throws -> [BookInfoResponseDTO]
    func searchRx(with keyword: String, at page: Int) throws -> Observable<[BookInfoResponseDTO]>
}
