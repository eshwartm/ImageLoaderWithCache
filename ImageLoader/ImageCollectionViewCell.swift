//
//  ImageCollectionViewCell.swift
//  ImageLoader
//
//  Created by Eshwar Ramesh on 07/05/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var innerContentView: UIView?
    @IBOutlet private weak var cellImageView: UIImageView?
    
    var indexPath: IndexPath = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        debugPrint("Cancelling load")
        cellImageView?.image = nil
        ImageManager.shared.cancelLoadFor(indexPath: self.indexPath)
    }
    
    func configure(with key: String, url: URL, indexPath: IndexPath) {
        self.indexPath = indexPath
        // Update the cell with new identifier and image
        ImageManager.shared.loadImage(forKey: key, url: url, indexPath: indexPath) { image in
            if let image {
                self.cellImageView?.image = image
            }
        }
    }
    
    static func name() -> String {
        return String(describing: self)
    }
}
