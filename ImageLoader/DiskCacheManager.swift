//
//  DiskCacheManager.swift
//  ImageLoader
//
//  Created by Eshwar Ramesh on 07/05/24.
//

import Foundation
import UIKit

class DiskCacheManager {
    
    private func fileURL(for key: String) -> URL? {
        guard let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return directory.appendingPathComponent(key)
    }

    func set(image: UIImage, forKey key: String) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData(), let url = fileURL(for: key) else {
            return
        }
        try? data.write(to: url)
    }

    func get(forKey key: String) -> UIImage? {
        guard let url = fileURL(for: key), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }
}
