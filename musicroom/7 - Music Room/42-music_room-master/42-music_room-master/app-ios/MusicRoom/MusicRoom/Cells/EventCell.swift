//
//  EventCell.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/27/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    var event: Event! {
        didSet {

            authorLabel.text = event.creator?.login
            titleLabel.text = event.title
            imageView.image = #imageLiteral(resourceName: "album_placeholder")
            if let cover = event.picture {
                apiManager.getImgEvent(cover, completion: { (img) in
                    if img != nil {
                        DispatchQueue.main.async {
                            self.imageView.image = img
                        }
                        
                    }
                })
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
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
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
