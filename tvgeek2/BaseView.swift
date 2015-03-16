//
//  LoadingView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-06.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class BaseView: UIView{
    private var loader = UIActivityIndicatorView()
    private var loading = true
    
    override init(){
        super.init(frame: CGRectZero)
        self.backgroundColor = COLOR_DARK
        
        loader.startAnimating()
        self.addSubview(loader)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Not implementing views with nibs")
    }
    
    func doneLoading(){
        loader.hidden = true
        loader.removeFromSuperview()
        loading = false
        self.setNeedsLayout()
    }
    
    func isLoading() -> Bool{
        return loading
    }
    
    func hideLoading(){
        loader.removeFromSuperview()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var lims = self.bounds
        
        loader.frame = self.bounds
    }
}

