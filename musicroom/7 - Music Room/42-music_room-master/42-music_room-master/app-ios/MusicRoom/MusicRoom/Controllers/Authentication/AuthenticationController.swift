//
//  AuthenticationController.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/7/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class AuthenticationController: UIViewController {
    
    let imageDeezer : UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.image = #imageLiteral(resourceName: "deezer_logo")
        return iv
    }()
    
    let backgroundImage : UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.image = #imageLiteral(resourceName: "deezer_logo")
        return iv
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    let darkView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor(red: 40 / 255, green: 210 / 255, blue: 40 / 255, alpha: 1)
        button.layer.cornerRadius = 17
        button.setAttributedTitle(NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 17
        button.setAttributedTitle(NSAttributedString(string: "Register", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        let nav = navigationController as? CustomNavigationController
        nav?.animatedHideNavigationBar()
        setupView()
    }
    
    let welcomeTF : UILabel = {
        let tf = UILabel()
        tf.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        tf.textAlignment = .left
        tf.text = "Music Room"
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14, weight: .medium)]), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let maskView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let separatorView : UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateTitle()
    }
    
    func animateUpLogoView() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.imageDeezer.transform = CGAffineTransform(translationX: 0, y: -75)
            self.separatorView.transform = CGAffineTransform(translationX: 0, y: -75)
            self.maskView.transform = CGAffineTransform(translationX: 0, y: -75)
            self.registerButton.alpha = 0
            self.loginButton.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.cancelButton.transform = .identity
            self.loginView!.transform = .identity
        })
    }
    
    @objc func animateDownLogoView() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.imageDeezer.transform = .identity
            self.separatorView.transform = .identity
            self.maskView.transform = .identity
            self.registerButton.alpha = 1
            self.loginButton.alpha = 1
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.cancelButton.transform = CGAffineTransform(translationX: 0, y: 100)
            self.loginView!.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        })
    }
    
    @objc func handleLoginView() {
        animateUpLogoView()
    }
    
    @objc func handleRegisterView() {
        self.navigationController?.pushViewController(RegisterController(), animated: true)
    }
    
    func animateTitle() {
        UIView.animate(withDuration: 1.4, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.imageDeezer.transform = .identity
            self.separatorView.transform = .identity
            self.maskView.transform = .identity
            self.separatorView.alpha = 1
        })
        UIView.animate(withDuration: 1, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.welcomeTF.transform = .identity
            self.registerButton.alpha = 1
            self.loginButton.alpha = 1
        })
    }
    
    var loginView: UIView?
    
    func setupView() {
        let loginController = LoginController()
        addChildViewController(loginController)
        loginController.rootController = self
        loginView = loginController.view
        
        
        view.addSubview(backgroundImage)
        view.addSubview(blurEffectView)
        view.addSubview(darkView)
        view.addSubview(maskView)
        maskView.addSubview(welcomeTF)
        view.addSubview(imageDeezer)
        view.addSubview(separatorView)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(loginView!)
        view.addSubview(cancelButton)
        
        
        loginButton.addTarget(self, action: #selector(handleLoginView), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegisterView), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(animateDownLogoView), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            darkView.topAnchor.constraint(equalTo: view.topAnchor),
            darkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            darkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            darkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageDeezer.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            imageDeezer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.14),
            imageDeezer.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.25),
            imageDeezer.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.25),
            
            separatorView.leadingAnchor.constraint(equalTo: imageDeezer.trailingAnchor, constant: 4),
            separatorView.topAnchor.constraint(equalTo: imageDeezer.topAnchor, constant: 15),
            separatorView.heightAnchor.constraint(equalTo: imageDeezer.heightAnchor, constant: -30),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            
            maskView.topAnchor.constraint(equalTo: imageDeezer.topAnchor),
            maskView.bottomAnchor.constraint(equalTo: imageDeezer.bottomAnchor),
            maskView.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            maskView.widthAnchor.constraint(equalToConstant: view.bounds.width * (0.45)),
            
            welcomeTF.leadingAnchor.constraint(equalTo: maskView.leadingAnchor, constant: 4),
            welcomeTF.widthAnchor.constraint(lessThanOrEqualToConstant: 500),
            welcomeTF.topAnchor.constraint(equalTo: maskView.topAnchor),
            welcomeTF.bottomAnchor.constraint(equalTo: maskView.bottomAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.16),
            loginButton.heightAnchor.constraint(equalToConstant: 34),
            loginButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.25),
            
            registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.16),
            registerButton.heightAnchor.constraint(equalToConstant: 34),
            registerButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.25),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 300),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            
            loginView!.topAnchor.constraint(equalTo: view.topAnchor),
            loginView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        initialTransform()
    }
    
    private func initialTransform() {
        welcomeTF.transform = CGAffineTransform(translationX: -view.bounds.width * (0.45), y: 0)
        imageDeezer.transform = CGAffineTransform(translationX: view.bounds.width * (0.5 - 0.125 - 0.14), y: 0)
        separatorView.transform = CGAffineTransform(translationX: view.bounds.width * (0.5 - 0.125 - 0.14), y: 0)
        maskView.transform = CGAffineTransform(translationX: view.bounds.width * (0.5 - 0.125 - 0.14), y: 0)
        cancelButton.transform = CGAffineTransform(translationX: 0, y: 100)
        loginView!.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        registerButton.alpha = 0
        loginButton.alpha = 0
        separatorView.alpha = 0
    }
}

