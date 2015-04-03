//
//  Season.swift
//  TVGeek
//
//  Created by Ryan Webber on 2015-04-02.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation

struct Season{
    var showid: String
    var poster: String?
    var season: Int
    var episodes: [Episode] = []
    
    func format()->String{
        if season < 10{
            return "s0\(season)"
        }else{
            return "s\(season)"
        }
    }
}