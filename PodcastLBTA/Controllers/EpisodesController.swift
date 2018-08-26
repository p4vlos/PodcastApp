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
        //let's check if we have already saved this podcast as fav
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        let hasFavourited = savedPodcasts.index(where: { $0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName}) != nil
        
        if hasFavourited {
            //setting up our heart icon
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(handleSaveFavourite)),
            ]
        }
    }
    
    @objc fileprivate func handleFetchPodcasts() {
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favouritePodcastKey) else { return }
        
        let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast]
        savedPodcasts?.forEach({ (p) in
            print(p.trackName ?? "")
        })
    }
    
    @objc fileprivate func handleSaveFavourite() {
        guard let podcast = self.podcast else { return }
        
        // fetch our saved podcasts first
        // 1. Transform Podcast into Data
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favouritePodcastKey)
        
        showBadgeHightlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
    }
    
    fileprivate func showBadgeHightlight() {
        UIApplication.mainTabController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
    
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(style: .normal, title: "Downlaod") { (_, _) in
            print("Downloading episdoe")
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode: episode)
            
            //download the podcast episode using Alamofire
            APIService.shared.downloadEpisode(episode: episode)
        }
        return [downloadAction]
    }
    
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
