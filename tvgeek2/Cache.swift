//
//  Cache.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-22.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation

class Cache {
    
    class func storeShow(show:Show){
        let storage = NSUserDefaults.standardUserDefaults()
        
        let existing = storage.mutableArrayValueForKey("favourites")
        existing.addObject(show.encode())
    }
    
    class func removeStoredShow(show: Show) -> Bool{
        let storage = NSUserDefaults.standardUserDefaults()
        
        let existing = storage.mutableArrayValueForKey("favourites")
        
        for x in existing{
            let dict = x as! NSDictionary
            if let id = dict.objectForKey("id") as? Int{
                if id == show.id{
                    existing.removeObject(x)
                    return true
                }
            }
        }
        
        return false
    }
    
    class func updateShow(show:Show){
        let storage = NSUserDefaults.standardUserDefaults()
        
        let existing = storage.mutableArrayValueForKey("favourites")
        
        for(var i=0;i<existing.count;i++){
            let dict = existing[i] as! NSDictionary
            if let id = dict.objectForKey("id") as? Int{
                if id == show.id{
                    existing[i] = show.encode()
                    return
                }
            }
        }
    }
    
    class func getStoredShows()->[Show]{
        let storage = NSUserDefaults.standardUserDefaults()
        
        let arr = storage.mutableArrayValueForKey("favourites")
        var shows = [Show]()
        
        for item in arr{
            let dict = item as! NSDictionary
            shows.append(Show.decode(dict))
        }
        
        return shows
    }
    
    class func isShowStored(id: Int)->Bool{
        let shows = getStoredShows()
        for show in shows{
            if show.id == id {
                return true
            }
        }
        return false
    }
}