//
//  ArtistsCollectionView.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 11/15/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class ArtistsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let artists: [Artist]
    let rootTarget: UITableViewController?
    private let artistCellId = "artistCellId"
    
    
    init(_ artists: [Artist], _ scrollDirection: UICollectionViewScrollDirection, _ rootTarget: UITableViewController?) {
        self.rootTarget = rootTarget
        self.artists = artists
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 14
        super.init(frame: .zero, collectionViewLayout: layout)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        register(ArtistCell.self, forCellWithReuseIdentifier: artistCellId)
        backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let root = rootTarget as? SearchController {
            let cell = cellForItem(at: indexPath) as! ArtistCell
            root.showArtistContent(artists[indexPath.item], cell.imageView.image!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: artistCellId, for: indexPath) as! ArtistCell
        cell.artist = artists[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 145)
    }
}

