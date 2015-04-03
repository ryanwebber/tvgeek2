//
//  RelatedView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-13.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class SeasonView:BaseView{
    private var images:[URLImageView] = []
    private var seasons:[Season] = []
    private var error = UILabel()
    private var scroll = UIScrollView()
    var delegate: ViewSeasonDelegate?
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        self.backgroundColor = COLOR_GRAY
        
        scroll.backgroundColor = COLOR_GRAY
        scroll.showsHorizontalScrollIndicator = false
        
        error.textColor = COLOR_LIGHT
        error.text = "Couldn't find show seasons."
        error.textAlignment = NSTextAlignment.Center
    }
    
    func setSeasons(seasons: [Season]){
        
        self.seasons = seasons
        while(!images.isEmpty){
            images[0].removeFromSuperview()
            images.removeAtIndex(0)
        }
        
        var i = 0;
        for season in seasons{
            var view = SeasonPosterView(season: season.season)
            view.setImageUrl(season.poster)
            view.backgroundColor = COLOR_TRANS
            view.contentMode = UIViewContentMode.ScaleAspectFill
            view.layer.borderWidth = 1
            view.layer.borderColor = COLOR_WHITE.CGColor
            var taps = UITapGestureRecognizer(target: self, action: Selector("viewTapped:"))
            view.addGestureRecognizer(taps)
            view.tag = i++
            view.userInteractionEnabled = true
            
            scroll.addSubview(view)
            images.append(view)
        }
        
        if super.isLoading(){
            self.addSubview(scroll)
        }
        
        if(seasons.count == 0){
            self.addSubview(error)
        }
        
        super.doneLoading()
    }
    
    func viewTapped(handler: UIGestureRecognizer){
        var index = handler.view?.tag
        if let del = delegate{
            if let i = index{
                del.shouldViewSeason(seasons[i])
            }
        }
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

class SeasonPosterView:URLImageView{
    var num = UILabel()
    
    init(season: Int) {
        super.init()
        num.text = "\(season)"
        num.textAlignment = NSTextAlignment.Center
        num.textColor = UIColor(white: 1, alpha: 0.35)
        num.backgroundColor = UIColor(white: 0.0, alpha: 0.65)
        num.adjustsFontSizeToFitWidth = true
        self.addSubview(num)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var max_width = self.bounds.width - PADDING_MED*2
        var skip:CGFloat = 10
        
        var x = num.sizeThatFits(CGSize(width: CGFloat.max, height: num.font.lineHeight))
        while(x.width + skip < max_width){
            num.font = UIFont.boldSystemFontOfSize(num.font.pointSize + skip)
            x = num.sizeThatFits(CGSize(width: CGFloat.max, height: num.font.lineHeight))
        }
        
        num.frame = self.bounds
    }
}
