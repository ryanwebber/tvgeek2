//
//  Show.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-02-15.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation

struct Show{
    var title: String;
    var rating: Float?;
    var poster: String?;
    var cover: String?;
    var description: String?;
    var airDay: String?;
    var airTime: String?;
    var airs: String? {
        get{
            if let at = formatTime(){
                if let ad = airDay{
                    return "\(ad)s at \(at)"
                }else{
                    return formatTime()
                }
            }else{
                if let ad = airDay{
                    return "\(ad)s"
                }else{
                    return nil
                }
            }
        }
    };
    
    var airTimezone: String?;
    var network: String?;
    var year: Int?;
    var id: Int;
    var tvrageid: Int?
    var genres: [String]
    var status: String?
    
    func encode() -> NSDictionary{
        let dict = NSMutableDictionary()
        
        dict.setValue(title, forKey: "title")
        dict.setValue(rating, forKey: "rating")
        dict.setValue(poster, forKey: "poster")
        dict.setValue(cover, forKey: "cover")
        dict.setValue(description, forKey: "description")
        dict.setValue(airDay, forKey: "airday")
        dict.setValue(airTime, forKey: "airtime")
        dict.setValue(airTimezone, forKey: "airtimezone")
        dict.setValue(network, forKey: "network")
        dict.setValue(year, forKey: "year")
        dict.setValue(id, forKey: "id")
        dict.setValue(tvrageid, forKey: "tvrageid")
        dict.setValue(genres, forKey: "genres")
        dict.setValue(status, forKey: "status")
        
        return dict
    }
    
    static func decode(dict: NSDictionary) -> Show{
        let title = dict.objectForKey("title") as! String
        let rating = dict.objectForKey("year") as? Float
        let poster = dict.objectForKey("poster") as? String
        let cover = dict.objectForKey("cover") as? String
        let description = dict.objectForKey("description") as? String
        let airDay = dict.objectForKey("airday") as? String
        let airTime = dict.objectForKey("airtime") as? String
        let airTimezone = dict.objectForKey("airtimezone") as? String
        let network = dict.objectForKey("network") as? String
        let year = dict.objectForKey("year") as? Int
        let id = dict.objectForKey("id") as! Int
        let tvrageid = dict.objectForKey("tvrageid") as? Int
        let status = dict.objectForKey("status") as? String
        
        var genres: [String]
        if let g = dict.objectForKey("genres") as? [String]{
            genres = g
        }else{
            genres = []
        }
        
        return Show(
            title: title,
            rating: rating,
            poster: poster,
            cover: cover,
            description: description,
            airDay: airDay,
            airTime: airTime,
            airTimezone: airTimezone,
            network: network,
            year: year,
            id: id,
            tvrageid: tvrageid,
            genres: genres,
            status: status
        )
    }
    
    func formatTime()->String?{
        if let at = self.airTime{
            let range = at.rangeOfString(":")
            if let r = range{
                let t24:Int? =  Int(at.substringToIndex(r.startIndex))
                if let t24a = t24{
                    if(t24a == 12){
                        return "Noon"
                    }else if(t24a == 24 || t24a == 0){
                        return "Midnight"
                    }else if(t24a > 12){
                        return "\(t24a-12):00pm"
                    }else{
                        return "\(t24a):00am"
                    }
                }else{
                    return nil
                }
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
}

