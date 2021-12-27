//
//  AlbumTrackListCell.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 11/12/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class AlbumTrackListCell: UITableViewCell {
    var isInPlaylist = false
    var rootController: UITableViewController?
    var indexPath: IndexPath?
    var type : EventType = .others
    var iAmAdmin : Bool = false
    var iAmMember : Bool = false
    var icon : UIImage = #imageLiteral(resourceName: "plus_icon")
    var track: Track? {
        didSet {
            titleLabel.text = track?.title
            titleLabel.textColor = .white
            if track?.id == currentTrack?.id {
                titleLabel.textColor = UIColor(red: 20 / 255, green: 220 / 255, blue: 20 / 255, alpha: 1)
            }
            if isInPlaylist || iAmAdmin || type == .mine{
                icon = #imageLiteral(resourceName: "minus_icon")
            }
            if iAmMember{
                let isLiked = likedTracks.first(where: { (id) -> Bool in
                    return track!._id! == id ? true : false
                })
                icon = #imageLiteral(resourceName: "upvote_icon")
                plusButton.tintColor = .white
                if isLiked != nil {
                    icon = #imageLiteral(resourceName: "upvoted_icon")
                    plusButton.tintColor = UIColor(red: 30 / 255, green: 180 / 255, blue: 30 / 255, alpha: 1)
                } else {
                    plusButton.tintColor = .white
                }
            }
            let tintedIcon = icon.withRenderingMode(.alwaysTemplate)
            plusButton.setImage(tintedIcon, for: .normal)
        }
    }
    
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
        
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
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
        return label
    }()
    
    let lockedIcon: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        iv.image = #imageLiteral(resourceName: "locked_icon")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.tintColor = UIColor(white: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.6)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleAddSong() {
        if iAmMember {
            let root = rootController as? PlaylistDetailController
            root?.toggleLike(id: track!._id!)
            let tintedIcon = icon.withRenderingMode(.alwaysTemplate)
            plusButton.setImage(tintedIcon, for: .normal)
           
          return
        }
        if type == .mine || iAmAdmin {
            let root = rootController as? PlaylistDetailController
            root?.deleteTrackFromPlaylist(track: track!, index: indexPath!)
            return
        }
        let root = rootController as? AlbumController
        root?.handleSongDetail(track!)
    }
    
    func setupView() {
        plusButton.addTarget(self, action: #selector(handleAddSong), for: .touchUpInside)
        addSubview(plusButton)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(dotsLabel)
        addSubview(separator)
        addSubview(lockedIcon)
        
        NSLayoutConstraint.activate([
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            plusButton.heightAnchor.constraint(equalToConstant: 18),
            plusButton.widthAnchor.constraint(equalToConstant: 18),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: dotsLabel.leadingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 7),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -5),
            authorLabel.heightAnchor.constraint(equalToConstant: 17),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            dotsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -14),
            dotsLabel.topAnchor.constraint(equalTo: topAnchor),
            dotsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            dotsLabel.widthAnchor.constraint(equalToConstant: 40),
            
            lockedIcon.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            lockedIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            lockedIcon.widthAnchor.constraint(equalToConstant: 40),
            lockedIcon.heightAnchor.constraint(equalToConstant: 20),
            
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
