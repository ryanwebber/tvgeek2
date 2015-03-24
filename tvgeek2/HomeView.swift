//
//  HomeView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-02-27.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:UIViewController, UISearchBarDelegate, ViewShowDelegate{
    
    private var homeView = HomeView()
    
    override init(){
        super.init(nibName: nil, bundle: nil)
        
        var searchBar = UISearchBar()
        
        searchBar.barStyle = UIBarStyle.BlackTranslucent
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        self.edgesForExtendedLayout = UIRectEdge.None
        
        homeView.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = homeView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var shows = Cache.getStoredShows()
        self.homeView.setShows(shows)
        
        for show in shows{
            Api().getShowNextEpisodeByShow(show, callback: { (episode: NextEpisode?) -> () in
                dispatch_async(dispatch_get_main_queue()) {
                    if let e = episode{
                        self.homeView.setShowAirDate(e)
                    }else{
                        self.homeView.setShowAirDateUnknown(show)
                    }
                }
            })
        }
    }
    
    override func viewDidLoad() {
        Api().getPopularShows({(popular: [Show]) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.homeView.setPopular(popular)
            }
        })
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
    
    func shouldViewShow(showId: Int) {
        self.navigationController?.pushViewController(ShowViewController(showId: showId), animated: true)
    }
}

class HomeView:BaseView{
    
    private var scroller = UIScrollView()
    private var myshows = WatchView()
    private var popular = PopularView()
    
    var delegate: ViewShowDelegate?{
        get{
            return self.myshows.delegate
        }
        set{
            self.myshows.delegate = newValue
            self.popular.showDelegate = newValue
        }
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()

        self.backgroundColor = COLOR_DARK
        
        scroller.showsVerticalScrollIndicator = false
        scroller.addSubview(myshows)
        scroller.addSubview(popular)
        self.addSubview(scroller)
    }
    
    func setShows(shows: [Show]){
        myshows.setShows(shows)
        self.doneLoading()
    }
    
    func setPopular(popular: [Show]){
        self.popular.setShows(popular)
        self.setNeedsLayout()
    }
    
    func setShowAirDate(episode: NextEpisode){
        myshows.setNextAirDate(episode)
    }
    
    func setShowAirDateUnknown(show: Show){
        myshows.setNextShowDateUnknown(show)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var bounds = self.bounds
        scroller.frame = bounds
        if !super.isLoading(){
            var lims = super.bounds.size
            var width = lims.width - 2*PADDING
            
            var start = CGFloat(0)
            var size = CGSize(width: lims.width, height: lims.width)
            myshows.frame = CGRect(x: 0, y: start, width: size.width, height: size.height)
            
            start+=size.height
            size = popular.sizeThatFits(lims)
            popular.frame = CGRect(x: 0, y: start, width: size.width, height: size.height)

            start+=size.height
            scroller.contentSize = CGSize(width: lims.width, height: start)
        }
    }
}