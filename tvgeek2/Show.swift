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
            if let ad = airDay{
                if let at = self.airTime{
                    var range = at.rangeOfString(":")
                    if let r = range{
                        var t24:Int? =  at.substringToIndex(r.startIndex).toInt()
                        if let t24a = t24{
                            if(t24a == 12){
                                return "\(ad)s at Noon"
                            }else if(t24a == 24){
                                return "\(ad)s at Midnight"
                            }else if(t24a > 12){
                                return "\(ad)s at \(t24a-12):00pm"
                            }else{
                                return "\(ad)s at \(t24a):00am"
                            }
                        }else{
                            return "\(ad)s 3"
                        }
                    }else{
                        return "\(ad)s 2"
                    }
                }else{
                    return "\(ad)s 1"
                }
            }else{
                return nil
            }
        }
    };
    var airTimezone: String?;
    var network: String?;
    var year: Int?;
    var id: Int;
    var genres: [String]
}