//
//  EpisodeView.swift
//  TVGeek
//
//  Created by Ryan Webber on 2015-04-02.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class EpisodeViewController:UIViewController{
    
    private var episodeView = EpisodeView()
    private var episode: Episode
    
    init(episode: Episode){
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
        
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = episodeView
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.translucent = true
        episodeView.setEpisode(episode)
    }
}

class EpisodeView:BaseView{
    
    private var scroll = UIScrollView()
    private var cover = URLImageView()
    private var poster = URLImageView()
    private var title = UILabel()
    private var id = UILabel()
    private var overviewLabel = UILabel()
    private var overview = UITextView()
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
        
        scroll.backgroundColor = COLOR_DARK
        scroll.showsVerticalScrollIndicator = false
        
        cover.backgroundColor = COLOR_DARK
        cover.contentMode = UIViewContentMode.ScaleAspectFill
        cover.layer.borderWidth = PADDING_SMALL
        cover.layer.borderColor = COLOR_WHITE.CGColor
        
        poster.backgroundColor = COLOR_DARK
        poster.contentMode = UIViewContentMode.ScaleAspectFill
        poster.layer.borderWidth = PADDING_SMALL
        poster.layer.borderColor = COLOR_WHITE.CGColor
        
        title.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        title.textColor = COLOR_WHITE
        title.numberOfLines = 0
        
        id.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        id.textColor = COLOR_GRAY_FADE
        
        overviewLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        overviewLabel.textColor = COLOR_GRAY_FADE
        overviewLabel.text = "Overview"
        
        overview.editable = false
        overview.textColor = COLOR_WHITE
        overview.backgroundColor = COLOR_TRANS
        overview.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        overview.userInteractionEnabled = false
        
        scroll.addSubview(cover)
        scroll.addSubview(poster)
        scroll.addSubview(title)
        scroll.addSubview(id)
        scroll.addSubview(overviewLabel)
        scroll.addSubview(overview)
        
        self.addSubview(scroll)
    }
    
    func setEpisode(episode: Episode){
        cover.setImageUrl(episode.cover)
        poster.setImageUrl(episode.season.poster)
        
        title.text = episode.title
        id.text = "\(episode.season.format())\(episode.format())"
        
        if let o = episode.overview{
            overview.text = o
        }else{
            overview.text = "No Overview"
        }
        
        super.doneLoading()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!super.isLoading()){
            let lims = self.bounds.size
            
            scroll.frame = self.bounds
            
            cover.frame = CGRect(x: -PADDING_SMALL, y: -PADDING_SMALL, width: lims.width + 2*PADDING_SMALL, height: COVER_HEIGHT + 2*PADDING_SMALL)
            
            let poster_height = COVER_HEIGHT*2/3
            let poster_width = poster_height*2/3
            
            poster.frame = CGRect(x: PADDING, y: COVER_HEIGHT + PADDING_SMALL*2 - (poster_height*2/3), width: poster_width, height: poster_height)
            
            let endy = (poster.frame.origin.y + poster.frame.height)
            var data_width = lims.width - (poster.frame.origin.x + poster.frame.width + PADDING*2)
            
            var start = endy + PADDING*2
            let width = lims.width - 2*PADDING
            
            var size = title.sizeThatFits(CGSize(width: width, height: lims.height))
            title.frame = CGRect(x: PADDING, y: start, width: width, height: size.height)
            
            id.frame = CGRect(x: PADDING, y: start+size.height, width: width, height: id.font.lineHeight)
            
            start = id.frame.origin.y + id.font.lineHeight + PADDING*2
            size = overviewLabel.sizeThatFits(CGSize(width: width, height: overviewLabel.font.lineHeight))
            overviewLabel.frame = CGRect(x: PADDING, y: start, width: size.width, height: size.height)
            
            start += size.height
            size = overview.sizeThatFits(CGSize(width: width, height: lims.height))
            overview.frame = CGRect(x: PADDING, y: start, width: width, height: size.height)
            
            start += size.height + PADDING
            scroll.contentSize = CGSize(width: lims.width, height: start + PADDING)
        }
    }
}