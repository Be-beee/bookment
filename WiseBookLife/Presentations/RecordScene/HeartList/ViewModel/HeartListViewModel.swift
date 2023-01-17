//
//  HeartListViewModel.swift
//  WiseBookLife
//
//  Created by 서보경 on 2023/01/17.
//  Copyright © 2023 서보경. All rights reserved.
//

import Foundation

import RealmSwift

final class HeartListViewModel {
    
    // MARK: - Properties
    
    private var heartList: [HeartContent] = [] {
        didSet {
            delegate?.heartListDidChange()
        }
    }
    private let bookInfoRepository: BookInfoRepository
    
    weak var delegate: HeartListViewModelDelegate?
    
    // MARK: - Computed Properties
    
    var count: Int { heartList.count }
    
    // MARK: - Init(s)
    
    init() {
        bookInfoRepository = BookInfoLocalRepository()
    }
    
    // MARK: - Load Functions
    
    func loadHeartContents() {
        let loaded: Results<HeartContent> = DatabaseManager.shared.load()
        heartList = Array(loaded)
    }
    
    // MARK: - Find Functions
    
    func find(at index: Int) -> BookInfo? {
        let loaded = bookInfoRepository.find(with: heartList[index])
        return loaded
    }
    
}
