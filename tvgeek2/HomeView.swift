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
        
        Api().getPopularShows({(popular: [Show]) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.homeView.setShows(popular)
                self.homeView.setPopular(popular)
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
    
    private var scroller = UIScrollView()
    
    private var myshows = MyShowsView()
    private var myshowsLabel = UILabel()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()

        self.backgroundColor = COLOR_DARK
        
        myshows.layer.borderWidth = PADDING_SMALL
        myshows.layer.borderColor = COLOR_GRAY.CGColor
        
        myshowsLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        myshowsLabel.textColor = COLOR_GRAY_FADE
        myshowsLabel.text = "My Shows"
        
        scroller.addSubview(myshows)
        scroller.addSubview(myshowsLabel)
        self.addSubview(scroller)
    }
    
    func setShows(shows: [Show]){
        myshows.setShows(shows)
        self.doneLoading()
    }
    
    func setPopular(popular: [Show]){
        return
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var bounds = self.bounds
        scroller.frame = bounds
        if !super.isLoading(){
            var lims = super.bounds.size
            
            var start = PADDING*2
            var width = lims.width - 2*PADDING
            
            var size = myshowsLabel.sizeThatFits(CGSize(width: width, height: lims.height))
            myshowsLabel.frame = CGRect(x: PADDING, y: start, width: width, height: size.height)
            
            start+=size.height + PADDING
            size = CGSize(width: lims.width, height: lims.width)
            myshows.frame = CGRect(x: -PADDING_SMALL, y: start, width: size.width + PADDING_SMALL*2, height: size.height)
            
            start+=size.height
            scroller.contentSize = CGSize(width: lims.width, height: start + PADDING*2)
        }
    }
}