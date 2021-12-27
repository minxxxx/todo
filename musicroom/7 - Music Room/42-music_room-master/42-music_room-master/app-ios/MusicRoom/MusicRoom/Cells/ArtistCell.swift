//
//  ArtistCell.swift
//  MusicRoom
//
//  Created by jdavin on 11/3/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class ArtistCell: UICollectionViewCell {
    var artist: Artist! {
        didSet {
            artistLabel.text = artist.name
            fanLabel.text = "\(artist.nb_fan!) fans"
            imageView.loadImageUsingCacheWithUrlString(urlString: artist.picture_medium!)
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
        iv.layer.cornerRadius = 50
        return iv
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fanLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(artistLabel)
        addSubview(fanLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            artistLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 1),
            artistLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            artistLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 29),
            fanLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor),
            fanLabel.leadingAnchor.constraint(equalTo: artistLabel.leadingAnchor),
            fanLabel.trailingAnchor.constraint(equalTo: artistLabel.trailingAnchor),
            fanLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
}
