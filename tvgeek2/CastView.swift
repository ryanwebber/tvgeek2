//
//  RelatedView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-13.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class CastView:BaseView{
    private var cast:[Person] = []
    private var images:[URLImageView] = []
    private var characters:[UILabel] = []
    private var actors:[UILabel] = []
    
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
    
    func setCast(cast: [Person]){
        self.cast = cast
        
        while(!images.isEmpty){
            images[0].removeFromSuperview()
            images.removeAtIndex(0)
        }
        
        for person in cast{
            var view = URLImageView()
            view.setImageUrl(person.headshot)
            view.backgroundColor = COLOR_TRANS
            view.contentMode = UIViewContentMode.ScaleAspectFill
            view.layer.borderWidth = 1
            view.layer.borderColor = COLOR_WHITE.CGColor
            scroll.addSubview(view)
            images.append(view)
            
            var clabel = UILabel()
            clabel.textColor = COLOR_WHITE
            clabel.text = person.character
            clabel.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
            clabel.textAlignment = NSTextAlignment.Center
            characters.append(clabel)
            scroll.addSubview(clabel)
            
            var alabel = UILabel()
            alabel.textColor = COLOR_LIGHT
            alabel.text = person.name
            alabel.font = UIFont.systemFontOfSize(FONT_SIZE_MED)
            alabel.textAlignment = NSTextAlignment.Center
            actors.append(alabel)
            scroll.addSubview(alabel)
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
            
            var poster_width = (lims.height-PADDING*2)*2/3
            var poster_height = poster_width*3/2
            
            for (var i=0;i<images.count;i++){
                var offset = lims.width * CGFloat(i)
                
                var view = images[i]
                view.frame = CGRect(x: offset+PADDING, y: PADDING, width: poster_width, height: poster_height)
                
                offset += PADDING*2 + poster_width
                var width = lims.width - (PADDING*3 + poster_width)
                
                var clabel = characters[i]
                clabel.frame = CGRect(x: offset, y: (lims.height/2) - clabel.font.lineHeight, width: width, height: clabel.font.lineHeight)
                
                var alabel = actors[i]
                alabel.frame = CGRect(x: offset, y: (lims.height/2), width: width, height: clabel.font.lineHeight)
            }
            
            scroll.contentSize = CGSize(width: CGFloat(images.count) * lims.width, height: lims.height)
        }
    }
}