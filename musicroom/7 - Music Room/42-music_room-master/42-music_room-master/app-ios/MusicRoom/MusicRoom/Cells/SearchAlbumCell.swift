//
//  SearchAlbumCell.swift
//  MusicRoom
//
//  Created by jdavin on 11/14/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SearchAlbumCell: UITableViewCell {

    var rootTarget: UITableViewController?
    var albums: [Album]? {
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
        label.text = "Albums"
        backgroundColor = .clear
        let albumCollectionView = AlbumCollectionView(albums!, .horizontal, rootTarget)
        albumCollectionView.removeFromSuperview()
        albumCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(albumCollectionView)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
            albumCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            albumCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            albumCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
