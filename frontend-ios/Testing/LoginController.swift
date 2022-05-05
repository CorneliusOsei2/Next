//
//  LoginController.swift
//  Testing
//
//  Created by Derek Sanchez on 4/30/22.
//

import Foundation
import UIKit
import SwiftUI

class LoginController: UIViewController {
    
    // UserDefaults initialization for storing session tokens
    let userDefaults = UserDefaults.standard
    
    let buttonHeight = 40
    let textFieldHeight = 66
    
    private let titleLabel = UILabel()
    
    lazy var header: UILabel = {
        let title = UILabel()
        title.text = "Login"
        title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        title.font = .systemFont(ofSize: 72, weight: .bold)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        
        return title
    }()
    
    lazy var sprite: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "Sprite")
        img.layer.cornerRadius = 40
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(img)
        
        return img
    }()
    
    lazy var userField: UITextField = {
        var user = UITextField()
        user.frame = CGRect(x: 0, y: 0, width: 313, height: 66)
        user.backgroundColor = .white

        user.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        user.layer.cornerRadius = 25
        user.layer.borderWidth = 1
        user.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor

        user.placeholder = "  Cornell NetID"
        user.textColor = .gray
        user.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(user)

        return user
    }()
    
    lazy var passwordField: UITextField = {
        var user = UITextField()
        user.frame = CGRect(x: 0, y: 0, width: 313, height: 66)
        user.backgroundColor = .white

        user.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        user.layer.cornerRadius = 25
        user.layer.borderWidth = 1
        user.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor

        user.placeholder = "  Password"
        user.textColor = .gray
        user.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(user)
        
        return user
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        view.addSubview(button)
        return button
    }()
    
    func setGradientBackground() {
//        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
//        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
                      UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
                      UIColor(red: 0.783, green: 1, blue: 0.961, alpha: 0.7).cgColor,
                      UIColor(red: 0.783, green: 1, blue: 0.961, alpha: 0.7).cgColor
        ]
        gradientLayer.locations = [0, 0.96, 1]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    override func viewDidLoad() {
        print("Trace Login Controller")
        super.viewDidLoad()
        let _ = header
        let _ = sprite
        let _ = userField
        let _ = passwordField
        let _ = loginButton
        view.backgroundColor = .white
        setGradientBackground()
        setupConstraints()
    }
    
    func setupConstraints() {
        sprite.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.height.width.equalTo(80)
            make.centerX.equalToSuperview()
        }
        header.snp.makeConstraints { make in
            make.top.equalTo(sprite.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        userField.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(18)
            make.width.equalTo(view.frame.width * (313.0 / 375.0))
            make.height.equalTo(textFieldHeight)
            make.centerX.equalToSuperview()
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(userField.snp.bottom).offset(30)
            make.width.equalTo(view.frame.width * (313.0 / 375.0))
            make.height.equalTo(textFieldHeight)
            make.centerX.equalToSuperview()
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(54)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(view.frame.width * (165.0 / 375.0))
            make.centerX.equalToSuperview()
        }
        
    }
    
    @objc func loginAction() {
        let username = userField.text ?? ""
        let password = passwordField.text ?? ""
        
        NetworkManager.login(forUsername: username, forPassword: password) { loginResponse in
            self.userDefaults.set(loginResponse.session_token, forKey: Constants.UserDefaults.sessionToken)
            self.userDefaults.set(loginResponse.update_token, forKey: Constants.UserDefaults.updateToken)
            
            // Login successful
            UIApplication.shared.windows.first?.rootViewController = CustomTabBarViewController()
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: add code to check if session token exists
    }
    
}


