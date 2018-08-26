//
//  DownloadsController.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 25/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import UIKit

class DownloadsController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    var episodes = UserDefaults.standard.downloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
    }
    
    //MARK:- Setuo
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    //MARk:- UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Launch Episode Player")
        let episode = self.episodes[indexPath.row]
        
        if episode.fileUrl != nil {
             UIApplication.mainTabController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
        } else {
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play using stream url instead", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                UIApplication.mainTabController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alertController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            let episode = self.episodes[indexPath.row]
            self.episodes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            UserDefaults.standard.deleteEpisode(episode: episode)
        }

        return [deleteAction]
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = self.episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
