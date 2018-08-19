//
//  EpisodesController.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 18/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
//        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: feedUrl) else { return }
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            print("Successful parse feed:", result.isSuccess)
            
            // Associative enumeration values
            switch result {
            case let .rss(feed):
                
                let imageUrl = feed.iTunes?.iTunesImage?.attributes?.href
                
                var episodes = [Episode]() // blank Episode Array
                feed.items?.forEach({ (feedItem) in
                    var episode = Episode(feedItem: feedItem)
                    
                    if episode.imageUrl == nil {
                        episode.imageUrl = imageUrl
                    }
                    
                    episodes.append(episode)
                })
                self.episodes = episodes
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                break
            case let .failure(error):
                print("Failed to parse feed:", error)
                break
            default:
                print("Found a feed...")
            }
        }
    }
    
    fileprivate let cellId = "cellId"
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK:- Setup work
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        
        cell.episode = episode
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
