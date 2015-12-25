//
//  EpisodeListView.swift
//  TVGeek
//
//  Created by Ryan Webber on 2015-04-02.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class EpisodeListViewController:UIViewController, UITableViewDelegate{
    
    private var listView = EpisodeListView()
    private var season: Season
    private var titleView: UIView?
    
    init(_ season: Season){
        self.season = season
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Season \(season.season)"
        listView.delegate = self
        
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
        self.view = listView
    }
    
    override func viewDidLoad() {
        
        Api().getSeasonWithEpisodesForShowSeasonBySeason(season, callback: { (season) -> () in
            self.season = season
            dispatch_async(dispatch_get_main_queue()) {
                self.listView.setEpisodes(season.episodes)
                self.navigationItem.titleView = self.titleView
            }
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.navigationController?.pushViewController(EpisodeViewController(episode: season.episodes[indexPath.row]), animated: true)
    }
}

class EpisodeListView:UITableView, UITableViewDataSource{
    var episodes: [Episode] = []
    var whenSelected = UIView()
    
    convenience init(){
        self.init(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.backgroundColor = COLOR_DARK
        self.separatorColor = COLOR_GRAY
        self.rowHeight = ROW_HEIGHT / 2
        self.dataSource = self
        self.bounces = false
        
        whenSelected.backgroundColor = COLOR_GRAY
    }
    
    func setEpisodes(episodes: [Episode]){
        self.episodes = episodes
        self.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var dequeued = self.dequeueReusableCellWithIdentifier("episode") 
        if dequeued == nil{
            dequeued = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "episode")
        }
        let cell = dequeued!
        let episode = episodes[indexPath.row]
        
        cell.backgroundColor = COLOR_DARK
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.textColor = COLOR_WHITE
        cell.selectedBackgroundView = whenSelected
        
        if let t = episode.title{
            cell.textLabel?.text = "\(episode.format()) - \(t)"
        }else{
            cell.textLabel?.text = "\(episode.format())"
        }
        return cell;
    }
}


