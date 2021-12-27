//
//  RegisterController.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/7/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {
    let userManager : UserManager = UserManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        
        loginTF.delegate = self
        loginTF.tag = 0
        emailTF.delegate = self
        emailTF.tag = 1
        passTF.delegate = self
        passTF.tag = 2
        setupView()
        setupButton()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0 : emailTF.becomeFirstResponder()
        case 1 : passTF.becomeFirstResponder()
        case 2 : handleRegister()
        default : return true
        }
        return true
    }
    
    let loginTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.attributedPlaceholder = NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.backgroundColor = UIColor.gray
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    func setupButton() {
        let button = UIButton(type: .roundedRect)
        button.titleEdgeInsets = UIEdgeInsets(top: -10,left: -10,bottom: -10,right: -10)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 8
        button.setAttributedTitle(NSAttributedString(string: "Register", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: passTF.bottomAnchor, constant: 10),
            button.widthAnchor.constraint(equalTo: passTF.widthAnchor, multiplier: 0.3),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
    let welcomeTF : UILabel = {
        let tf = UILabel()
        tf.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        tf.textAlignment = .center
        tf.text = "Music Room"
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let imageDeezer : UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    let passTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tf.textAlignment = .center
        tf.backgroundColor = UIColor.gray
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let emailTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tf.textAlignment = .center
        tf.backgroundColor = UIColor.gray
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    @objc func handleRegister() {
        let apiManager = APIManager()
        guard let login = loginTF.text, let mail = emailTF.text, let pass = passTF.text else { return }
        let json = [
            "login" : login,
            "email" : mail,
            "password" : pass
        ]
        let data = try? JSONSerialization.data(withJSONObject: json, options: [])
        apiManager.registerUser(data)
        ToastView.shared.short(self.view, txt_msg: "Please now verify your account", color: UIColor.blue)
    }
    
    func setupView() {
        self.view.addSubview(loginTF)
        self.view.addSubview(passTF)
        self.view.addSubview(welcomeTF)
        self.view.addSubview(imageDeezer)
        self.view.addSubview(emailTF)
        imageDeezer.image = UIImage(named: "logo_deezer")
        NSLayoutConstraint.activate([
            imageDeezer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            imageDeezer.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            imageDeezer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            imageDeezer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            welcomeTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier : 0.9),
            welcomeTF.topAnchor.constraint(equalTo: imageDeezer.bottomAnchor, constant: 0),
            welcomeTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            loginTF.topAnchor.constraint(equalTo: welcomeTF.bottomAnchor, constant: 75),
            loginTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            emailTF.topAnchor.constraint(equalTo: loginTF.bottomAnchor, constant: 10),
            emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            passTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 10),
            passTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            ])
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
