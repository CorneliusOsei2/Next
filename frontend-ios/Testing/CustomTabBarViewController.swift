//
//  CustomTabBarViewController.swift
//  Testing
//
//  Created by Joey Morquecho on 5/3/22.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    let homeTabImage = UIImage(systemName: "person.circle")
    let homeTitle = "Home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let homeView = HomeController()
        let homeViewNavController = UINavigationController(rootViewController: homeView)
        homeViewNavController.tabBarItem = UITabBarItem(title: homeTitle, image:homeTabImage, selectedImage: homeTabImage)
        homeViewNavController.navigationBar.barTintColor = .white
        homeViewNavController.navigationBar.backgroundColor = .none
        
        homeViewNavController.navigationBar.tintColor = .black
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        viewControllers = [homeViewNavController]
    
        
    }
}
