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
    
    var http: Http
    
    init(){
        http = Http()
    }
    
    private func getJSONFromData(data:NSData) -> NSDictionary{
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
    }
    
    func getShowFromId(id:String, callback: (show: Show) -> ()){
        var url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(id)?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            var json: NSDictionary;
            if result.success{
                var json = self.getJSONFromData(result.data!)
                callback(show: Show(
                    title: json["title"] as String,
                    rating: json["rating"] as? Double,
                    poster: ((json["images"] as NSDictionary)["poster"] as NSDictionary)["thumb"] as? String,
                    cover: ((json["images"] as NSDictionary)["fanart"] as NSDictionary)["thumb"] as? String,
                    description: json["overview"] as? String,
                    airDay: (json["airs"] as NSDictionary)["day"] as? String,
                    airTime: (json["airs"] as NSDictionary)["time"] as? String,
                    airTimezone: (json["airs"] as NSDictionary)["timezone"] as? String,
                    network: json["network"] as? String,
                    year: json["year"] as Int,
                    id: (json["ids"] as NSDictionary)["trakt"] as Int
                ))
            }else{
                //global error handler
            }
        })
    }
}