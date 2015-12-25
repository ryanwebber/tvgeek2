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
    private var loader = UIActivityIndicatorView()
    private var gradient = CAGradientLayer()
    
    required init?(coder aDecoder: NSCoder){
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
        
        loader.startAnimating()
        loader.alpha = 0.25
        
        let color0 = UIColor(red:0, green:0, blue:0, alpha:0.0).CGColor
        let color1 = UIColor(red:0, green:0, blue:0, alpha:0.0).CGColor
        let color2 = UIColor(red:0, green:0, blue:0, alpha:0.75).CGColor
        let color3 = UIColor(red:0, green:0, blue:0, alpha:1).CGColor
        
        gradient.colors = [color0,color1,color2]
        gradient.locations = [0, 0.6, 0.9, 1]
        overlay.layer.insertSublayer(gradient, atIndex: 0)
        
        overlay.addSubview(year)
        overlay.addSubview(loader)
        overlay.addSubview(title)
        
        self.addSubview(cover)
        self.addSubview(overlay)
        
    }
    
    func setAirDate(when: String){
        year.text = when
        loader.removeFromSuperview()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
        let lims = self.bounds.size
        
        cover.frame = self.bounds
        
        let offset = lims.height - ((PADDING*2) + title.font.lineHeight + year.font.lineHeight)
        overlay.frame = self.bounds
        
        title.frame = CGRect(x: PADDING, y: offset + PADDING, width: lims.width - PADDING*2, height: title.font.lineHeight)
        year.frame = CGRect(x: PADDING, y: offset + PADDING + title.font.lineHeight, width: lims.width - PADDING*2, height: title.font.lineHeight)
        loader.frame = CGRect(x: PADDING, y: offset + PADDING + title.font.lineHeight, width: title.font.lineHeight, height: title.font.lineHeight)
    }
}