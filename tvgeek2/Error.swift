//
//  Error.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-07.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation

class Error{
    class func HTTPError(details: AnyObject){
        fatalError("[HTTPError] Error with http")
    }
}