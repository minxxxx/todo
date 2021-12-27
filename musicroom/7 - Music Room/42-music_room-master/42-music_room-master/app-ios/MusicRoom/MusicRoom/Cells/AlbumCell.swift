//
//  AlbumCell.swift
//  MusicRoom
//
//  Created by jdavin on 11/3/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    var album: Album! {
        didSet {
            authorLabel.text = album.artist!.name
            titleLabel.text = album.title
            if let cover = album.cover_medium {
                imageView.loadImageUsingCacheWithUrlString(urlString: cover)
            } else {
                imageView.image = #imageLiteral(resourceName: "album_placeholder")
            }
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            authorLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
