//
//  ListPlaylistCell.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 12/7/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class ListPlaylistCell: UITableViewCell {
    var rootTarget: PlaylistsController?
    var title : String?
    var type : EventType?
    var isEditable : Bool = false
    var isAddingSong = false
    var playlist: [Playlist]? {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView() {
        guard playlist != nil else { return }
        label.removeFromSuperview()
        label.text = title != nil ? title! : ""
        backgroundColor = .clear
        let playlistCollectionView = PlaylistCollectionView(playlist!, .horizontal, rootTarget)
        playlistCollectionView.isEditable = isEditable
        playlistCollectionView.eventCreation = false
        playlistCollectionView.type = type
        playlistCollectionView.removeFromSuperview()
        playlistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(playlistCollectionView)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
            playlistCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            playlistCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            playlistCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            playlistCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        playlistCollectionView.isAddingSong = isAddingSong
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
