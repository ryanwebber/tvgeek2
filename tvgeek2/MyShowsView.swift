//
//  RelatedView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-13.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class MyShowsView:BaseView{
    private var shows:[Show] = []
    private var showViews: [SimpleShowView] = []
    
    private var scroll = UIScrollView()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        self.backgroundColor = COLOR_GRAY
        
        scroll.backgroundColor = COLOR_GRAY
        scroll.showsHorizontalScrollIndicator = false
        scroll.pagingEnabled = true
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
        
        if super.isLoading(){
            self.addSubview(scroll)
        }
        
        super.doneLoading()
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
        }
    }
}

class SimpleShowView: UIView{
    private var show: Show
    
    private var cover = URLImageView()
    private var poster = URLImageView()
    private var title = UILabel()
    private var year = UILabel()
    private var seperator = UIView()
    private var overlay = UIView()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(show:Show){
        self.show = show
        super.init(frame: CGRectZero)
        
        cover.contentMode = UIViewContentMode.ScaleAspectFill
        cover.backgroundColor = COLOR_LIGHT
        cover.setImageUrl(show.cover)
        
        poster.contentMode = UIViewContentMode.ScaleAspectFill
        poster.layer.borderWidth = 1
        poster.layer.borderColor = COLOR_WHITE.CGColor
        poster.setImageUrl(show.poster)
        
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
        
        seperator.backgroundColor = COLOR_THEME
        
        overlay.backgroundColor = COLOR_DARK_TRANS
        overlay.addSubview(poster)
        overlay.addSubview(year)
        overlay.addSubview(title)
        overlay.addSubview(seperator)
        
        self.addSubview(cover)
        self.addSubview(overlay)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var lims = self.bounds.size
        
        cover.frame = self.bounds
        overlay.frame = self.bounds
        
        var edge = CGRect(x: PADDING,
            y: PADDING,
            width: lims.width - PADDING*2,
            height: lims.height - PADDING*2
        )
        
        
        var poster_height = edge.height
        var poster_width = poster_height*2/3
        var poster_offset = PADDING*2 + poster_width
        var data_width = lims.width - (poster_offset+PADDING)
        poster.frame = CGRect(
            origin: edge.origin,
            size: CGSize(width: poster_width, height: poster_height)
        )
        
        title.frame.size = CGSize(width: data_width, height: title.font.lineHeight)
        title.frame.origin = CGPoint(x: poster_offset, y: edge.origin.y)
        
        year.frame = CGRect(
            x: poster_offset,
            y: title.frame.origin.y + title.frame.height,
            width: data_width / 2,
            height: year.font.lineHeight
        )
        
        seperator.frame = CGRect(
            x: poster_offset,
            y: year.frame.origin.y + year.font.lineHeight + 2,
            width: data_width,
            height: 1
        )
    }
}

