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
        
        
        // This spawns in the UIObjects that are to be displayed on the home page.
        let _ = icon
        let _ = greeting
        
        
        var stroke = UIView()
        stroke.bounds = view.bounds.insetBy(dx: -0.5, dy: -0.5)
        stroke.center = view.center
        view.addSubview(stroke)
        
        
        //
        // Code below generates the list of courses based on networking data. courseNames is dummy data.
        //
        
        // Default course color scheme. Can change if you want to.
        let colorScheme: [CGColor] = [#colorLiteral(red: 0.8722902536, green: 0.6250724792, blue: 0.9576098323, alpha: 1), #colorLiteral(red: 0.9619587064, green: 0.6241410375, blue: 0.6233865023, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)]
        
        var courses:[UIButton] = []
        let courseNames: [String] = ["CS1110", "CS2110", "CS3110", "CS2800", "CS3410"] // [NETWORKING], fill in with course names.
        let numberOfCourses = courseNames.count // [NETWORKING], put in the number of courses.
        
        assert(courseNames.count == numberOfCourses)
        
        for i in 0...numberOfCourses - 1 {
            if (i == 0) {
                courses.append(createAButton(constraint1: greeting.bottomAnchor, constraint2: 30, text: courseNames[i], color: colorScheme[Int.random(in: 0..<colorScheme.count)]))
            }
            else {
                courses.append(createAButton(constraint1: courses[i-1].bottomAnchor, constraint2: 30, text: courseNames[i], color: colorScheme[Int.random(in: 0..<colorScheme.count)]))
            }
        }
        
        // I can't get the little drawings in the top right here.
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
    
    lazy var icon: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "Sprite")
        
        img.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(img)
        
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            img.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            img.heightAnchor.constraint(equalToConstant: CGFloat(60)),
            img.widthAnchor.constraint(equalToConstant: CGFloat(60))
        ])
        
        return img
    }()
    
    func createAButton(constraint1: NSLayoutYAxisAnchor, constraint2: Int, text: String, color: CGColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = color
        button.layer.borderWidth = 1
        button.layer.borderColor = color
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(courseButtonPress), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: constraint1, constant: CGFloat(constraint2)),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            button.widthAnchor.constraint(equalToConstant: 350),
            button.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        return button
    }
    
    lazy var sampleCourse1: UIButton = {
        let button = UIButton()
        button.setTitle("CS1110", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(courseButtonPress), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: greeting.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            button.widthAnchor.constraint(equalToConstant: 350),
            button.heightAnchor.constraint(equalToConstant: 75)
        ])
        return button
    }()
    
    lazy var greeting: UILabel = {
        var hello = UILabel()
        hello.text = "Hi, [Name]"
        hello.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        hello.font = UIFont(name: "Futura", size: 30.0)
//        hello.font = .systemFont(ofSize: 36, weight: .bold)
        
        hello.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hello)
        
        NSLayoutConstraint.activate([
            hello.leadingAnchor.constraint(equalTo: icon.leadingAnchor, constant: 0),
            hello.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
            hello.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0)
        ])

        return hello
    }()
    
    @objc func courseButtonPress() {
        let coursepage = CourseController()
        self.navigationController?.pushViewController(coursepage, animated: true)
    }
}



struct HomeController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
