//
//  MainSearchViewModel.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

final class MainSearchViewModel {
    
    // MARK: - Properties
    
    private let searchUseCases: SearchUseCases
    
    weak var delegate: MainSearchViewModelDelegate?
    
    var currentPage: Int = 1
    
    var searchResult: [BookInfo] = []
    
    // MARK: - Init(s)
    
    init() {
        self.searchUseCases = SearchUseCases()
    }
    
    init(searchUseCases: SearchUseCases) {
        self.searchUseCases = searchUseCases
    }
    
    // MARK: - Functions
    
    func search(with keyword: String, at page: Int) async throws {
        do {
            let result = try await searchUseCases.search(with: keyword, at: page)
            print(result)
            self.currentPage = page
            self.searchResult = result
            delegate?.searchResultDidChange()
        } catch let error {
            print(error.localizedDescription)
            delegate?.searchResultLoadFailed()
        }
        
    }
    
    func clear() {
        currentPage = 1
        searchResult.removeAll()
    }
    
}
