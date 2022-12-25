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
    
    var keyword: String?
    
    var currentPage = Metric.initialPage
    
    var searchResult: [BookInfo] = []
    
    // MARK: - Init(s)
    
    init() {
        self.searchUseCases = SearchUseCases()
    }
    
    init(searchUseCases: SearchUseCases) {
        self.searchUseCases = searchUseCases
    }
    
    // MARK: - Functions
    
    func search(with keyword: String) async {
        self.keyword = keyword
        
        do {
            let result = try await searchUseCases.search(with: keyword, at: currentPage)
            self.searchResult = result
            self.currentPage += Metric.pageSize
            await MainActor.run {
                delegate?.searchResultDidChange()
            }
        } catch {
            print(error.localizedDescription)
            await MainActor.run {
                delegate?.searchResultLoadFailed()
            }
        }
        
    }
    
    func clear() {
        keyword = nil
        currentPage = Metric.initialPage
        searchResult.removeAll()
    }
    
}


// MARK: - Namespaces

extension MainSearchViewModel {
    enum Metric {
        static let initialPage = 1
        static let pageSize = 10
    }
}
