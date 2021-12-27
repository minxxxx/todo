//
//  AlbumHeaderView.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 11/12/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class AlbumHeaderView: UIView {
    let albumCover: UIImage
    var playlistDetailController: PlaylistDetailController?
    let title: String
    var playlist: Playlist?
    var isEditable: Bool = false {
        didSet {
            if isEditable {
                addEditableFeature()
            }
        }
    }
    
    init(frame: CGRect, albumCover: UIImage, title: String) {
        self.albumCover = albumCover
        self.title = title
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let albumImageBackground: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let albumImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let blurView: UIView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            view.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor)
        ])
        return visualEffectView
    }()
    
    let dotsLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let editableContainer: playlistPrivacyContainerView = {
        let view = playlistPrivacyContainerView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    var titleBottomConstraint: NSLayoutConstraint?
    
    @objc func managePlaylistPrivacy() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.albumImageView.transform = CGAffineTransform(translationX: -self.frame.width, y: 0)
            self.titleLabel.transform = CGAffineTransform(translationX: -self.frame.width, y: 0)
            self.dotsLabel.transform = CGAffineTransform(translationX: -self.frame.width, y: 0)
            self.editableContainer.transform = .identity
        })
    }
    
    func backToDetails() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.albumImageView.transform = .identity
            self.titleLabel.transform = .identity
            self.dotsLabel.transform = .identity
            self.editableContainer.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
        })
    }
    
    
    func addEditableFeature() {
        guard let pl = playlist else { return }
        addSubview(dotsLabel)
        addSubview(editableContainer)
        NSLayoutConstraint.activate([
            dotsLabel.centerYAnchor.constraint(equalTo: albumImageView.centerYAnchor),
            dotsLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
            dotsLabel.heightAnchor.constraint(equalToConstant: 50),
            dotsLabel.widthAnchor.constraint(equalToConstant: 50),
            
            editableContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            editableContainer.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: -10),
            editableContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            editableContainer.heightAnchor.constraint(equalToConstant: 150)
        ])
        dotsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(managePlaylistPrivacy)))
        editableContainer.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
        editableContainer.rootView = self
        editableContainer.frame = frame
        editableContainer.playlist = pl
    }
    
    func setupView() {
        titleLabel.text = title
        
        albumImageBackground.image = albumCover
        albumImageView.image = albumCover
        addSubview(albumImageBackground)
        addSubview(blurView)
        addSubview(albumImageView)
        addSubview(titleLabel)
        titleBottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            albumImageBackground.topAnchor.constraint(equalTo: topAnchor),
            albumImageBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            albumImageBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            albumImageBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            albumImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            albumImageView.heightAnchor.constraint(equalToConstant: 190),
            albumImageView.widthAnchor.constraint(equalToConstant: 190),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            titleBottomConstraint!,
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
