//
//  RelatedView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-13.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class WatchView:BaseView, UIScrollViewDelegate{
    private var shows:[Show] = []
    private var showViews: [SimpleShowView] = []
    private var noshows = NoWatchShows()
    
    private var scroll = UIScrollView()
    private var pageControl = UIPageControl()
    var delegate: ViewShowDelegate?;
    
    required init?(coder aDecoder: NSCoder){
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
        
        noshows.hidden = true
        
        self.addSubview(noshows)
        
        let taps = UITapGestureRecognizer(target: self, action: Selector("viewTapped:"))
        scroll.addGestureRecognizer(taps)
        
        pageControl.currentPageIndicatorTintColor = COLOR_THEME
    }
    
    func viewTapped(handler: UIGestureRecognizer){
        let p = handler.locationInView(scroll)
        let index:Int = Int(p.x / self.frame.width)
        
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
            let view = SimpleShowView(show: show)
            showViews.append(view)
            scroll.addSubview(view)
        }
        
        pageControl.numberOfPages = shows.count
        
        if shows.count > 0{
            noshows.hidden = true
            noshows.setNeedsDisplay()
        }
        
        if super.isLoading(){
            self.insertSubview(scroll, belowSubview: noshows)
            self.insertSubview(pageControl, belowSubview: noshows)
        }
        
        super.doneLoading()
    }
    
    func setNextAirDate(episode: NextEpisode){
        for(var i=0;i<shows.count;i++){
            if shows[i].id == episode.show.id{
                showViews[i].setAirDate("\(episode.formatEpisode()): \(episode.formatDate())")
            }
        }
    }
    
    func setNextShowDateUnknown(show:Show){
        for(var i=0;i<shows.count;i++){
            if shows[i].id == show.id{
                if let status = show.status{
                    if status == "ended" {
                        showViews[i].setAirDate("Series Ended")
                    }else{
                        showViews[i].setAirDate("Next Episode Unknown")
                    }
                }else{
                    showViews[i].setAirDate("Next Episode Unknown")
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        let page:CGFloat = (scroll.contentOffset.x * CGFloat(shows.count) / scroll.contentSize.width)
        pageControl.currentPage = Int(round(page))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let lims = self.bounds.size
        
        if(super.isLoading()){
        }else if(shows.count == 0){
            noshows.hidden = false
            noshows.setNeedsDisplay()
            noshows.frame = self.bounds
        }else{
            scroll.frame = self.bounds
            scroll.contentSize = CGSize(width: CGFloat(shows.count) * lims.width, height: lims.height)
            
            for(var i=0;i<showViews.count;i++){
                let view = showViews[i]
                view.frame = CGRect(x: CGFloat(i)*lims.width, y:0, width: lims.width, height: lims.height)
            }
            
            let size = pageControl.sizeThatFits(lims)
            pageControl.frame = CGRect(x: 0, y: 0, width: lims.width, height: size.height*2/3)
        }
    }
}

class NoWatchShows: UIView{
    private var title = UILabel()
    private var desc = UILabel()
    private var image = UIImageView(image: UIImage(named: "placeholder_favourite"))
    private var overlay = UIView()
    
    init() {
        super.init(frame: CGRectZero)
        
        title.textColor = COLOR_WHITE
        title.textAlignment = NSTextAlignment.Center
        title.adjustsFontSizeToFitWidth = false;
        title.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        title.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        title.numberOfLines = 1
        title.text = "D'oh!"
        
        desc.textColor = COLOR_LIGHT
        desc.textAlignment = NSTextAlignment.Center
        desc.font = UIFont.systemFontOfSize(FONT_SIZE_MED)
        desc.numberOfLines = 0
        desc.text = "You have no favourite shows! Search for your favourites or look through popular shows below"
        
        image.contentMode = UIViewContentMode.ScaleAspectFill
        
        overlay.backgroundColor = COLOR_DARKER_TRANS
        
        overlay.addSubview(title)
        overlay.addSubview(desc)
        
        self.addSubview(image)
        self.addSubview(overlay)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let lims = self.bounds.size
        let width = lims.width - PADDING*2
        
        image.frame = self.bounds
        overlay.frame = self.bounds
        
        var height = title.font.lineHeight
        let size = desc.sizeThatFits(CGSize(width: width, height: lims.height))
        height += size.height
        
        let title_offset = (lims.height/2) - (height/2)
        let desc_offset = title_offset + title.font.lineHeight
        
        title.frame = CGRect(x: PADDING, y: title_offset, width: width, height: title.font.lineHeight)
        desc.frame = CGRect(x: PADDING, y: desc_offset, width: size.width, height: size.height)
    }
}

