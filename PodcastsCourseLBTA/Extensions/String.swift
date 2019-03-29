//
//  String.swift
//  PodcastsCourseLBTA
//
//  Created by Brian Voong on 2/27/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
