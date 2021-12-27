//
//  SearchTrackCell.swift
//  MusicRoom
//
//  Created by jdavin on 11/14/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SearchTrackCell: UITableViewCell {
    var rootTarget: UITableViewController?
    var tracks: [Track]? {
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
        label.removeFromSuperview()
        label.text = "Songs"
        backgroundColor = .clear
        let songsCollectionView = SongsCollectionView(tracks!, .vertical, rootTarget)
        songsCollectionView.removeFromSuperview()
        songsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(songsCollectionView)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
            songsCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            songsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            songsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            songsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
