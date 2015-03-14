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
            if result.success{
                var arr = self.getJSONArrayFromData(result.data!)
                var shows = [Show]()
                for (var i = 0;i<arr.count;i++) {
                    var json = (arr[i] as NSDictionary)["show"] as NSDictionary
                    shows.append(Show(
                        title: json["title"] as String,
                        rating: nil,
                        poster: ((json["images"] as NSDictionary)["poster"] as NSDictionary)["thumb"] as? String,
                        cover: ((json["images"] as NSDictionary)["fanart"] as NSDictionary)["thumb"] as? String,
                        description: json["overview"] as? String,
                        airDay: nil,
                        airTime: nil,
                        airTimezone: nil,
                        network: nil,
                        year: json["year"] as? Int,
                        id: (json["ids"] as NSDictionary)["trakt"] as Int,
                        genres: []
                    ))
                }
                callback(shows: shows)
            }else{
                Error.HTTPError(result)
            }
        })
    }
    
    func getCastForShowById(id: String, callback: (cast:[Person]) -> ()){
        var url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(id)/people?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            var json:NSDictionary
            if result.success{
                var arr = (self.getJSONFromData(result.data!) as NSDictionary)["cast"] as NSArray
                var cast = [Person]()
                for (var i = 0;i<arr.count;i++) {
                    var json = arr[i] as NSDictionary
                    cast.append(Person(
                        name: (json["person"] as NSDictionary)["name"] as String,
                        character: json["character"] as String,
                        headshot: (((json["person"] as NSDictionary)["images"] as NSDictionary)["headshot"] as NSDictionary)["thumb"] as? String,
                        id: ((json["person"] as NSDictionary)["ids"] as NSDictionary)["trakt"] as Int
                    ))
                }
                callback(cast: cast)
            }else{
                Error.HTTPError(result)
            }
        })
    }
    
    func getSeasonsForShowById(id: String, callback: (thumbnails:[String]) -> ()){
        var url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(id)/seasons?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            if result.success{
                var arr = self.getJSONArrayFromData(result.data!)
                var images = [String]()
                for (var i = 0;i<arr.count;i++) {
                    var num = (arr[i] as NSDictionary)["number"] as Int
                    if num > 0 {
                        var image = (((arr[i] as NSDictionary)["images"] as NSDictionary)["poster"] as NSDictionary)["thumb"] as? String
                        if let i = image{
                            images.append(i)
                        }
                    }
                }
                callback(thumbnails: images)
            }else{
                Error.HTTPError(result)
            }
        })
    }
    
    func getRelatedShowsById(id: String, callback: (shows: [Show]) -> ()){
        var url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(id)/related?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            if result.success{
                var arr = self.getJSONArrayFromData(result.data!)
                var shows = [Show]()
                for (var i = 0;i<arr.count;i++) {
                    var json = arr[i] as NSDictionary
                    shows.append(Show(
                        title: json["title"] as String,
                        rating: nil,
                        poster: ((json["images"] as NSDictionary)["poster"] as NSDictionary)["thumb"] as? String,
                        cover: ((json["images"] as NSDictionary)["fanart"] as NSDictionary)["thumb"] as? String,
                        description: json["overview"] as? String,
                        airDay: nil,
                        airTime: nil,
                        airTimezone: nil,
                        network: nil,
                        year: json["year"] as? Int,
                        id: (json["ids"] as NSDictionary)["trakt"] as Int,
                        genres: []
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
                    year: json["year"] as? Int,
                    id: (json["ids"] as NSDictionary)["trakt"] as Int,
                    genres: (json["genres"] as [String])
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