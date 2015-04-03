//
//  Episode.swift
//  TVGeek
//
//  Created by Ryan Webber on 2015-04-02.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation

struct Episode{
    var season: Season
    var episode: Int
    var title: String?
    var cover: String?
    var overview: String?
    
    func format()->String{
        if episode < 10{
            return "e0\(episode)"
        }else{
            return "e\(episode)"
        }
    }
}