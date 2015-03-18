//
//  SimpleShowView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-17.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

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
            self.year.text = "(----)"
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