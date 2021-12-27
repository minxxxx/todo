//
//  LoginController.swift
//  MusicRoom
//
//  Created by Etienne Tranchier on 06/11/2018.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn
import GoogleToolboxForMac

class LoginController: UIViewController, UITextFieldDelegate, GIDSignInDelegate ,GIDSignInUIDelegate, LoginButtonDelegate  {
    var googleButton : GIDSignInButton?
    var facebook : LoginButton?
    var rootController: AuthenticationController?
    
    let passTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.placeholder = "your password..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let loginTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.placeholder = "your email..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let choiceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Or ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16, weight: .heavy)])
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        GIDSignIn.sharedInstance().clientID = "479103948820-79bl5vfu07j3u6r28ur77pj76i8apu1l.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        loginTF.delegate = self
        passTF.delegate = self
        googleButton = GIDSignInButton()
        
        facebook = LoginButton(readPermissions: [ReadPermission.publicProfile, ReadPermission.email])
        facebook!.delegate = self
        setupView()
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
            rootController?.animateDownLogoView()
        case .success(_,_, let accessToken):
            apiManager.login("facebook", accessToken.authenticationToken, completion: { (data) in
                let d = data as [String : AnyObject]
                let user = userManager.newUser()
                user.token = d["token"] as? String
                user.login = (d["user"] as! [String : String])["login"]
                userManager.currentUser = user
                userManager.logedWith = .fb
                userManager.save()
                let kwin = UIApplication.shared.keyWindow
                let nav = TabBarController()
                UIView.transition(with: kwin!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    kwin?.rootViewController = nav
                })
            })
        }
    }
    
    @objc func handleLogin() {
        let apiManager = APIManager()
        guard let pass = passTF.text, let mail = loginTF.text else { return }
        let json = [
            "email" : mail.lowercased(),
            "password" : pass
        ]
        let data = try? JSONSerialization.data(withJSONObject: json, options: [])
        apiManager.loginUser(data) { (res) in
            if res != nil {
                let user = userManager.newUser()
                user.token = res?.token
                user.login = res?.user.login
                userManager.currentUser = user
                userManager.logedWith = .local
                userManager.save()
                let kwin = UIApplication.shared.keyWindow
                
                let nav = TabBarController()
                UIView.transition(with: kwin!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    kwin?.rootViewController = nav
                })
            }
        }
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logout")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
            rootController?.animateDownLogoView()
            return
        }
        apiManager.login("google", user.authentication.accessToken, completion:  { (data) in
            let d = data as [String : AnyObject]
            let user = userManager.newUser()
            user.token = d["token"] as? String
            user.login = (d["user"] as! [String : String])["login"]
            userManager.currentUser = user
            userManager.logedWith = .google
            userManager.save()
            let kwin = UIApplication.shared.keyWindow
            let nav = TabBarController()
            
            UIView.transition(with: kwin!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                kwin?.rootViewController = nav
            })
        })
    }
    
    let apiLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(red: 40 / 255, green: 210 / 255, blue: 40 / 255, alpha: 1)
        button.layer.cornerRadius = 8
        button.setAttributedTitle(NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let apiLoginContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 0.99, alpha: 0.9)
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let separatorView : UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupLoginContainer() {
        apiLoginContainer.addSubview(loginTF)
        apiLoginContainer.addSubview(passTF)
        apiLoginContainer.addSubview(separatorView)
        NSLayoutConstraint.activate([
            loginTF.topAnchor.constraint(equalTo: apiLoginContainer.topAnchor),
            loginTF.leadingAnchor.constraint(equalTo: apiLoginContainer.leadingAnchor, constant: 14),
            loginTF.trailingAnchor.constraint(equalTo: apiLoginContainer.trailingAnchor, constant: -14),
            loginTF.heightAnchor.constraint(equalToConstant: 40),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: apiLoginContainer.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: apiLoginContainer.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: loginTF.bottomAnchor),
            passTF.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            passTF.leadingAnchor.constraint(equalTo: apiLoginContainer.leadingAnchor, constant: 14),
            passTF.trailingAnchor.constraint(equalTo: apiLoginContainer.trailingAnchor, constant: -14),
            passTF.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setupView() {
        apiLoginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        googleButton!.translatesAutoresizingMaskIntoConstraints = false
        facebook!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleButton!)
        view.addSubview(facebook!)
        view.addSubview(choiceLabel)
        view.addSubview(apiLoginContainer)
        view.addSubview(apiLoginButton)
        NSLayoutConstraint.activate([
            googleButton!.topAnchor.constraint(equalTo: view.topAnchor, constant: 275),
            googleButton!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.12),
            googleButton!.heightAnchor.constraint(equalToConstant: 40),
            googleButton!.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.25),
            
            facebook!.topAnchor.constraint(equalTo: view.topAnchor, constant: 279),
            facebook!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.12 - 3),
            facebook!.heightAnchor.constraint(equalToConstant: 40),
            facebook!.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.30),
            
            choiceLabel.topAnchor.constraint(equalTo: facebook!.topAnchor),
            choiceLabel.bottomAnchor.constraint(equalTo: facebook!.bottomAnchor),
            choiceLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.14),
            choiceLabel.trailingAnchor.constraint(equalTo: facebook!.leadingAnchor),
            
            apiLoginContainer.topAnchor.constraint(equalTo: facebook!.bottomAnchor, constant: 50),
            apiLoginContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.12 - 3),
            apiLoginContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.12 + 3),
            apiLoginContainer.heightAnchor.constraint(equalToConstant: 81),
            
            apiLoginButton.topAnchor.constraint(equalTo: apiLoginContainer.bottomAnchor, constant: 50),
            apiLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.12 - 3),
            apiLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.12 + 3),
            apiLoginButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        setupLoginContainer()
    }
}

