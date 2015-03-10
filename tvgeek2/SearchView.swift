//
//  SearchView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-08.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController:UIViewController{
    init(_ searchStr: String){
        super.init(nibName: nil, bundle: nil)
        self.title = "\"\(searchStr)\""
        
        var searchView = SearchView()
        self.view = searchView
        
        Api().getShowsFromSearchString(searchStr, callback: { (shows) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                searchView.setSearchResults(shows)
            }
        })
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchView:UITableView, UITableViewDataSource{
    private var shows: [Show] = []
    private var tableCells: [UITableViewCell] = []
    
    convenience override init(){
        self.init(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.backgroundColor = COLOR_DARK
        self.separatorColor = COLOR_GRAY
        self.rowHeight = ROW_HEIGHT
        self.dataSource = self
    }
    
    func setSearchResults(shows: [Show]){
        self.shows = shows
        for show in shows{
            self.tableCells.append(SearchResultTableCell(show))
        }
        self.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.tableCells[indexPath.item]
    }
}

class SearchResultTableCell: UITableViewCell{
    private var poster = URLImageView()
    private var title = UILabel()
    private var alt = UILabel()
    private var whenSelected = UIView()
    
    init(_ show: Show){
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "show_cell")
        
        self.backgroundColor = COLOR_DARK
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        poster.contentMode = UIViewContentMode.ScaleAspectFill
        poster.layer.borderWidth = 1
        poster.layer.borderColor = COLOR_WHITE.CGColor
        poster.setImageUrl(show.poster)
        
        title.textColor = COLOR_WHITE
        title.adjustsFontSizeToFitWidth = false;
        title.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        title.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        title.text = show.title
        
        alt.textColor = COLOR_LIGHT
        alt.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        alt.adjustsFontSizeToFitWidth = false
        alt.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        alt.text = "/".join(show.genres)
        
        whenSelected.backgroundColor = COLOR_GRAY
        
        self.contentView.addSubview(poster)
        self.contentView.addSubview(title)
        self.contentView.addSubview(alt)
        self.selectedBackgroundView = whenSelected
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var lims = self.contentView.bounds.size
        var left = self.separatorInset.left
        
        var poster_width = (lims.height - PADDING) * 2/3
        var poster_offset = poster_width + PADDING + left
        var data_width = lims.width - poster_offset
        
        poster.frame = CGRect(x: PADDING, y: PADDING/2, width: poster_width, height: lims.height - PADDING)
        
        title.frame = CGRect(
            x: poster_offset,
            y: poster.frame.origin.y,
            width: data_width,
            height: poster.frame.height - alt.font.lineHeight - (PADDING*2)
        )
        
        alt.frame = CGRect(
            x: poster_offset,
            y: poster.frame.height - (PADDING+alt.font.lineHeight),
            width: data_width,
            height: alt.font.lineHeight
        )
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
}

