//
//  ShowView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-04.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit;

class ShowView:UIView{
    var show:Show?
    
    func setShow(show: Show){
        self.show = show
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        bounds = self.bounds
        if let sinfo = show{
            var edge = CGRect(x: PADDING, y: PADDING, width: bounds.size.width - PADDING*2, height: bounds.size.height - PADDING*2)
            var test = UIView(frame: edge)
            test.backgroundColor = COLOR_THEME
            self.addSubview(test)
        }else{
            var loader = UIActivityIndicatorView()
            loader.startAnimating()
            loader.center = self.center
            self.addSubview(loader)
        }
    }
}