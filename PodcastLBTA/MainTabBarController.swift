//
//  MainTabBarController.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 09/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = .purple

        setupViewControllers()
    }
    
    
    //MARK:- Setup Functions
    
    func setupViewControllers() {
        viewControllers = [
            generationNavigationController(for: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generationNavigationController(for: ViewController(), title: "Favourites", image: #imageLiteral(resourceName: "favorites")),
            generationNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    //MARK:- Helper Functions
    
    fileprivate func generationNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)

        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
}
