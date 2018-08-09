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
        
        view.backgroundColor = .green
        
        let favouritesController = ViewController()
        favouritesController.tabBarItem.title = "Favourites"
        
        let searchNavController = UINavigationController(rootViewController: ViewController())
        searchNavController.tabBarItem.title = "Search"
        
        viewControllers = [
            favouritesController
            searchNavController
        ]
    }
}
