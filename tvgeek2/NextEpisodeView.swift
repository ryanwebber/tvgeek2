//
//  NextEpisodeView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-26.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class NextEpisodeView:BaseView{
    private var title = UILabel()
    private var date = UILabel()
    private var error = UILabel()
    private var foundEpisode = false
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        self.backgroundColor = COLOR_GRAY
        
        title.textColor = COLOR_WHITE
        title.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        title.textAlignment = NSTextAlignment.Center
        
        date.textColor = COLOR_LIGHT
        date.font = UIFont.systemFontOfSize(FONT_SIZE_MED)
        date.textAlignment = NSTextAlignment.Center
        
        error.textColor = COLOR_LIGHT
        error.textAlignment = NSTextAlignment.Center
        
        self.addSubview(title)
        self.addSubview(date)
        self.addSubview(error)
    }
    
    func setNextEpisode(episode: NextEpisode){
        foundEpisode = true
        
        if let t = episode.title{
            title.text = "\(episode.formatEpisode()): \(t)"
        }else{
            title.text = episode.formatEpisode()
        }
        
        date.text = episode.formatDate()
        
        super.doneLoading()
    }
    
    func setUnknownNextEpisode(show: Show){
        
        if let status = show.status{
            if status == "ended" {
                error.text = "Series Ended"
            }else{
                error.text = "Next Episode Unknown"
            }
        }else{
            error.text = "Next Episode Unknown"
        }
        
        super.doneLoading()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(!super.isLoading()){
            let lims = self.bounds.size
            
            if(foundEpisode){
                error.frame = CGRectZero
                
                let total_height = title.font.lineHeight + date.font.lineHeight
                let a_height = title.font.lineHeight
                let b_height = date.font.lineHeight
                
                title.frame = CGRect(x: PADDING, y: (lims.height-total_height)/2, width: lims.width - PADDING*2, height: a_height)
                date.frame = CGRect(x: PADDING, y: ((lims.height-total_height)/2)+a_height, width: lims.width - PADDING*2, height: b_height)
                
            }else{
                title.frame = CGRectZero
                date.frame = CGRectZero
                error.frame = self.bounds
            }
        }
    }
}