//
//  SearchView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-08.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController:UIViewController, UITableViewDelegate{
    
    private var searchView = SearchView()
    private var searchStr:String
    private var titleView: UIView?
    
    init(_ searchStr: String){
        self.searchStr = searchStr
        super.init(nibName: nil, bundle: nil)
        
        self.title = "\"\(searchStr)\""
        searchView.delegate = self
        
        let loader = UIActivityIndicatorView(frame: CGRectZero)
        loader.startAnimating()
        titleView = self.navigationItem.titleView
        self.navigationItem.titleView = loader
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = searchView
    }
    
    override func viewDidLoad() {
        Api().getShowsFromSearchString(searchStr, callback: { (shows) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                self.searchView.setSearchResults(shows)
                self.navigationItem.titleView = self.titleView
            }
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let index = indexPath.row
        self.navigationController?.pushViewController(ShowViewController(showId: (self.view as! SearchView).shows[index].id), animated: true)
    }
}

class SearchView:UITableView, UITableViewDataSource{
    var shows: [Show] = []
    private var tableCells: [UITableViewCell] = []
    
    convenience init(){
        self.init(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.backgroundColor = COLOR_DARK
        self.separatorColor = COLOR_GRAY
        self.rowHeight = ROW_HEIGHT
        self.dataSource = self
        self.bounces = false
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
        
        let titleText = show.title
        
        poster.contentMode = UIViewContentMode.ScaleAspectFill
        poster.layer.borderWidth = 1
        poster.layer.borderColor = COLOR_WHITE.CGColor
        poster.setImageUrl(show.poster)
        
        title.textColor = COLOR_WHITE
        title.adjustsFontSizeToFitWidth = false;
        title.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        title.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        title.text = titleText
        
        alt.textColor = COLOR_LIGHT
        alt.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        alt.adjustsFontSizeToFitWidth = false
        alt.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        alt.text = show.description
        alt.numberOfLines = 2
        
        whenSelected.backgroundColor = COLOR_GRAY
        
        self.contentView.addSubview(poster)
        self.contentView.addSubview(title)
        self.contentView.addSubview(alt)
        self.selectedBackgroundView = whenSelected
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let lims = self.contentView.bounds.size
        let left = self.separatorInset.left
        
        let poster_width = (lims.height - PADDING) * 2/3
        let poster_offset = poster_width + PADDING + left
        let data_width = lims.width - poster_offset
        
        poster.frame = CGRect(x: PADDING, y: PADDING/2, width: poster_width, height: lims.height - PADDING)
        
        title.frame = CGRect(
            x: poster_offset,
            y: poster.frame.origin.y + PADDING,
            width: data_width,
            height: title.font.lineHeight
        )
        
        alt.frame = CGRect(
            x: poster_offset,
            y: poster.frame.origin.y + PADDING + title.font.lineHeight + PADDING_SMALL,
            width: data_width,
            height: alt.font.lineHeight*2
        )
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
}

