//
//  ShowView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-10.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class ShowViewController:UIViewController, ViewShowDelegate, ViewSeasonDelegate{
    
    private var showView = ShowView()
    private var showId:Int
    private var favourited = false
    private var toggle: UIBarButtonItem?
    
    init(showId: Int){
        self.showId = showId
        super.init(nibName: nil, bundle: nil)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        showView.showDelegate = self
        showView.seasonDelegate = self
        
        favourited = Cache.isShowStored(showId)
        let title = favourited ? "Unfavourite":"Favourite"
        
        toggle = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("toggleFavourite"))
        self.navigationItem.rightBarButtonItem = toggle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = showView
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.translucent = true
        
        Api().getShowFromId(String(self.showId), callback: {(show: Show) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.showView.setShow(show)
            }
            
            Api().getShowNextEpisodeByShow(show, callback: { (episode: NextEpisode?) -> () in
                dispatch_async(dispatch_get_main_queue()) {
                    if let e = episode{
                        self.showView.setNextEpisode(e)
                    }else{
                        self.showView.setUnknownNextEpisode(show)
                    }
                }
            })
            
        })
        
        Api().getSeasonsForShowById(String(self.showId), callback: {(seasons: [Season]) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.showView.setSeasons(seasons)
            }
        })
        
        Api().getRelatedShowsById(String(self.showId), callback: {(shows: [Show]) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.showView.setRelated(shows.filter({(show: Show) -> Bool in
                    return show.poster != nil;
                }))
            }
        })
        
        
        Api().getCastForShowById(String(self.showId), callback: {(cast: [Person]) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.showView.setCast(cast)
            }
        })
    }
    
    func shouldViewShow(showId: Int) {
        self.navigationController?.pushViewController(ShowViewController(showId: showId), animated: true)
    }
    
    func shouldViewSeason(season: Season) {
        self.navigationController?.pushViewController(EpisodeListViewController(season), animated: true)
    }
    
    func toggleFavourite(){
        
        if let show = showView.show{
            
            if favourited{
                Cache.removeStoredShow(show)
            }else{
                Cache.storeShow(show)
            }
            
            favourited = !favourited
            toggle!.title = favourited ? "Unfavourite":"Favourite"
        }
    }
}

class ShowView:BaseView{
    
    private var show:Show?
    
    private var scroll = UIScrollView()
    private var cover = URLImageView()
    private var poster = URLImageView()
    private var ratings = RatingView()
    private var title = UILabel()
    private var year = UILabel()
    private var genresLabel = UILabel()
    private var genres = UILabel()
    private var networkLabel = UILabel()
    private var network = UILabel()
    private var airsLabel = UILabel()
    private var airs = UILabel()
    private var overviewLabel = UILabel()
    private var overview = UITextView()
    private var nextLabel = UILabel()
    private var next = NextEpisodeView()
    private var seasonsLabel = UILabel()
    private var seasons = SeasonView()
    private var relatedLabel = UILabel()
    private var related = RelatedView()
    private var castLabel = UILabel()
    private var cast = CastView()
    
    var showDelegate: ViewShowDelegate?{
        get{
            return self.related.delegate
        }
        set{
            self.related.delegate = newValue
        }
    }
    
