//
//  RelatedView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-13.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class CastView:BaseView, UIScrollViewDelegate{
    private var cast:[Person] = []
    private var images:[URLImageView] = []
    private var characters:[UILabel] = []
    private var actors:[UILabel] = []
    private var pageControl = UIPageControl()
    private var error = UILabel()
    
    private var scroll = UIScrollView()
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        self.backgroundColor = COLOR_GRAY
        
        scroll.backgroundColor = COLOR_GRAY
        scroll.showsHorizontalScrollIndicator = false
        scroll.pagingEnabled = true
        scroll.delegate = self
        
        error.textColor = COLOR_LIGHT
        error.text = "Couldn't find cast members."
        error.textAlignment = NSTextAlignment.Center
        
        pageControl.currentPageIndicatorTintColor = COLOR_THEME
    }
    
    func setCast(cast: [Person]){
        self.cast = cast
        
        pageControl.numberOfPages = cast.count
        
        while(!images.isEmpty){
            images[0].removeFromSuperview()
            images.removeAtIndex(0)
        }
        
        for person in cast{
            let view = URLImageView()
            view.setImageUrl(person.headshot)
            view.backgroundColor = COLOR_TRANS
            view.contentMode = UIViewContentMode.ScaleAspectFill
            view.layer.borderWidth = 1
            view.layer.borderColor = COLOR_WHITE.CGColor
            scroll.addSubview(view)
            images.append(view)
            
            let clabel = UILabel()
            clabel.textColor = COLOR_WHITE
            clabel.text = person.character
            clabel.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
            clabel.textAlignment = NSTextAlignment.Center
            characters.append(clabel)
            scroll.addSubview(clabel)
            
            let alabel = UILabel()
            alabel.textColor = COLOR_LIGHT
            alabel.text = person.name
            alabel.font = UIFont.systemFontOfSize(FONT_SIZE_MED)
            alabel.textAlignment = NSTextAlignment.Center
            actors.append(alabel)
            scroll.addSubview(alabel)
        }
        
        if super.isLoading(){
            self.addSubview(scroll)
            self.addSubview(pageControl)
        }
        
        if(cast.count == 0){
            self.addSubview(error)
        }
        
        super.doneLoading()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        let page:CGFloat = (scroll.contentOffset.x * CGFloat(cast.count) / scroll.contentSize.width)
        pageControl.currentPage = Int(round(page))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(!super.isLoading()){
            let lims = self.bounds.size
            scroll.frame = self.bounds
            
            let size = pageControl.sizeThatFits(lims)
            let pager_height = size.height*2/3
            pageControl.frame = CGRect(x: 0, y: lims.height - pager_height, width: lims.width, height: pager_height)
            
            let poster_width = (lims.height-((PADDING) + pager_height))*2/3
            let poster_height = poster_width*3/2
            
            for (var i=0;i<images.count;i++){
                var offset = lims.width * CGFloat(i)
                
                let view = images[i]
                view.frame = CGRect(x: offset+PADDING, y: PADDING, width: poster_width, height: poster_height)
                
                offset += PADDING*2 + poster_width
                let width = lims.width - (PADDING*3 + poster_width)
                
                let clabel = characters[i]
                clabel.frame = CGRect(x: offset, y: ((lims.height-pager_height)/2) - clabel.font.lineHeight, width: width, height: clabel.font.lineHeight)
                
                let alabel = actors[i]
                alabel.frame = CGRect(x: offset, y: ((lims.height-pager_height)/2), width: width, height: clabel.font.lineHeight)
            }
            
            error.frame = CGRect(x: PADDING, y: (lims.height - error.font.lineHeight)/2, width: lims.width - PADDING*2, height: error.font.lineHeight)
            
            scroll.contentSize = CGSize(width: CGFloat(images.count) * lims.width, height: lims.height)
        }
    }
}