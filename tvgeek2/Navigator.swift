//
//  Navigator.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-04.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

var sharedNavigator: AppNavigator?

class AppNavigator:UINavigationController{
    
    convenience init(){
        self.init(rootViewController: HomeViewController())
        if sharedNavigator == nil{
            sharedNavigator = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = COLOR_THEME
        self.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationBar.translucent = true
    }
}