//
//  NetworkManager.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    // MARK: - Properties

    static let shared = NetworkManager()
    
}

// MARK: - Fetch Functions

extension NetworkManager {
    
    func fetch<T: Codable>(request: URLRequest) async throws -> T {
        let fetchedData = try await fetchData(request: request)
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: fetchedData)
            return decoded
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    func fetchData(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
    
}

// MARK: - Create Request Functions

extension NetworkManager {
    
    func createRequest(
        base: String,
        path: String,
        query: [String: String?]? = nil,
        method: HTTPMethod,
        header: [String: String]? = nil,
        body: Data? = nil
    ) throws -> URLRequest {
        var components = URLComponents(string: base + path)
        components?.queryItems = query?.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        guard let url = components?.url
        else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        header?.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.key) })
        request.httpBody = body
        
        return request
    }
    
}
