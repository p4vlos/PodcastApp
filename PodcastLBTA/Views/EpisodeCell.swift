//
//  EpisodeCell.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 19/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
        }
    }
    
    @IBOutlet weak var episodeImageView: UIImageView!
    
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
    
}
