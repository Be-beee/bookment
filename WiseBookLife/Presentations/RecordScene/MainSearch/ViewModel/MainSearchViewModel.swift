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
    
    private var currentPage = Metric.initialPage
    
    private(set) var isLastPage = false
    
    private(set) var searchResult: [BookInfo] = []
    
    private var keyword: String?
    
    weak var delegate: MainSearchViewModelDelegate?
    
    // MARK: - Init(s)
    
    init() {
        self.searchUseCases = SearchUseCases()
    }
    
    init(searchUseCases: SearchUseCases) {
        self.searchUseCases = searchUseCases
    }
    
    // MARK: - Functions
    
    func searchMore() async {
        guard let keyword else { return }
        await search(with: keyword)
    }
    
    func search(with keyword: String) async {
        if isLastPage {
            await MainActor.run {
                delegate?.searchResultDidChange()
            }
            return
        }
        self.keyword = keyword
        
        do {
            let result = try await searchUseCases.search(with: keyword, at: currentPage)
            if result.isEmpty { isLastPage = true }
            else {
                self.searchResult.append(contentsOf: result)
                self.currentPage += Metric.pageSize
            }
            
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
