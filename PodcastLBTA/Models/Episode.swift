//
//  Episode.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 19/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
    let title: String
    let pubDate : Date
    let description: String
    let author: String
    
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
}
