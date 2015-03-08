//
//  SearchView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-08.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController:BaseViewController{
    init(_ searchStr: String){
        super.init(nibName: nil, bundle: nil)
        self.title = "\"\(searchStr)\""
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}