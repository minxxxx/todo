//
//  AlbumCollectionView.swift
//  MusicRoom
//
//  Created by jdavin on 11/14/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class AlbumCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let albums: [Album]
    let rootTarget: UITableViewController?
    private let albumCellId = "albumCellId"
    
    
    init(_ albums: [Album], _ scrollDirection: UICollectionViewScrollDirection, _ rootTarget: UITableViewController?) {
        self.rootTarget = rootTarget
        self.albums = albums
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
        register(AlbumCell.self, forCellWithReuseIdentifier: albumCellId)
        backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let root = rootTarget as? SearchController {
            let cell = cellForItem(at: indexPath) as! AlbumCell
            root.showAlbumContent(albums[indexPath.item], cell.imageView.image!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: albumCellId, for: indexPath) as! AlbumCell
        cell.album = albums[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
}
