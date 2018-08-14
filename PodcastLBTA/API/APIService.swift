//
//  APIService.swift
//  PodcastLBTA
//
//  Created by Pavlos Nicolaou on 14/08/2018.
//  Copyright © 2018 Pavlos Nicolaou. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search?term="
    
    //singleton
    static let shared = APIService()
    
    
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
