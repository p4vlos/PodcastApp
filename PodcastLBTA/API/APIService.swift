//
//  APIService.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 14/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search?term="
    
    //singleton
    static let shared = APIService()
    
    func downloadEpisode(episode: Episode) {
        print("Downloading episode using Alamofire at stream url:", episode.streamUrl)
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            print(progress.fractionCompleted)
            }.response { (resp) in
                print(resp.destinationURL?.absoluteString ?? "")
                
                //I want to update UserDefaults downloaded episodes with the temp file somehow
                
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let index = downloadedEpisodes.index(where: { $0.title == episode.title && $0.author == episode.author }) else {return}
               
                downloadedEpisodes[index].fileUrl = resp.destinationURL?.absoluteString ?? ""
                
                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                     UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
                } catch let err  {
                    print("Failed to encode downloaded episodes with file url update:", err)
                }
               
        }
    }
    
    func fetchEpisodes(feedUrl: String, completionHanlder: @escaping ([Episode]) -> ()) {
        //        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: feedUrl) else { return }
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            
            parser.parseAsync { (result) in
                print("Successful parse feed:", result.isSuccess)
                
                if let err = result.error {
                    print("Failed to parse XML feed:", err)
                    return
                }
                
                guard let feed = result.rssFeed else { return }
                
                let episodes = feed.toEpisodes()
                completionHanlder(episodes)
            }
        }
    }
    
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        print("Searching for my Podcasts")
        
        
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to contact itunes ", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            do {
                print(3)
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                
                completionHandler(searchResult.results)
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
        print(2)
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
}
