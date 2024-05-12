//
//  ImageManager.swift
//  ImageLoader
//
//  Created by Eshwar Ramesh on 07/05/24.
//

import Foundation
import UIKit

class ImageManager {
    static let shared = ImageManager()
    private let memoryCache = ImageCache.shared
    private let diskCache = DiskCacheManager()
    private var tasks = [IndexPath: URLSessionDataTask]()

    func loadImage(forKey key: String, url: URL, indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        // Cancel previous task if there was one
        cancelLoadFor(indexPath: indexPath)

        // Check memory cache first
        if let cachedImage = memoryCache.get(forKey: url.absoluteString) {
            completion(cachedImage)
            return
        }

        // Create a new task for the URL
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            // Cache the image
            self.memoryCache.set(image, forKey: url.absoluteString)
            self.diskCache.set(image: image, forKey: url.absoluteString)
            DispatchQueue.main.async { completion(image) }

            // Remove the task from the dictionary
            self.tasks.removeValue(forKey: indexPath)
        }

        // Save the task in case it needs to be cancelled
        tasks[indexPath] = task
        task.resume()
    }

    func cancelLoadFor(indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks.removeValue(forKey: indexPath)
    }
}

