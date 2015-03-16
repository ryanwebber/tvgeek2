//
//  RelatedView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-13.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class MyShowsView:BaseView, UIScrollViewDelegate{
    private var shows:[Show] = []
    private var showViews: [SimpleShowView] = []
    
    private var scroll = UIScrollView()
    private var pageControl = UIPageControl()
    var delegate: ViewShowDelegate?;
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        super.hideLoading()
        
        self.backgroundColor = COLOR_GRAY
        
        scroll.backgroundColor = COLOR_GRAY
        scroll.showsHorizontalScrollIndicator = false
        scroll.pagingEnabled = true
        scroll.delegate = self
        
        var taps = UITapGestureRecognizer(target: self, action: Selector("viewTapped:"))
        scroll.addGestureRecognizer(taps)
        
        pageControl.currentPageIndicatorTintColor = COLOR_THEME
    }
    
    func viewTapped(handler: UIGestureRecognizer){
        var p = handler.locationInView(scroll)
        var index:Int = Int(p.x / self.frame.width)
        
        if let del = self.delegate{
            del.shouldViewShow(self.shows[index].id)
        }
    }
    
    func setShows(shows: [Show]){
        self.shows = shows
        
        while(!showViews.isEmpty){
            showViews[0].removeFromSuperview()
            showViews.removeAtIndex(0)
        }
        
        for show in shows{
            var view = SimpleShowView(show: show)
            showViews.append(view)
            scroll.addSubview(view)
        }
        
        pageControl.numberOfPages = shows.count
        
        if super.isLoading(){
            self.addSubview(scroll)
            self.addSubview(pageControl)
        }
        
        super.doneLoading()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        var page:CGFloat = (scroll.contentOffset.x * CGFloat(shows.count) / scroll.contentSize.width)
        pageControl.currentPage = Int(round(page))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(!super.isLoading()){
            var lims = self.bounds.size
            scroll.frame = self.bounds
            scroll.contentSize = CGSize(width: CGFloat(shows.count) * lims.width, height: lims.height)
            
            for(var i=0;i<showViews.count;i++){
                var view = showViews[i]
                view.frame = CGRect(x: CGFloat(i)*lims.width, y:0, width: lims.width, height: lims.height)
            }
            
            var size = pageControl.sizeThatFits(lims)
            pageControl.frame = CGRect(x: 0, y: 0, width: lims.width, height: size.height*2/3)
        }
    }
}

class SimpleShowView: UIView{
    private var show: Show
    
    private var cover = URLImageView()
    private var title = UILabel()
    private var year = UILabel()
    private var overlay = UIView()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(show:Show){
        self.show = show
        super.init(frame: CGRectZero)
        
        cover.contentMode = UIViewContentMode.ScaleAspectFill
        cover.backgroundColor = COLOR_GRAY
        cover.setImageUrl(show.cover)
        
        title.textColor = COLOR_WHITE
        title.adjustsFontSizeToFitWidth = false;
        title.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        title.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        title.text = show.title
        
        year.textColor = COLOR_LIGHT
        year.font = UIFont.systemFontOfSize(FONT_SIZE_MED)
        if let y = show.year{
            self.year.text = "(\(y))"
        }else{
            self.year.text = "--"
        }
        
        overlay.backgroundColor = COLOR_DARK_TRANS
        overlay.addSubview(year)
        overlay.addSubview(title)
        
        self.addSubview(cover)
        self.addSubview(overlay)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var lims = self.bounds.size
        
        cover.frame = self.bounds
        
        var height = (PADDING*2) + title.font.lineHeight + year.font.lineHeight
        overlay.frame = CGRect(x:0, y: lims.height - height, width: lims.width, height: height)
        
        title.frame = CGRect(x: PADDING, y: PADDING, width: lims.width - PADDING*2, height: title.font.lineHeight)
        year.frame = CGRect(x: PADDING, y: PADDING + title.font.lineHeight, width: lims.width - PADDING*2, height: title.font.lineHeight)
    }
}

