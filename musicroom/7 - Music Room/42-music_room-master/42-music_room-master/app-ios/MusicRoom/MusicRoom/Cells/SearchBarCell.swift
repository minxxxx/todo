//
//  SearchBarCell.swift
//  MusicRoom
//
//  Created by jdavin on 11/1/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SearchBarCell: UITableViewCell, UITextFieldDelegate {
    
    var vc : UITableViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.delegate = self
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var placeholder : String? {
        didSet {
            if let p = placeholder {
                textField.placeholder = p
            }
        }
    }
    let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        tf.returnKeyType = .search
        tf.enablesReturnKeyAutomatically = true
        return tf
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSearch()
        return true
    }
    
    let containerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor(white: 0.1, alpha: 0.8).cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    @objc func      handleSearch()
    {
        guard let text = textField.text, text != "" else { return }
        if let vc = vc as? SearchController {
            vc.handleSearch(text)
        }
//        if let vc = vc as? HomeController {
//            vc.handleSearch(text)
//        }
    }
    
    func setupViews() {
        backgroundColor = .clear
        let searchButton = UIButton(type: .system)
        let searchIcon = UIImage(named: "search_icon")
        let tintedIcon = searchIcon?.withRenderingMode(.alwaysTemplate)
        searchButton.setImage(tintedIcon, for: .normal)
        searchButton.tintColor = UIColor(white: 0.2, alpha: 1)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        
        addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 14),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            containerView.heightAnchor.constraint(equalToConstant: 40),
            
            textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textField.rightAnchor.constraint(equalTo: searchButton.leftAnchor),
            textField.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            searchButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            searchButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 22),
            searchButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
