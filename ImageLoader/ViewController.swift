//
//  ViewController.swift
//  ImageLoader
//
//  Created by Eshwar Ramesh on 07/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var imageUrls: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        loadMediaCoverages()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width / 3) - 4, height: (view.frame.size.width / 3) - 4)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let nib = UINib(nibName: ImageCollectionViewCell.name(), bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: ImageCollectionViewCell.name())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemPink
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func loadMediaCoverages() {
        NetworkManager.shared.fetchMediaCoverages { [weak self] result in
            switch result {
            case .success(let coverages):
                self?.imageUrls = coverages.compactMap { self?.constructImageURL(from: $0.thumbnail) }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching media coverages: \(error)")
            }
        }
    }
    
    private func constructImageURL(from thumbnail: Thumbnail) -> URL? {
        let urlString = "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key)"
        return URL(string: urlString)
    }

    private func loadImageForVisibleCells() {
        for indexPath in collectionView.indexPathsForVisibleItems {
            let imageUrl = imageUrls[indexPath.row]
            let key = imageUrl.lastPathComponent
            ImageManager.shared.loadImage(forKey: key, url: imageUrl, indexPath: indexPath) { image in
                DispatchQueue.main.async {
                    if let visibleCell = self.collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                        visibleCell.configure(with: key, url: imageUrl, indexPath: indexPath)
                    }
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.name(), for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Unable to dequeue ImageCollectionViewCell")
        }

        let imageUrl = imageUrls[indexPath.row]
        debugPrint("image url : \(imageUrl) for indexpath : \(indexPath)")
        let key = imageUrl.lastPathComponent  // unique caching key
        cell.configure(with: key, url: imageUrl, indexPath: indexPath)
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImageForVisibleCells()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImageForVisibleCells()
    }
}


