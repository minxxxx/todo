//
//  CreateButtonCell.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 12/7/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class CreateButtonCell: UITableViewCell {
    var vc : UICollectionView?
    var isCreating : Bool?
    var root: PlaylistsController?
    var rootEvents : EventsController?
    var title : String {
        didSet {
            setupView()
        }
    }
    
    let createButton: UIButton = {
        let createButton = UIButton(type: .system)
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.setTitleColor(.white, for: .normal)
        // createButton.setAttributedTitle(NSAttributedString(string: t"CREATE PLAYLIST", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15, weight: .heavy)]), for: .normal)
        createButton.layer.masksToBounds = true
        createButton.layer.cornerRadius = 40 / 2
        return createButton
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        title = ""
        root = nil
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func      handleCreate()
    {
        if rootEvents != nil {
            guard let tab = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else { return }
            
            UIView.transition(with: tab.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                tab.selectedIndex = 2
                guard let vc = tab.selectedViewController as? MapController else {return }
                vc.creating = true
                
            })
        }
        if isCreating != nil && isCreating! == true && root != nil{
            root!.createPlaylistPopUp()
        } else if root != nil {
            let vc = SearchDeezerPlaylistController()
            vc.root = self.root
            root!.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    
    func setupView() {
        createButton.setAttributedTitle(NSAttributedString(string: title , attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15, weight: .heavy)]), for: .normal)
        createButton.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            createButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
