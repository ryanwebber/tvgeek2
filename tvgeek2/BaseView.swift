//
//  LoadingView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-06.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController:UIViewController{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view = BaseView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseView: UIView{
    var loader = UIActivityIndicatorView()
    
    override init(){
        super.init(frame: CGRectZero)
        
        loader.startAnimating()
        self.addSubview(loader)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Not implementing views with nibs")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loader.center = self.center
    }
}

