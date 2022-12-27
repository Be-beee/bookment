//
//  ImageDownloader.swift
//  WiseBookLife
//
//  Created by 서보경 on 2022/05/29.
//  Copyright © 2022 서보경. All rights reserved.
//

import UIKit

class ImageDownloader {
    
    static func urlToImage(from url: String) async -> UIImage? {
        do {
            let networkManager = NetworkManager.shared
            let request = try networkManager.createRequest(endpoint: .image(url))
            let imageData = try await networkManager.fetchData(request: request)
            return UIImage(data: imageData)
        } catch {
            return UIImage(named: "No_Img.png")
        }
    }
}
