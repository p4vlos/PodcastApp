//
//  RSSFeed.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 19/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import FeedKit

extension RSSFeed {
    func toEpisodes() -> [Episode] {
        
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var episodes = [Episode]() // blank Episode Array
        items?.forEach({ (feedItem) in
            var episode = Episode(feedItem: feedItem)
            
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            
            episodes.append(episode)
        })
        
        return episodes
    }
}
