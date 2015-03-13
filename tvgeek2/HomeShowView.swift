//
//  ShowView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-04.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit;

class HomeShowView:UIView{
    private var show:Show?
    
    private var container = UIView()
    private var info = UIView()
    private var loader = UIActivityIndicatorView()
    private var cover = URLImageView()
    private var poster = URLImageView()
    private var title = UILabel()
    private var overview = UITextView()
    private var year = UILabel()
    private var seperator = UIView()
    private var rating = RatingView()
    private var networkLabel = UILabel()
    private var network = UILabel()
    private var genres = UILabel()
    private var genresLabel = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("[ShowView] Nib initializer not implemented yet")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loader.startAnimating()
        info.backgroundColor = COLOR_DARK_TRANS
        cover.contentMode = UIViewContentMode.ScaleAspectFill
        
        poster.contentMode = UIViewContentMode.ScaleAspectFill
        poster.layer.borderWidth = 1
        poster.layer.borderColor = COLOR_WHITE.CGColor
        
        var border = CALayer()
        
        title.textColor = COLOR_WHITE
        title.adjustsFontSizeToFitWidth = false;
        title.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        title.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        
        overview.editable = false
        overview.textColor = COLOR_LIGHT
        overview.backgroundColor = COLOR_TRANS
        overview.font = UIFont.systemFontOfSize(FONT_SIZE_MED)
        
        year.textColor = COLOR_LIGHT
        year.font = UIFont.systemFontOfSize(FONT_SIZE_MED)
        
        seperator.backgroundColor = COLOR_THEME
        
        network.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        network.textColor = COLOR_WHITE
        network.textAlignment = NSTextAlignment.Right
        
        networkLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        networkLabel.textColor = COLOR_GRAY_FADE
        networkLabel.text = "Network"
        
        genres.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        genres.textColor = COLOR_WHITE
        genres.textAlignment = NSTextAlignment.Right
        
        genresLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        genresLabel.textColor = COLOR_GRAY_FADE
        genresLabel.text = "Genre"
        
        info.addSubview(poster)
        info.addSubview(overview)
        info.addSubview(title)
        info.addSubview(year)
        info.addSubview(seperator)
        info.addSubview(rating)
        info.addSubview(genresLabel)
        info.addSubview(genres)
        info.addSubview(networkLabel)
        info.addSubview(network)
        
        container.addSubview(cover)
        container.addSubview(info)
        self.addSubview(container)
    }
    
    func setShow(show: Show){
        self.show = show
        
        self.cover.setImageUrl(show.cover)
        self.poster.setImageUrl(show.poster)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.overview.text = show.description
            self.title.text = show.title
            
            if let y = show.year{
                self.year.text = "(\(y))"
            }else{
                self.year.text = "--"
            }
            
            if let r = show.rating{
                self.rating.setRating(CGFloat(r))
            }else{
                self.rating.setRating(0.0)
            }
            
            if show.genres.isEmpty{
                self.genres.text = "None"
            }else{
                var x = show.genres
                while(x.count > 2){
                    x.removeLast()
                }
                self.genres.text = "/".join(x)
            }
            
            if let n = show.network{
                self.network.text = n
            }else{
                self.network.text = "Unknown"
            }
        }
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
            var poster_height = poster_width*3/2
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
            
            genresLabel.frame = CGRect(
                x: poster_offset,
                y: seperator.frame.origin.y + seperator.frame.height + PADDING,
                width: data_width,
                height: genres.font.lineHeight
            )
            
            genres.frame = CGRect(
                x: poster_offset,
                y: seperator.frame.origin.y + seperator.frame.height + PADDING,
                width: data_width,
                height: genres.font.lineHeight
            )
            
            networkLabel.frame = CGRect(
                x: poster_offset,
                y: genres.frame.origin.y + genres.frame.height,
                width: data_width,
                height: network.font.lineHeight
            )
            
            network.frame = CGRect(
                x: poster_offset,
                y: genres.frame.origin.y + genres.frame.height,
                width: data_width,
                height: network.font.lineHeight
            )
            
            var lasty = (network.frame.origin.y + network.font.lineHeight)
            var endy = (poster.frame.origin.y + poster.frame.height)
            var rating_height = min(FONT_SIZE_LARGE, (data_width - PADDING_SMALL*4) / 5)
            
            rating.frame = CGRect(
                x: poster_offset,
                y: lasty + ((endy-lasty) - rating_height)/2,
                width: data_width,
                height: rating_height
            )
            
            overview.frame = CGRect(
                x: edge.origin.x,
                y: edge.origin.y + poster.frame.height + PADDING,
                width: edge.width,
                height: edge.height - (poster.frame.height + PADDING)
            )
            
        }else{
            loader.hidden = false
            container.hidden = true
            loader.center = self.center
        }
    }
}