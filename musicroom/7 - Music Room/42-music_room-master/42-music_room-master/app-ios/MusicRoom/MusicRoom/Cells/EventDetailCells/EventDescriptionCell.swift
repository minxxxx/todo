//
//  EventDescriptionCell.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 12/11/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class EventDescriptionCell: UITableViewCell {
    let descriptionLabel = UILabel()
    
    let separator: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    var     message: String? {
        didSet {
            if let text = message {
                descriptionLabel.text = "\(text)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(descriptionLabel)
        addSubview(separator)
        
        backgroundColor = UIColor(white: 0.1, alpha: 1)
        selectionStyle = .none
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let constraints = [
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14)
        trailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14)
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
