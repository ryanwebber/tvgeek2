//
//  ViewManager.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-02-16.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class ViewManager{
    var storyboard: UIStoryboard;
    
    init(_ withStoryboard: String){
        self.storyboard = UIStoryboard(name:withStoryboard,bundle: nil)
    }
    
    func pushPage(page:String, arg: AnyObject){
        var view = self.storyboard.instantiateViewControllerWithIdentifier(page) as AppView
        view.setArg(arg);
    }
    
    func pushPage(page:String){
        var view = self.storyboard.instantiateViewControllerWithIdentifier(page) as AppView
    }
    
    func popPage(){
        
    }
}

class AppView: UIViewController{
    func setArg(arg: AnyObject){
        // no implementation
    }
}