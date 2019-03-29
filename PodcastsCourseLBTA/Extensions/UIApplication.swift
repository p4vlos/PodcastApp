//
//  UIApplication.swift
//  PodcastsCourseLBTA
//
//  Created by Brian Voong on 3/9/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        //UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
