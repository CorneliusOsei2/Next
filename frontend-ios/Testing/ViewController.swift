//
//  ViewController.swift
//  Testing
//
//  Created by Derek Sanchez on 4/30/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("Setup?")
        let _ = loginButton
        let _ = developerMode
        let _ = randomText
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black
        ]

        
    }
    
    lazy var randomText: UILabel = {
        let title = UILabel()
        title.text = "Welcome to Our App I Guess \n This is just a sandbox space for trying out things."
        title.textColor = .black
        title.font = .systemFont(ofSize: 20, weight: .bold)
        // Use my own constraints
        title.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            title.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0)
        ])
        
        return title
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Login  ", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0)
        ])
        return button
    }()
    
    lazy var developerMode: UIButton = {
        let button = UIButton()
        button.setTitle("  Developer Mode  ", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(developerOption), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0)
        ])
        return button
    }()
    
    
    @objc func loginAction() {
        print("Trace loginButton()")
        let newLoginController = LoginController()
        self.navigationController?.pushViewController(newLoginController, animated: true)
//        self.present(newLoginController, animated: true, completion: nil)
        print("PUSH?")
    }
    
    @objc func developerOption() {
        let newHomeController = HomeController()
        self.navigationController?.pushViewController(newHomeController, animated: true)
    }
}

