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
        let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist")
        return NSDictionary(contentsOfFile: path!)!
    }
    
    class var trakt_header: Dictionary<String, String>{
        let dict = [
            "Content-Type": "application/json",
            "trakt-api-version": "2",
            "trakt-api-key": Api.api_keys["trakt_key"] as! String,
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
        return (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
    }
    
    private func getJSONArrayFromData(data:NSData) -> NSArray{
        return (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)) as! NSArray
    }
    
    func getShowsFromSearchString(searchString: String, callback: (shows: [Show]) -> ()){
        let encoded = searchString.lowercaseString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL(string: "https://api-v2launch.trakt.tv/search?query=\(encoded!)&type=show")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            if result.success{
                let arr = self.getJSONArrayFromData(result.data!)
                var shows = [Show]()
                for (var i = 0;i<arr.count;i++) {
                    let json = (arr[i] as! NSDictionary)["show"] as! NSDictionary
                    shows.append(Show(
                        title: json["title"] as! String,
                        rating: nil,
                        poster: ((json["images"] as! NSDictionary)["poster"] as! NSDictionary)["thumb"] as? String,
                        cover: ((json["images"] as! NSDictionary)["fanart"] as! NSDictionary)["thumb"] as? String,
                        description: json["overview"] as? String,
                        airDay: nil,
                        airTime: nil,
                        airTimezone: nil,
                        network: nil,
                        year: json["year"] as? Int,
                        id: (json["ids"] as! NSDictionary)["trakt"] as! Int,
                        tvrageid: (json["ids"] as! NSDictionary)["tvrage"] as? Int,
                        genres: [],
                        status: nil
                    ))
                }
                callback(shows: shows)
            }else{
                Error.HTTPError(result)
            }
        })
    }
    
    func getPopularShows(callback: (popular: [Show]) -> ()){
        
        let url = NSURL(string: "https://api-v2launch.trakt.tv/shows/trending?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            if result.success{
                let arr = self.getJSONArrayFromData(result.data!)
                var shows = [Show]()
                for (var i = 0;i<arr.count;i++) {
                    let json = (arr[i] as! NSDictionary)["show"] as! NSDictionary
                    shows.append(Show(
                        title: json["title"] as! String,
                        rating: json["rating"] as? Float,
                        poster: ((json["images"] as! NSDictionary)["poster"] as! NSDictionary)["thumb"] as? String,
                        cover: ((json["images"] as! NSDictionary)["fanart"] as! NSDictionary)["thumb"] as? String,
                        description: json["overview"] as? String,
                        airDay: nil,
                        airTime: nil,
                        airTimezone: nil,
                        network: nil,
                        year: json["year"] as? Int,
                        id: (json["ids"] as! NSDictionary)["trakt"] as! Int,
                        tvrageid: (json["ids"] as! NSDictionary)["tvrage"] as? Int,
                        genres: [],
                        status: nil
                    ))
                }
                callback(popular: shows)
            }else{
                Error.HTTPError(result)
            }
        })
    }
    
    func getCastForShowById(id: String, callback: (cast:[Person]) -> ()){
        let url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(id)/people?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            var json:NSDictionary
            if result.success{
                let arr = (self.getJSONFromData(result.data!) as NSDictionary)["cast"] as! NSArray
                var cast = [Person]()
                for (var i = 0;i<arr.count;i++) {
                    let json = arr[i] as! NSDictionary
                    cast.append(Person(
                        name: (json["person"] as! NSDictionary)["name"] as! String,
                        character: json["character"] as! String,
                        headshot: (((json["person"] as! NSDictionary)["images"] as! NSDictionary)["headshot"] as! NSDictionary)["thumb"] as? String,
                        id: ((json["person"] as! NSDictionary)["ids"] as! NSDictionary)["trakt"] as! Int
                    ))
                }
                callback(cast: cast)
            }else{
                callback(cast: [])
            }
        })
    }
    
    func getProductionsForPersonById(id: String, callback: (productions:[CastMember]) -> ()){
        let url = NSURL(string: "https://api-v2launch.trakt.tv/people/\(id)/shows?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            var json:NSDictionary
            if result.success{
                let arr = (self.getJSONFromData(result.data!) as NSDictionary)["cast"] as! NSArray
                var productions = [CastMember]()
                for (var i = 0;i<arr.count;i++) {
                    var json = arr[i] as! NSDictionary
                    let character = json["character"] as! String
                    json = json["show"] as! NSDictionary
                    let show = Show(
                        title: json["title"] as! String,
                        rating: json["rating"] as? Float,
                        poster: ((json["images"] as! NSDictionary)["poster"] as! NSDictionary)["thumb"] as? String,
                        cover: ((json["images"] as! NSDictionary)["fanart"] as! NSDictionary)["thumb"] as? String,
                        description: json["overview"] as? String,
                        airDay: nil,
                        airTime: nil,
                        airTimezone: nil,
                        network: nil,
                        year: json["year"] as? Int,
                        id: (json["ids"] as! NSDictionary)["trakt"] as! Int,
                        tvrageid: (json["ids"] as! NSDictionary)["tvrage"] as? Int,
                        genres: [],
                        status: nil
                    )
                    productions.append(CastMember(
                        production: show,
                        character: character
                    ))
                }
                callback(productions: productions)
            }else{
                Error.HTTPError(result)
            }
        })
    }
    
    func getSeasonsForShowById(id: String, callback: (seasons:[Season]) -> ()){
        let url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(id)/seasons?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            if result.success{
                let arr = self.getJSONArrayFromData(result.data!)
                var seasons = [Season]()
                for (var i = 0;i<arr.count;i++) {
                    let num = (arr[i] as! NSDictionary)["number"] as! Int
                    if num > 0 {
                        let image = (((arr[i] as! NSDictionary)["images"] as! NSDictionary)["poster"] as! NSDictionary)["thumb"] as? String
                        seasons.append(Season(
                            showid: id,
                            poster: image,
                            season: num,
                            episodes: []
                        ))
                    }
                }
                callback(seasons: seasons)
            }else{
                callback(seasons: [])
            }
        })
    }
    
    func getSeasonWithEpisodesForShowSeasonBySeason(season: Season, callback: (season:Season) -> ()){
        let url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(season.showid)/seasons/\(season.season)/?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            if result.success{
                let arr = self.getJSONArrayFromData(result.data!)
                var s = season
                var episodes = [Episode]()
                for (var i = 0;i<arr.count;i++) {
                    let num = (arr[i] as! NSDictionary)["number"] as! Int
                    let title = (arr[i] as! NSDictionary)["title"] as? String
                    let image = (((arr[i] as! NSDictionary)["images"] as! NSDictionary)["screenshot"] as! NSDictionary)["thumb"] as? String
                    let overview = (arr[i] as! NSDictionary)["overview"] as? String
                    episodes.append(Episode(
                        season: s,
                        episode: num,
                        title: title,
                        cover: image,
                        overview: overview
                    ))
                }
                s.episodes = episodes
                callback(season: s)
            }else{
                Error.HTTPError(result)
            }
        })
    }
    
    func getRelatedShowsById(id: String, callback: (shows: [Show]) -> ()){
        let url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(id)/related?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            if result.success{
                let arr = self.getJSONArrayFromData(result.data!)
                var shows = [Show]()
                for (var i = 0;i<arr.count;i++) {
                    let json = arr[i] as! NSDictionary
                    shows.append(Show(
                        title: json["title"] as! String,
                        rating: nil,
                        poster: ((json["images"] as! NSDictionary)["poster"] as! NSDictionary)["thumb"] as? String,
                        cover: ((json["images"] as! NSDictionary)["fanart"] as! NSDictionary)["thumb"] as? String,
                        description: json["overview"] as? String,
                        airDay: nil,
                        airTime: nil,
                        airTimezone: nil,
                        network: nil,
                        year: json["year"] as? Int,
                        id: (json["ids"] as! NSDictionary)["trakt"] as! Int,
                        tvrageid: (json["ids"] as! NSDictionary)["tvrage"] as? Int,
                        genres: [],
                        status: nil
                    ))
                }
                callback(shows: shows)
            }else{
                callback(shows: [])
            }
        })
    }
    
    func getShowFromId(id:String, callback: (show: Show) -> ()){
        let url = NSURL(string: "https://api-v2launch.trakt.tv/shows/\(id)?extended=images,full")
        http.get(url!, headers: Api.trakt_header, completionHandler: {(result:HttpResult) -> Void in
            if result.success{
                let json = self.getJSONFromData(result.data!)
                callback(show: Show(
                    title: json["title"] as! String,
                    rating: json["rating"] as? Float,
                    poster: ((json["images"] as! NSDictionary)["poster"] as! NSDictionary)["thumb"] as? String,
                    cover: ((json["images"] as! NSDictionary)["fanart"] as! NSDictionary)["thumb"] as? String,
                    description: json["overview"] as? String,
                    airDay: (json["airs"] as! NSDictionary)["day"] as? String,
                    airTime: (json["airs"] as! NSDictionary)["time"] as? String,
                    airTimezone: (json["airs"] as! NSDictionary)["timezone"] as? String,
                    network: json["network"] as? String,
                    year: json["year"] as? Int,
                    id: (json["ids"] as! NSDictionary)["trakt"] as! Int,
                    tvrageid: (json["ids"] as! NSDictionary)["tvrage"] as? Int,
                    genres: (json["genres"] as! [String]),
                    status: json["status"] as? String
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
    
    func getShowNextEpisodeByShow(show:Show, callback: (episode: NextEpisode?) -> ()){
        if let id = show.tvrageid{
            let url = NSURL(string: "http://api.tvmaze.com/lookup/shows?tvrage=\(show.tvrageid!)")
            http.get(url!, headers: Api.nil_headers, completionHandler: {(result:HttpResult) -> Void in
                if result.success{
                    let json = self.getJSONFromData(result.data!);
                    if let _link = json["_links"]?["nextepisode"]??["href"] as? String{
                        
                        let url2 = NSURL(string: _link)
                        self.http.get(url2!, headers: Api.nil_headers, completionHandler: {(result:HttpResult) -> Void in
                            if result.success{
                                let json = self.getJSONFromData(result.data!);
                                if let _time = json["airstamp"] as? String{
                                    
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                                    
                                    callback(episode: NextEpisode(
                                        season: String(json["season"]!),
                                        episode: String(json["number"]!),
                                        title: json["name"] as! String,
                                        date: dateFormatter.dateFromString(_time)!,
                                        show: show
                                    ))
                                }else{
                                    callback(episode: nil)
                                }
                            }else{
                                callback(episode: nil)
                            }
                        })
                    }else{
                        callback(episode: nil)
                    }
                }else{
                    callback(episode: nil)
                }
            })
        }else{
            callback(episode: nil)
        }
    }
}