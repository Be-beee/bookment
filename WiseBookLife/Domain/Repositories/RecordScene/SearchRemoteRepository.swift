//
//  SearchRemoteRepository.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

final class SearchRemoteRepository: SearchRepository {
    
    // MARK: - Properties
    
    let networkManager = NetworkManager.shared
 
    // MARK: - Search Functions
    
    func search(with keyword: String) async throws -> [BookInfoResponseDTO] {
        let clientData = ClientData()
        let request = try networkManager.createRequest(
            endpoint: Endpoint.search,
            header: clientData.requestHeader
        )
        
        let result: SearchResponseDTO = try await networkManager.fetch(request: request)
        
        return result.items
    }
    
}
