//
//  SongCell.swift
//  MusicRoom
//
//  Created by jdavin on 11/3/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SongCell: UICollectionViewCell {
    var rootVC: UIViewController?
    var track: Track! {
        didSet {
            titleLabel.textColor = .white
            if track.id == currentTrack?.id {
                titleLabel.textColor = UIColor(red: 30 / 255, green: 180 / 255, blue: 30 / 255, alpha: 1)
            }
            authorLabel.text = track.artist!.name
            titleLabel.text = track.title
            let sec = track.duration % 60
            if sec < 10 {
                timeLabel.text = String(track.duration / 60) + ":0" + String(sec)
            } else {
                timeLabel.text = String(track.duration / 60) + ":" + String(sec)
            }
            imageView.loadImageUsingCacheWithUrlString(urlString: (track.album!.cover_big!))
            titleLabel.textColor = .white
            if track.id == currentTrack?.id {
                titleLabel.textColor = UIColor(red: 30 / 255, green: 180 / 255, blue: 30 / 255, alpha: 1)
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
    
    let timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dotsLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.isUserInteractionEnabled = true
        return label
    }()
    
    @objc func addTrackToPlaylist() {
        songDetail.track = track
        songDetail.imageView.image = imageView.image
        songDetail.showView()
    }
    
    func setupViews() {
        dotsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addTrackToPlaylist)))
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(timeLabel)
        addSubview(dotsLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dotsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dotsLabel.topAnchor.constraint(equalTo: topAnchor),
            dotsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            dotsLabel.widthAnchor.constraint(equalToConstant: 40),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: dotsLabel.leadingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            authorLabel.heightAnchor.constraint(equalToConstant: 13),
            timeLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 3),
            timeLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
            timeLabel.heightAnchor.constraint(equalToConstant: 13),
        ])
    }
}



class SeeAllSongsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let messageLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "See all songs"
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "allSongs_icon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()
    
    func setupViews() {
        addSubview(messageLabel)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant: 40),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 15),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
