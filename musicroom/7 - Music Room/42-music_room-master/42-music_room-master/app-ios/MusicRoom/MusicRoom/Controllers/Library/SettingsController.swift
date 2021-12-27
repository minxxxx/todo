//
//  SettingsController.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 10/30/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleSignIn
import FBSDKLoginKit
class SettingsController: UIViewController, DeezerSessionDelegate {
    var user : User?
    var deezerButton : UIButton?

    @objc func handleDeezer() {
        guard let manager = DeezerManager.sharedInstance.deezerConnect else { return }
        manager.sessionDelegate = self
        deezerManager.deezerConnect = manager
        if userManager.currentUser?.deezer_token == nil {
            manager.authorize([DeezerConnectPermissionEmail, DeezerConnectPermissionBasicAccess])
        } else {
            manager.logout()
            userManager.currentUser?.deezer_token = nil
            userManager.save()
            updateButton()
        }
        playerController.linkPlayerWithDeezer()
    }
    func deezerDidLogin() {
        let user = userManager.currentUser
        if user != nil {
            user!.deezer_token = deezerManager.deezerConnect?.accessToken
            userManager.save()
            apiManager.giveDeezerToken(user!)
            updateButton()
            
        }
    }
    
    
    let loginTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.backgroundColor = UIColor.gray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.attributedPlaceholder = NSAttributedString(string: "Change your password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.backgroundColor = UIColor.gray
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let passBisTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.attributedPlaceholder = NSAttributedString(string: "Verify your password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.backgroundColor = UIColor.gray
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    
    @objc func disconnectUser() {
        if userManager.logedWith == .fb {
            let manager = LoginManager()
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            manager.loginBehavior = .web
            manager.logOut()
        }
        else if userManager.logedWith == .google {
            let manager = GIDSignIn.sharedInstance()
            manager!.signOut()
            
        }
        userManager.deleteAllData()
        userManager.save()
        URLCache.shared.removeAllCachedResponses()
        let cookies = HTTPCookieStorage.shared
        let toDel = cookies.cookies
        for cookie in toDel! {
            cookies.deleteCookie(cookie)
        }
        let nav = CustomNavigationController(rootViewController: AuthenticationController())
        let kwin = UIApplication.shared.keyWindow
        UIView.transition(with: kwin!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            kwin?.rootViewController = nav
        })
        
    }
    
    @objc func updateUser() {
        let log = loginTF.text! == user!.login
        let pass = passTF.text! == passBisTF.text! && passTF.text! != ""
        var ret : [String : String] = [:]
        if !log && !pass {
            ret = ["login" : loginTF.text!]
        } else if pass && !log {
            ret = ["login": loginTF.text!, "password": passTF.text!]
        }
        else if pass && log {
            ret = ["password": passTF.text!]
        }
        if ret != [:] {
            let data = try? JSONSerialization.data(withJSONObject: ret, options: [])
            apiManager.updateUser(data!, completion: { (ret) in
                if ret != nil && ret!.count > 0 {
                    if ret["error"] == nil {
                        ToastView.shared.short(self.view, txt_msg: "Your account has been updated", color:  UIColor(red: 40 / 255, green: 210 / 255, blue: 40 / 255, alpha: 1))
                    }
                }
            })
        }
        return
    }
    
    func updateButton() {
        let text = userManager.currentUser?.deezer_token == nil ? "Link with Deezer" : "Unlink with Deezer"
        deezerButton!.setAttributedTitle(NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Save", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        apiManager.getMe(userManager.currentUser!.token!) { (user) in
            self.user = user
            self.setupButton()
        }
    }
    @objc func deleteUser() {
        let deleteAlert = UIAlertController(title: "Delete", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
            apiManager.deleteUserById()
            self.disconnectUser()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            return ;
        }))
        self.present(deleteAlert, animated: true, completion: nil)
        
    }
    
    func setupButton() {
        let logout = UIButton(type:.roundedRect)
        logout.backgroundColor = UIColor.gray
        logout.layer.cornerRadius = 8
        logout.setAttributedTitle(NSAttributedString(string: "Disconnect", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        let delete = UIButton(type:.roundedRect)
        delete.backgroundColor = UIColor.red
        delete.layer.cornerRadius = 8
        delete.setAttributedTitle(NSAttributedString(string: "Delete your account", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        
        loginTF.text = user?.login ?? "bouh"
        view.addSubview(loginTF)
        view.addSubview(passTF)
        view.addSubview(passBisTF)
        deezerButton = UIButton(type: .roundedRect)
        deezerButton!.titleEdgeInsets = UIEdgeInsets(top: -10,left: -10,bottom: -10,right: -10)
        deezerButton!.backgroundColor = UIColor.gray
        deezerButton!.layer.cornerRadius = 8
        updateButton()
        logout.addTarget(self, action: #selector(disconnectUser), for: .touchUpInside)
        logout.translatesAutoresizingMaskIntoConstraints = false
        delete.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
        delete.translatesAutoresizingMaskIntoConstraints = false
        deezerButton!.addTarget(self, action: #selector(handleDeezer), for: .touchUpInside)
        view.addSubview(deezerButton!)
        view.addSubview(logout)
        view.addSubview(delete)
        deezerButton!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deezerButton!.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            deezerButton!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            deezerButton!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logout.topAnchor.constraint(equalTo: deezerButton!.bottomAnchor , constant: 20),
            logout.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            logout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            delete.topAnchor.constraint(equalTo: logout.bottomAnchor , constant: 20),
            delete.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            delete.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginTF.topAnchor.constraint(equalTo: delete.bottomAnchor , constant: 20),
            loginTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            loginTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passTF.topAnchor.constraint(equalTo: loginTF.bottomAnchor , constant: 20),
            passTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            passTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passBisTF.topAnchor.constraint(equalTo: passTF.bottomAnchor , constant: 20),
            passBisTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            passBisTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ])
    }
}
