//
//  HomeView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-02-27.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:BaseViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        var searchBar = UISearchBar()
        var searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)

        searchBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationItem.titleView = searchBar
        
        Api().getShowFromId("1390", callback: {(show: Show) -> Void in
            self.view = HomeView(shows: [show, show, show, show])
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeView:UIView{
    
    private var favourites:[Show];
    private var scroller = UIScrollView()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(shows: [Show]){
        self.favourites = shows
        super.init(frame: CGRectZero)
        
        scroller.pagingEnabled = true
        self.backgroundColor = COLOR_DARK
        self.addSubview(scroller)
    }

    override func layoutSubviews() {
        var bounds = self.bounds
        scroller.frame = bounds
        if favourites.isEmpty {
            scroller.contentSize.height = bounds.size.height
        } else {
            scroller.contentSize.height = bounds.height * CGFloat(favourites.count)
            var counter = 0
            for show in favourites {

                var page = ShowView(frame: CGRect(
                    origin: CGPoint(x: 0, y: CGFloat(counter++) * bounds.height),
                    size: bounds.size
                ))
                page.setShow(show)
                scroller.insertSubview(page, atIndex: 0)
            }
        }
    }
}