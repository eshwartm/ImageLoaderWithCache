//
//  ImageCollectionViewCell.swift
//  ImageLoader
//
//  Created by Eshwar Ramesh on 07/05/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var innerContentView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(image: String) {
        //load image from image loader
    }
}
