//
//  ShowView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-04.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit;

class ShowView:UIView{
    private var show:Show?
    
    private var container = UIView()
    private var info = UIView()
    private var loader = UIActivityIndicatorView()
    private var cover = UIImageView()
    private var poster = UIImageView()
    private var title = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("[ShowView] Nib initializer not implemented yet")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loader.startAnimating()
        info.backgroundColor = COLOR_DARK_TRANS
        cover.contentMode = UIViewContentMode.ScaleAspectFill
        poster.contentMode = UIViewContentMode.ScaleAspectFill
        title.textColor = COLOR_WHITE
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = false;
        title.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        title.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        
        info.addSubview(poster)
        info.addSubview(title)
        container.addSubview(cover)
        container.addSubview(info)
        self.addSubview(container)
    }
    
    func setShow(show: Show){
        self.show = show
        
        cover.image = UIImage(named: "cover")
        poster.image = UIImage(named: "poster")
        title.text = show.title
        
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var lims = self.bounds.size
        if let sinfo = show{
            container.hidden = false
            container.frame = self.bounds
            cover.frame = self.bounds
            info.frame = self.bounds
            
            loader.hidden = true
            
            var edge = CGRect(x: PADDING,
                y: PADDING,
                width: lims.width - PADDING*2,
                height: lims.height - PADDING*2
            )
            
            
            var poster_width = max(50, edge.width/3)
            var poster_offset = PADDING*2 + poster_width
            var data_width = lims.width - (poster_offset+PADDING)
            poster.frame = CGRect(
                origin: edge.origin,
                size: CGSize(width: poster_width, height: poster_width*3/2)
            )

            title.frame = CGRect(x: poster_offset, y: edge.origin.y, width: data_width, height: 0)
            title.sizeToFit()
            
        }else{
            loader.hidden = false
            container.hidden = true
            loader.center = self.center
        }
    }
}