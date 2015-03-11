//
//  ShowView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-10.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class ShowViewController:UIViewController{
    
    var showView = ShowView()
    
    override init(){
        super.init(nibName: nil, bundle: nil)
        self.view = showView
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShowId(id: Int){
        Api().getShowFromId(String(id), callback: {(show: Show) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.showView.setShow(show)
                self.title = show.title
            }
        })
    }
}

class ShowView:BaseView{
    
    private var show:Show?;
    
    private var scroll = UIScrollView()
    private var cover = URLImageView()
    private var poster = URLImageView()
    private var ratings = RatingView()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        self.show = nil
        super.init()
        
        scroll.backgroundColor = COLOR_DARK
        scroll.bounces = false
        
        cover.backgroundColor = COLOR_DARK
        cover.contentMode = UIViewContentMode.ScaleAspectFill
        cover.layer.borderWidth = PADDING_MED
        cover.layer.borderColor = COLOR_WHITE.CGColor
        
        poster.backgroundColor = COLOR_DARK
        poster.contentMode = UIViewContentMode.ScaleAspectFill
        poster.layer.borderWidth = PADDING_MED
        poster.layer.borderColor = COLOR_WHITE.CGColor
                
        scroll.addSubview(cover)
        scroll.addSubview(poster)
        scroll.addSubview(ratings)
        
        self.addSubview(scroll)
    }
    
    func setShow(show: Show){
        self.show = show
        cover.setImageUrl(show.cover)
        poster.setImageUrl(show.poster)
        
        if let r = show.rating{
            self.ratings.setRating(CGFloat(r))
        }else{
            self.ratings.setRating(0.0)
        }
        
        super.doneLoading()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!super.isLoading()){
            var lims = self.bounds.size
            
            scroll.frame = CGRect(origin: CGPointZero, size: lims)
            scroll.contentSize = lims
            
            cover.frame = CGRect(x: -PADDING_MED, y: PADDING_MED, width: lims.width + 2*PADDING_MED, height: COVER_HEIGHT + 2*PADDING_MED)
            
            var poster_height = COVER_HEIGHT*2/3
            var poster_width = poster_height*2/3
            
            poster.frame = CGRect(x: PADDING, y: COVER_HEIGHT + PADDING_MED*2 - (poster_height/2), width: poster_width, height: poster_height)
            
            var endy = (poster.frame.origin.y + poster.frame.height)
            var data_width = lims.width - (poster.frame.origin.x + poster.frame.width + PADDING*2)
            var rating_height = min(FONT_SIZE_LARGE, (data_width - PADDING_SMALL*4) / 5)
            
            ratings.frame = CGRect(
                x: poster.frame.origin.x + poster.frame.width + PADDING,
                y: COVER_HEIGHT + ((endy-COVER_HEIGHT) - rating_height)/2,
                width: data_width,
                height: rating_height
            )
        }
    }
}