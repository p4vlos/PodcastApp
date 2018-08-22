//
//  UIApplication.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 22/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
