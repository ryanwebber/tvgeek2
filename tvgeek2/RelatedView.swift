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
    private var error = UILabel()
    var delegate: ViewShowDelegate?
    
    private var scroll = UIScrollView()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        self.backgroundColor = COLOR_GRAY
        
        scroll.backgroundColor = COLOR_GRAY
        scroll.showsHorizontalScrollIndicator = false
        
        error.textColor = COLOR_LIGHT
        error.text = "Couldn't find related shows."
        error.textAlignment = NSTextAlignment.Center
    }
    
    func viewTapped(handler: UIGestureRecognizer){
        var index = handler.view?.tag
        if let del = delegate{
            if let i = index{
                del.shouldViewShow(i)
            }
        }
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
            view.userInteractionEnabled = true
            var taps = UITapGestureRecognizer(target: self, action: Selector("viewTapped:"))
            view.addGestureRecognizer(taps)
            view.tag = show.id
            
            scroll.addSubview(view)
            images.append(view)
        }
        
        if super.isLoading(){
            self.addSubview(scroll)
        }
        
        if(shows.count == 0){
            self.addSubview(error)
        }
        
        super.doneLoading()
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var initial_height = size.width / 2
        return CGSize()
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
            
            error.frame = CGRect(x: PADDING, y: (lims.height - error.font.lineHeight)/2, width: lims.width - PADDING*2, height: error.font.lineHeight)
            
            scroll.contentSize = CGSize(width: (PADDING+poster_width) * CGFloat(images.count) + PADDING, height: lims.height)
        }
    }
}