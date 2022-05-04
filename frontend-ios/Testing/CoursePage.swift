//
//  CoursePage.swift
//  Testing
//
//  Created by Derek Sanchez on 5/4/22.
//

import Foundation
import UIKit
import SwiftUI

class LoginaController: UIViewController {
    
    private let titleLabel = UILabel()
    
    lazy var header: UILabel = {
        let title = UILabel()
        title.text = "Login"
        title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        title.font = .systemFont(ofSize: 72, weight: .bold)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            title.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0)
        ])

        return title
    }()
    
    lazy var sprite: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "Sprite")
//        img.contentMode = .scaleAspectFit
//        img.clipsToBounds = true
        // Make pretty rounded edges
        img.layer.cornerRadius = 5
        
        img.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(img)
        
        NSLayoutConstraint.activate([
            img.bottomAnchor.constraint(equalTo: header.topAnchor, constant: -10),
            img.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            img.heightAnchor.constraint(equalToConstant: CGFloat(100)),
            img.widthAnchor.constraint(equalToConstant: CGFloat(100))
        ])
        
        return img
    }()
    
    lazy var userField: UILabel = {
        var user = UILabel()
        user.frame = CGRect(x: 0, y: 0, width: 313, height: 66)
        user.backgroundColor = .white

        user.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        user.layer.cornerRadius = 25
        user.layer.borderWidth = 1
        user.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor

        user.text = "   Cornell NetID"
        user.textColor = .gray
    
        view.addSubview(user)
    
        user.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            user.widthAnchor.constraint(equalToConstant: 350), // Fix these magic numbers later
            user.heightAnchor.constraint(equalToConstant: 66),
            user.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            user.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 290),
        ])
        
        return user
    }()
    
    lazy var passwordField: UILabel = {
        var user = UILabel()
        user.frame = CGRect(x: 0, y: 0, width: 313, height: 66)
        user.backgroundColor = .white

        user.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        user.layer.cornerRadius = 25
        user.layer.borderWidth = 1
        user.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor

        user.text = "   Password"
        user.textColor = .gray
    
        view.addSubview(user)
    
        user.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            user.widthAnchor.constraint(equalToConstant: 350), // Fix these magic numbers later
            user.heightAnchor.constraint(equalToConstant: 66),
            user.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            user.topAnchor.constraint(equalTo: userField.bottomAnchor, constant: 25),
        ])
        
        return user
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("    LOG IN    ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            button.widthAnchor.constraint(equalToConstant: 175),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
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
    }
    
    func setupConstraints() {
        
    }
    
    @objc func loginAction() {
        let home = LoginaController()
        self.navigationController?.pushViewController(home, animated: true)
    }
    
}

struct LoginController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Group {
            Text("Hello, World!")
            Text("Hello, World!")
        }/*@END_MENU_TOKEN@*/
    }
}
