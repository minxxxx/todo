//
//  PlaylistCollectionView.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 11/19/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class PlaylistCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var selectedPlaylist : Playlist?
    var eventCreation : Bool = false
    var isEditable = false
    var isAddingSong = false
    var type : EventType?
    var myPlaylists: [Playlist]
    let rootTarget: PlaylistsController?
    var selectedCell : PlaylistCell?
    
    private let playlistCellId = "playlistCellId"
    private let buttonCellId = "buttonCellId"
    
    init(_ myPlaylists: [Playlist], _ scrollDirection: UICollectionViewScrollDirection, _ rootTarget: PlaylistsController?) {
        self.rootTarget = rootTarget
        self.myPlaylists = myPlaylists
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 14
        layout.scrollDirection = scrollDirection
        super.init(frame: .zero, collectionViewLayout: layout)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        delegate = self
        dataSource = self
        register(PlaylistCell.self, forCellWithReuseIdentifier: playlistCellId)
        showsHorizontalScrollIndicator = false
        contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = cellForItem(at: indexPath) as? PlaylistCell else { return }
        if eventCreation {
            if selectedCell != nil {
                selectedCell!.layer.borderColor = nil
                selectedCell!.layer.borderWidth = 0
            }
            selectedPlaylist = myPlaylists[indexPath.row]
            selectedCell = cell
            selectedCell!.layer.borderColor = UIColor.gray.cgColor
            selectedCell!.layer.borderWidth = 2
        }
        if isAddingSong {
            rootTarget?.addSongToPlaylist(cell.playlist)
            return
        }
        let vc = PlaylistDetailController(myPlaylists[indexPath.item], cell.imageView.image!)
        if cell.isEditable {
            vc.isEditable = true
        }
        if type != nil {
            vc.type = type!
        }
        rootTarget?.navigationController?.pushViewController(vc, animated: true)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPlaylists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: playlistCellId, for: indexPath) as! PlaylistCell
        cell.playlist = myPlaylists[indexPath.row]
        cell.isEditable = self.isEditable
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 200)
    }
    
    
}
