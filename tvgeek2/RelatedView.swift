//
//  RelatedView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-13.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class RelatedView:BaseView{
    private var related:[Show] = []
    private var images:[URLImageView] = []
    
    private var scroll = UIScrollView()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        self.backgroundColor = COLOR_GRAY
        
        scroll.backgroundColor = COLOR_GRAY
        scroll.showsHorizontalScrollIndicator = false
        
        self.addSubview(scroll)
    }
    
    func setRelated(shows: [Show]){
        self.related = shows
        
        while(!images.isEmpty){
            images[0].removeFromSuperview()
            images.removeAtIndex(0)
        }
        
        for show in shows{
            var view = URLImageView()
            view.setImageUrl(show.poster)
            view.backgroundColor = COLOR_TRANS
            view.contentMode = UIViewContentMode.ScaleAspectFill
            view.layer.borderWidth = 1
            view.layer.borderColor = COLOR_WHITE.CGColor
            
            scroll.addSubview(view)
            images.append(view)
        }
        super.doneLoading()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(!super.isLoading()){
            var lims = self.bounds.size
            scroll.frame = self.bounds
            
            var poster_width = (lims.height-PADDING*2)*2/3
            var poster_height = poster_width*3/2
            
            for (var i=0;i<images.count;i++){
                var view = images[i]
                view.frame = CGRect(x: (PADDING+poster_width)*CGFloat(i) + PADDING, y: PADDING, width: poster_width, height: poster_height)
            }
            
            scroll.contentSize = CGSize(width: (PADDING+poster_width) * CGFloat(images.count) + PADDING, height: lims.height)
        }
    }
}