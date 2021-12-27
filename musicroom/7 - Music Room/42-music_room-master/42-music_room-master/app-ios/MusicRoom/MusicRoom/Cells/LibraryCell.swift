//
//  LibraryCell.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 11/19/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class LibraryCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconView0: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let iconView1: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "allSongs_icon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupView() {
        backgroundColor = .clear
        addSubview(iconView0)
        addSubview(titleLabel)
        addSubview(iconView1)
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            iconView0.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView0.heightAnchor.constraint(equalToConstant: 20),
            iconView0.widthAnchor.constraint(equalToConstant: 20),
            iconView0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: iconView0.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: iconView1.leadingAnchor, constant: -14),
            
            iconView1.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView1.heightAnchor.constraint(equalToConstant: 15),
            iconView1.widthAnchor.constraint(equalToConstant: 20),
            iconView1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
