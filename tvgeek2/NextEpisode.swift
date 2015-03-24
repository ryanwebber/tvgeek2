//
//  NextEpisode.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-23.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation

struct NextEpisode {
    var season: String
    var episode: String
    var title: String?
    var date: NSDate
    var show: Show
    
    func formatEpisode()->String{
        return "s\(season)e\(episode)"
    }
    
    func formatDate()->String{
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d"
        var pre = formatter.stringFromDate(date)
        
        if(date.timeIntervalSinceNow < 60*60*24*7){
            formatter.dateFormat = "EEEE"
            pre = formatter.stringFromDate(date)
        }
        
        if let at = show.formatTime(){
            return "\(pre) at \(at)"
        }else{
            return pre
        }
    }
}