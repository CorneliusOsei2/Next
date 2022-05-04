//
//  HomeController.swift
//  Testing
//
//  Created by Derek Sanchez on 5/2/22.
//

import UIKit
import SwiftUI

class HomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setGradientBackground()
//        view.backgroundColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        print("Home Controller!")
        
        let _ = sprite
        let _ = greeting
        
        var view = UILabel()
        view.frame = CGRect(x: 100, y: 100, width: 118.59, height: 120.41)
        view.backgroundColor = .white


        var parent = self.view!
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 118.59).isActive = true
        view.heightAnchor.constraint(equalToConstant: 120.41).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 256.41).isActive = true
        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0).isActive = true



        // Vector 18

        view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 156.51, height: 178.14)
        view.backgroundColor = .white


        parent = self.view!
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 156.51).isActive = true
        view.heightAnchor.constraint(equalToConstant: 178.14).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 216.99).isActive = true
        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0).isActive = true

    }
    
    func setGradientBackground() {
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
    
    lazy var sprite: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "Sprite")
        
        img.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(img)
        
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            img.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            img.heightAnchor.constraint(equalToConstant: CGFloat(60)),
            img.widthAnchor.constraint(equalToConstant: CGFloat(60))
        ])
        
        return img
    }()
    
    lazy var sampleCourse1: UIButton = {
        let button = UIButton()
        button.setTitle("CS1110", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(courseButtonPress), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            button.widthAnchor.constraint(equalToConstant: 175),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        return button
    }()
    
    lazy var greeting: UILabel = {
        var hello = UILabel()
        hello.text = "Hi, [Name]"
        hello.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        hello.font = .systemFont(ofSize: 36, weight: .bold)
        
        hello.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hello)
        
        NSLayoutConstraint.activate([
            hello.leadingAnchor.constraint(equalTo: sprite.leadingAnchor, constant: 0),
            hello.topAnchor.constraint(equalTo: sprite.bottomAnchor, constant: 20),
            hello.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0)
        ])

        return hello
    }()
    
    @objc func courseButtonPress() {
        let coursepage = LoginaController()
        self.navigationController?.pushViewController(coursepage, animated: true)
    }
}



struct HomeController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
