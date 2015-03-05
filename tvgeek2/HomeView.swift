//
//  HomeView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-02-27.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:UIViewController{
    
    override func viewDidLoad() {
        var searchBar = UISearchBar()
        var searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)

        searchBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationItem.titleView = searchBar
        
        Api().getShowFromId("1390", callback: {(show: Show) -> Void in
            (self.view as HomeView).setFavourites([show, show, show])
        })
    }
}

class HomeView:UIView{
    
    var favourites:[Show]?;
    var loader:UIActivityIndicatorView
    
    required init(coder aDecoder: NSCoder){
        loader = UIActivityIndicatorView()
        super.init(coder: aDecoder)
        
        loader.startAnimating()
        self.addSubview(loader)
    }
    
    override init(frame: CGRect) {
        loader = UIActivityIndicatorView()
        super.init(frame: frame)
        
        loader.startAnimating()
        self.addSubview(loader)
    }
    
    func setFavourites(shows: [Show]){
        self.favourites = shows
        loader.removeFromSuperview()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        var bounds = self.bounds
        if let favs = self.favourites {
            if favs.isEmpty {
                
            } else {
                
                var scroller = SnapScroll(frame: self.frame)
                scroller.frame.origin.y=0
                scroller.contentSize.width = self.frame.size.width
                scroller.contentSize.height = self.frame.size.height * CGFloat(favs.count)
                scroller.delegate = scroller
                
                var counter = 0
                for show in favs {

                    var page = ShowView(frame: CGRect(
                        origin: CGPoint(x: 0, y: CGFloat(counter++) * bounds.height),
                        size: bounds.size
                    ))
                    page.show = show
                    scroller.addSubview(page)
                }

                self.addSubview(scroller)
            }
        }else{
            loader.center = self.center
        }
    }
}