//
//  NetworkManager.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/12/23.
//  Copyright © 2022 서보경. All rights reserved.
//

import Foundation

import RxSwift

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

// MARK: - Fetch Functions (RxSwift)

extension NetworkManager {
    func fetchRx<T: Codable>(request: URLRequest) -> Observable<T> {
        let fetchedData = fetchDataRx(request: request)
        
        return fetchedData.map({ data in
            do {
                let decoded: T = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodingFailed
            }
        })
    }
    
    func fetchDataRx(request: URLRequest) -> Observable<Data> {
        return Observable<Data>.create { emitter in
            let task = URLSession.shared.dataTask(with: request) { data, _, _ in

                guard let data = data else {
                    emitter.onError(NetworkError.invalidResponse)
                    return
                }
                
                emitter.onNext(data)
                emitter.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

// MARK: - Create Request Functions

extension NetworkManager {
    
    func createRequest(
        endpoint: Endpoint,
        query: [String: String?]? = nil,
        header: [String: String]? = nil,
        body: Data? = nil
    ) throws -> URLRequest {
        var components = URLComponents(string: endpoint.path)
        components?.queryItems = query?.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        guard let url = components?.url
        else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        header?.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.key) })
        request.httpBody = body
        
        return request
    }
    
}
