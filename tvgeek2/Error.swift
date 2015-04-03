//
//  Error.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-07.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class Error{
    class func HTTPError(details: HttpResult?){
        
        sharedNavigator?.pushViewController(NoConnectionViewController(), animated: false)
        
        var view = UIAlertView(
            title: "Connection Error",
            message: "TVGeek could not connect to the server. Please try again later",
            delegate: nil,
            cancelButtonTitle: "Okay"
        )
        
        view.show()
    }
}