    var seasonDelegate: ViewSeasonDelegate?{
        get{
            return self.seasons.delegate
        }
        set{
            self.seasons.delegate = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        self.show = nil
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
        
        year.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        year.textColor = COLOR_GRAY_FADE
        
        genresLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        genresLabel.textColor = COLOR_GRAY_FADE
        genresLabel.text = "Genres"
        
        genres.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        genres.textColor = COLOR_WHITE
        
        networkLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        networkLabel.textColor = COLOR_GRAY_FADE
        networkLabel.text = "Network"
        
        network.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        network.textColor = COLOR_WHITE
        
        airsLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        airsLabel.textColor = COLOR_GRAY_FADE
        airsLabel.text = "Airs"
        
        airs.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        airs.textColor = COLOR_WHITE

        overviewLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        overviewLabel.textColor = COLOR_GRAY_FADE
        overviewLabel.text = "Overview"
        
        overview.editable = false
        overview.textColor = COLOR_WHITE
        overview.backgroundColor = COLOR_TRANS
        overview.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        overview.userInteractionEnabled = false
        
        nextLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        nextLabel.textColor = COLOR_GRAY_FADE
        nextLabel.text = "Next Episode"
        
        seasonsLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        seasonsLabel.textColor = COLOR_GRAY_FADE
        seasonsLabel.text = "Season(s)"
        
        relatedLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        relatedLabel.textColor = COLOR_GRAY_FADE
        relatedLabel.text = "You Might Also Like"
        
        castLabel.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        castLabel.textColor = COLOR_GRAY_FADE
        castLabel.text = "Cast"
        
        scroll.addSubview(cover)
        scroll.addSubview(poster)
        scroll.addSubview(ratings)
        scroll.addSubview(title)
        scroll.addSubview(year)
        scroll.addSubview(genresLabel)
        scroll.addSubview(genres)
        scroll.addSubview(networkLabel)
        scroll.addSubview(network)
        scroll.addSubview(airsLabel)
        scroll.addSubview(airs)
        scroll.addSubview(overviewLabel)
        scroll.addSubview(overview)
        scroll.addSubview(nextLabel)
        scroll.addSubview(next)
        scroll.addSubview(seasonsLabel)
        scroll.addSubview(seasons)
        scroll.addSubview(relatedLabel)
        scroll.addSubview(related)
        scroll.addSubview(castLabel)
        scroll.addSubview(cast)
        
        self.addSubview(scroll)
    }
    
    func setShow(show: Show){
        self.show = show
        cover.setImageUrl(show.cover)
        poster.setImageUrl(show.poster)
        
        if let r = show.rating{
            self.ratings.setRating(CGFloat(r))
        }else{
            self.ratings.setRating(0.0)
        }
        
        title.text = show.title
        
        if let y = show.year{
            self.year.text = "(\(y))"
        }
        
        if show.genres.isEmpty{
            self.genres.text = "None"
        }else{
            var x = show.genres
            while(x.count > 3){
                x.removeLast()
            }
            self.genres.text = x.joinWithSeparator("/")
        }
        
        if let n = show.network{
            self.network.text = n
        }else{
            self.network.text = "Unknown"
        }
        
        if let at = show.airs {
            self.airs.text = at
        }else{
            self.airs.text = "Unknown"
        }
        
        self.overview.text = show.description
        
        super.doneLoading()
    }
    
    func setNextEpisode(episode: NextEpisode){
        next.setNextEpisode(episode)
    }
    
    func setUnknownNextEpisode(show: Show){
        next.setUnknownNextEpisode(show)
    }
    
    func setSeasons(list: [Season]){
        seasonsLabel.text = "\(list.count) Season(s)"
        seasons.setSeasons(list)
        self.setNeedsLayout()
    }
    
    func setRelated(shows: [Show]){
        related.setRelated(shows)
    }
    
    func setCast(cast: [Person]){
        self.cast.setCast(cast)
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
            let data_width = lims.width - (poster.frame.origin.x + poster.frame.width + PADDING*2)
            let rating_height = min(FONT_SIZE_LARGE, (data_width - PADDING_SMALL*4) / 5)
            
            ratings.frame = CGRect(
                x: poster.frame.origin.x + poster.frame.width + PADDING,
                y: COVER_HEIGHT + ((endy-COVER_HEIGHT) - rating_height)/2,
                width: data_width,
                height: rating_height
            )
            
            var start = endy + PADDING*2
            let width = lims.width - 2*PADDING
            
            var size = title.sizeThatFits(CGSize(width: width, height: lims.height))
            title.frame = CGRect(x: PADDING, y: start, width: width, height: size.height)
            
            year.frame = CGRect(x: PADDING, y: start+size.height, width: width, height: year.font.lineHeight)
            
            start = year.frame.origin.y + year.font.lineHeight + PADDING*2
            size = genresLabel.sizeThatFits(CGSize(width: width, height: genresLabel.font.lineHeight))
            genresLabel.frame = CGRect(x: PADDING, y: start, width: size.width, height: size.height)
            genres.frame = CGRect(x: PADDING*2 + size.width, y: start, width: width - size.width, height: size.height)
            
            start += size.height
            size = networkLabel.sizeThatFits(CGSize(width: width, height: networkLabel.font.lineHeight))
            networkLabel.frame = CGRect(x: PADDING, y: start, width: size.width, height: size.height)
            network.frame = CGRect(x: PADDING*2 + size.width, y: start, width: width - size.width, height: size.height)
            
            start += size.height
            size = airsLabel.sizeThatFits(CGSize(width: width, height: airsLabel.font.lineHeight))
            airsLabel.frame = CGRect(x: PADDING, y: start, width: size.width, height: size.height)
            airs.frame = CGRect(x: PADDING*2 + size.width, y: start, width: width - size.width, height: size.height)
            
            start += size.height + PADDING*2
            size = overviewLabel.sizeThatFits(CGSize(width: width, height: overviewLabel.font.lineHeight))
            overviewLabel.frame = CGRect(x: PADDING, y: start, width: size.width, height: size.height)
            
            start += size.height
            size = overview.sizeThatFits(CGSize(width: width, height: lims.height))
            overview.frame = CGRect(x: PADDING, y: start, width: width, height: size.height)
            
            start += size.height + PADDING*2
            size = nextLabel.sizeThatFits(CGSize(width: width, height: nextLabel.font.lineHeight))
            nextLabel.frame = CGRect(x: PADDING, y: start, width: size.width, height: size.height)
            
            start += size.height + PADDING
            size = CGSize(width: lims.width, height: (lims.width/3) * 3/2)
            next.frame = CGRect(x: 0, y: start, width: lims.width, height: size.height)
            
            start += size.height + PADDING*2
            size = seasonsLabel.sizeThatFits(CGSize(width: width, height: seasonsLabel.font.lineHeight))
            seasonsLabel.frame = CGRect(x: PADDING, y: start, width: size.width, height: size.height)
            
            start += size.height + PADDING
            size = CGSize(width: lims.width, height: (lims.width/3) * 3/2)
            seasons.frame = CGRect(x: 0, y: start, width: lims.width, height: size.height)
            
            start += size.height + PADDING*2
            size = castLabel.sizeThatFits(CGSize(width: width, height: castLabel.font.lineHeight))
            castLabel.frame = CGRect(x: PADDING, y: start, width: size.width, height: size.height)
            
            start += size.height + PADDING
            size = CGSize(width: lims.width, height: (lims.width/3) * 3/2)
            cast.frame = CGRect(x: 0, y: start, width: lims.width, height: size.height)
            
            start += size.height + PADDING*2
            size = relatedLabel.sizeThatFits(CGSize(width: width, height: relatedLabel.font.lineHeight))
            relatedLabel.frame = CGRect(x: PADDING, y: start, width: size.width, height: size.height)
            
            start += size.height + PADDING
            size = CGSize(width: lims.width, height: (lims.width/3) * 3/2)
            related.frame = CGRect(x: 0, y: start, width: lims.width, height: size.height)
            
            start += size.height + PADDING
            scroll.contentSize = CGSize(width: lims.width, height: start + PADDING)
        }
    }
}