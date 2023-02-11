//
//  SearchRemoteRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

import RxSwift

final class SearchRemoteRepository: SearchRepository {
    
    // MARK: - Properties
    
    let networkManager = NetworkManager.shared
 
    // MARK: - Search Functions
    
    func search(with keyword: String, at page: Int) async throws -> [BookInfoResponseDTO] {
        let clientData = ClientData()
        let query = [
            "query": keyword,
            "start": String(page)
        ]
        let request = try networkManager.createRequest(
            endpoint: Endpoint.search,
            query: query,
            header: clientData.requestHeader
        )
        
        let result: SearchResponseDTO = try await networkManager.fetch(request: request)
        
        return result.items
    }
    
    // MARK: - Search Functions (RxSwift)
    
    func searchRx(
        with keyword: String,
        at page: Int
    ) throws -> Observable<[BookInfoResponseDTO]> {
        let clientData = ClientData()
        let query = [
            "query": keyword,
            "start": String(page)
        ]
        let request = try networkManager.createRequest(
            endpoint: Endpoint.search,
            query: query,
            header: clientData.requestHeader
        )
        
        let result: Observable<SearchResponseDTO> = networkManager.fetchRx(request: request)
        
        return result.map { $0.items }
    }
    
}
