//
//  SearchEventsCell.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/27/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SearchEventsCell: UITableViewCell {
    var rootTarget: UITableViewController?
    var title : String?
    var type : EventType = .others
    var event: [Event]? {
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
        label.text = title != nil ? title! : ""
        backgroundColor = .clear
        let eventsCollectionView = EventCollectionView(event!, .horizontal, rootTarget, type)
        eventsCollectionView.removeFromSuperview()
        eventsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(eventsCollectionView)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
            eventsCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            eventsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            eventsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            eventsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
