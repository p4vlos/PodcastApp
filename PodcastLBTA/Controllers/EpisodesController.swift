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
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate let cellId = "cellId"
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarButton()
    }
    
    //MARK:- Setup work
    
    fileprivate func setupNavigationBarButton() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(handleSaveFavourite)),
        UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchPodcasts))]
    }
    
    @objc fileprivate func handleFetchPodcasts() {
//        let value = UserDefaults.standard.value(forKey: favouritePodcastKey) as? String
        
        guard let data = UserDefaults.standard.data(forKey: favouritePodcastKey) else { return }
        let podcast = NSKeyedUnarchiver.unarchiveObject(with: data) as? Podcast
        
        print(podcast?.artistName ?? "", podcast?.trackName ?? "")
    }
    
    let favouritePodcastKey = "favouritePodcastKey"
    
    @objc fileprivate func handleSaveFavourite() {
        guard let podcast = self.podcast else { return }
        
//        UserDefaults.standard.set(podcast.trackName, forKey: favouritePodcastKey)
        
        // 1. Transform Podcast into Data
        let data = NSKeyedArchiver.archivedData(withRootObject: podcast)
        UserDefaults.standard.set(data, forKey: favouritePodcastKey)
    }
    
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episode = self.episodes[indexPath.row]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)

    }
    
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
