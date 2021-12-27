//
//  EventCollectionView.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/27/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class EventCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let events: [Event]
    let rootTarget: UITableViewController?
    let type : EventType
    private let eventCellId = "eventCellId"
    
    
    init(_ events: [Event], _ scrollDirection: UICollectionViewScrollDirection, _ rootTarget: UITableViewController?, _ type: EventType) {
        self.rootTarget = rootTarget
        self.events = events
        self.type = type
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 14
        super.init(frame: .zero, collectionViewLayout: layout)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        register(EventCell.self, forCellWithReuseIdentifier: eventCellId)
        backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let root = rootTarget as? EventsController {
            if let cell = collectionView.cellForItem(at: indexPath) as? EventCell {
                root.presentSelectedEvent(events[indexPath.row], img: cell.imageView.image!, type : type)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: eventCellId, for: indexPath) as! EventCell
        cell.event = events[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
}
