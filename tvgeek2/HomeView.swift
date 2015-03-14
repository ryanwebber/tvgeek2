//
//  HomeView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-02-27.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:UIViewController, UISearchBarDelegate{
    
    private var homeView = HomeView()
    
    override init(){
        super.init(nibName: nil, bundle: nil)
        self.view = homeView
        
        var searchBar = UISearchBar()
        
        searchBar.barStyle = UIBarStyle.BlackTranslucent
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        self.edgesForExtendedLayout = UIRectEdge.None
        
        Api().getShowFromId("archer", callback: {(show: Show) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.homeView.setShows([show, show, show, show])
            }
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.navigationController?.pushViewController(SearchViewController(searchBar.text), animated: true)
        searchBar.text = nil
    }
}

class HomeView:BaseView{
    
    private var favourites:[Show] = [];
    private var scroller = UIScrollView()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        
        scroller.pagingEnabled = true
        self.backgroundColor = COLOR_DARK
        self.addSubview(scroller)
    }
    
    func setShows(shows: [Show]){
        self.favourites = shows
        self.doneLoading()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var bounds = self.bounds
        scroller.frame = bounds
        if favourites.isEmpty {
            scroller.contentSize.height = bounds.size.height
        } else {
            scroller.contentSize.height = bounds.height * CGFloat(favourites.count)
            var counter = 0
            for show in favourites {

                var page = HomeShowView(frame: CGRect(
                    origin: CGPoint(x: 0, y: CGFloat(counter++) * bounds.height),
                    size: bounds.size
                ))
                page.setShow(show)
                scroller.insertSubview(page, atIndex: 0)
            }
        }
    }
}