//
//  NetworkManager.swift
//  ImageLoader
//
//  Created by Eshwar Ramesh on 07/05/24.
//

import Foundation

struct MediaCoverage: Codable {
    let id: String
    let title: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    let domain: String
    let basePath: String
    let key: String
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchMediaCoverages(completion: @escaping (Result<[MediaCoverage], Error>) -> Void) {
        let urlString = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=200"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data was nil"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode([MediaCoverage].self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
