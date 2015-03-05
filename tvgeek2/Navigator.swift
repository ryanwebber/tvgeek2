//
//  Navigator.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-04.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class AppNavigator:UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = UIBarStyle.BlackTranslucent
    }
}