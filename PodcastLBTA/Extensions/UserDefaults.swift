//
//  UserDefaults.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 25/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favouritePodcastKey = "favouritePodcastKey"
    
    func savedPodcasts() -> [Podcast] {
        guard let savedPodacstsData = UserDefaults.standard.data(forKey: UserDefaults.favouritePodcastKey) else { return [] }
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodacstsData) as? [Podcast] else { return [] }
        
        return savedPodcasts
    }
    
    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favouritePodcastKey)
    }
}
