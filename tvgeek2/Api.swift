//
//  DataSource.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-02-15.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation

class Api{
    
    class var api_keys: NSDictionary{
        var path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist")
        return NSDictionary(contentsOfFile: path!)!
    }
    
    class var trakt_header: Dictionary<String, String>{
        var dict = [
            "Content-Type": "application/json",
            "trakt-api-version": "2",
            "trakt-api-key": Api.api_keys["trakt_key"] as String,
            "Authorization": "Bearer " + (Api.api_keys["trakt_token"] as String)
        ]
        return dict
    }
    
    class var nil_headers: Dictionary<String, String>{
        return Dictionary<String, String>()
    }
    
    var http: Http
    
    init(){
        http = Http()
    }
    
    private func getJSONFromData(data:NSData) -> NSDictionary{
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
    }
    
    private func getJSONArrayFromData(data:NSData) -> NSArray{
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
    }
    
    func getShowsFromSearchString(searchString: String, callback: (shows: [Show]) -> ()){
        var encoded = searchString.lowercaseString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = NSURL(string: "https://api-v2launch.trakt.tv/search?query=\(encoded!)&type=show")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            var json: NSDictionary;
            if result.success{
                var arr = self.getJSONArrayFromData(result.data!)
                var shows = [Show]()
                for json in arr{
                    shows.append(Show(
                        title: "The Walking Dead",
                        rating: 8.543,
                        poster: "https://walter.trakt.us/images/shows/000/002/273/posters/thumb/6a2568c755.jpg",
                        cover: "https://walter.trakt.us/images/shows/000/002/273/fanarts/thumb/7d42efbf73.jpg",
                        description: "Description here",
                        airDay: "Sunday",
                        airTime: "21:00",
                        airTimezone: "",
                        network: "AMC",
                        year: 2015,
                        id: 11,
                        genres: ["action", "adventure"]
                    ))
                }
                callback(shows: shows)
            }else{
                Error.HTTPError(result)
            }
        })
    }
    
    func getShowFromId(id:String, callback: (show: Show) -> ()){
        var url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(id)?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            var json: NSDictionary;
            if result.success{
                var json = self.getJSONFromData(result.data!)
                callback(show: Show(
                    title: json["title"] as String,
                    rating: json["rating"] as? Float,
                    poster: ((json["images"] as NSDictionary)["poster"] as NSDictionary)["thumb"] as? String,
                    cover: ((json["images"] as NSDictionary)["fanart"] as NSDictionary)["thumb"] as? String,
                    description: json["overview"] as? String,
                    airDay: (json["airs"] as NSDictionary)["day"] as? String,
                    airTime: (json["airs"] as NSDictionary)["time"] as? String,
                    airTimezone: (json["airs"] as NSDictionary)["timezone"] as? String,
                    network: json["network"] as? String,
                    year: json["year"] as Int,
                    id: (json["ids"] as NSDictionary)["trakt"] as Int,
                    genres: json["genres"] as [String]
                ))
            }else{
                Error.HTTPError(result)
            }
        })
    }
    
    func getImageDataFromUrl(url: String?, success: (data: NSData) -> (), failure: () -> ()){
        if let imageurlstr = url {
            if let imgurl = NSURL(string: imageurlstr) {
                http.get(imgurl, headers: Api.nil_headers, completionHandler: {(result:HttpResult) -> Void in
                    var json: NSDictionary;
                    if result.success{
                        if let data = result.data{
                            success(data: data)
                        }else{
                            failure()
                        }
                    }else{
                        failure()
                    }
                })
            }else{
                failure()
            }
        }else{
            failure()
        }
    }
}