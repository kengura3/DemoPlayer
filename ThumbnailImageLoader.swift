//
//  ThumbnailImageLoader.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 02/11/2023.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badRequest
    case unsupportedImage
    case badUrl
}

@MainActor
class ThumbnailImageLoader : ObservableObject {
    
    @Published var uiImage: UIImage?
    
    func fetchImage(_ url: URL?) async throws {
        guard let url = url else {
            throw NetworkError.badUrl
        }
        
        let request = URLRequest(url: url)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.unsupportedImage
        }
        
        uiImage = image
        
    }
}
