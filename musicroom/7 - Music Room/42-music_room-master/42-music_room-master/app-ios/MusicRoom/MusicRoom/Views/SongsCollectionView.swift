//
//  SongsCollectionView.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 11/15/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SongsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let tracks: [Track]
    let rootTarget: UITableViewController?
    private let trackCellId = "trackCellId"
    private let seeAllSongsCellId = "seeAllSongsCellId"
    
    
    init(_ tracks: [Track], _ scrollDirection: UICollectionViewScrollDirection, _ rootTarget: UITableViewController?) {
        self.rootTarget = rootTarget
        self.tracks = tracks
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
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
        register(SongCell.self, forCellWithReuseIdentifier: trackCellId)
        register(SeeAllSongsCell.self, forCellWithReuseIdentifier: seeAllSongsCellId)
        backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let max = tracks.count
        if let searchController = rootTarget as? SearchController {
            if max < 4 && indexPath.item == max || indexPath.item == 4 {
                searchController.showTrackList()
                return
            }
            searchController.showPlayerForSong(indexPath.item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count <= 4 ? tracks.count + 1 : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let max = tracks.count
        if max < 4 && indexPath.item == max || indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: seeAllSongsCellId, for: indexPath) as! SeeAllSongsCell
            return cell
        } else {
            let cell = dequeueReusableCell(withReuseIdentifier: trackCellId, for: indexPath) as! SongCell
            cell.track = tracks[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let max = tracks.count
        if max < 4 && indexPath.item == max || indexPath.item == 4 {
            return CGSize(width: frame.width - 28, height: 40)
        } else {
            return CGSize(width: frame.width - 28, height: 60)
        }
    }
}

