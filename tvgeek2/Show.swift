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
    var airTimezone: String?;
    var network: String?;
    var year: Int;
    var id: Int;
    var genres: [String]? = [];
}