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
        var storage = NSUserDefaults.standardUserDefaults()
        
        var existing = storage.mutableArrayValueForKey("favourites")
        existing.addObject(show.encode())
    }
    
    class func removeStoredShow(show: Show) -> Bool{
        var storage = NSUserDefaults.standardUserDefaults()
        
        var existing = storage.mutableArrayValueForKey("favourites")
        
        for x in existing{
            var dict = x as NSDictionary
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
        var storage = NSUserDefaults.standardUserDefaults()
        
        var existing = storage.mutableArrayValueForKey("favourites")
        
        for(var i=0;i<existing.count;i++){
            var dict = existing[i] as NSDictionary
            if let id = dict.objectForKey("id") as? Int{
                if id == show.id{
                    existing[i] = show.encode()
                    return
                }
            }
        }
    }
    
    class func getStoredShows()->[Show]{
        var storage = NSUserDefaults.standardUserDefaults()
        
        var arr = storage.mutableArrayValueForKey("favourites")
        var shows = [Show]()
        
        for item in arr{
            var dict = item as NSDictionary
            shows.append(Show.decode(dict))
        }
        
        return shows
    }
    
    class func isShowStored(id: Int)->Bool{
        var shows = getStoredShows()
        for show in shows{
            if show.id == id {
                return true
            }
        }
        return false
    }
}