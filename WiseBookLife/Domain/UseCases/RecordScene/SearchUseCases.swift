//
//  SearchUseCases.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

final class SearchUseCases {
    
    // MARK: - Properties
    
    private let repository: SearchRepository
    
    // MARK: - Init(s)
    
    init() {
        self.repository = SearchRemoteRepository()
    }
    
    init(repository: SearchRepository) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func search(with keyword: String, at page: Int) async throws -> [BookInfoLocalDTO] {
        let dto = try await repository.search(with: keyword, at: page)
        
        return dto.map { $0.changeToBookInfo() }
    }
    
}
