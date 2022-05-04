//
//  CustomTabBarViewController.swift
//  Testing
//
//  Created by Joey Morquecho on 5/3/22.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    let bookImage = UIImage(systemName: "book.fill")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let homeView = HomeController()
        let homeViewNavController = UINavigationController(rootViewController: homeView)
        homeViewNavController.tabBarItem = UITabBarItem(title: "Home", image:bookImage, selectedImage: bookImage)
        homeViewNavController.navigationBar.barTintColor = .white
        homeViewNavController.navigationBar.backgroundColor = .none
        
        // TODO: change tint color
        homeViewNavController.navigationBar.tintColor = .black
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        viewControllers = [homeViewNavController]
    
        
    }
}
