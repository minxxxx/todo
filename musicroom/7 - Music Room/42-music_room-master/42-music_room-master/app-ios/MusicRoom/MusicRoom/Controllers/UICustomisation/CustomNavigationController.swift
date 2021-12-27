//
//  CustomNavigationController.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 10/30/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    var offsetY: CGFloat = 0.0
    
    let blurView: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        effect.isUserInteractionEnabled = false
        effect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }()
    let visualContainerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let lightView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15, weight: .heavy)]
        navigationBar.shadowImage = UIImage()
        offsetY = navigationBar.frame.size.height
        addVisualEffect()
    }
    
    func addVisualEffect() {
        navigationBar.addSubview(visualContainerView)
        visualContainerView.addSubview(lightView)
        visualContainerView.addSubview(blurView)
        NSLayoutConstraint.activate([
            visualContainerView.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: -50),
            visualContainerView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            visualContainerView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            visualContainerView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            
            blurView.topAnchor.constraint(equalTo: visualContainerView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: visualContainerView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: visualContainerView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: visualContainerView.trailingAnchor),
            
            lightView.topAnchor.constraint(equalTo: blurView.topAnchor),
            lightView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -50),
            lightView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            lightView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor)
        ])
        visualContainerView.layer.zPosition = -1
    }
    
    func animatedShowNavigationBar() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualContainerView.transform = CGAffineTransform.identity
        })
    }
    
    func animatedHideNavigationBar() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualContainerView.transform = CGAffineTransform(translationX: 0, y: -self.offsetY - 50)
        })
    }
}
