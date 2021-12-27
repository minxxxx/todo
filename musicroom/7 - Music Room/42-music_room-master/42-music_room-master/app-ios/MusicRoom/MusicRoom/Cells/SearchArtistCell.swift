//
//  SearchArtistCell.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 11/15/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SearchArtistCell: UITableViewCell {
    var rootTarget: UITableViewController?
    var artists: [Artist]? {
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
        label.text = "Artists"
        backgroundColor = .clear
        let artistsCollectionView = ArtistsCollectionView(artists!, .horizontal, rootTarget)
        artistsCollectionView.removeFromSuperview()
        artistsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(artistsCollectionView)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
            artistsCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            artistsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artistsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artistsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
