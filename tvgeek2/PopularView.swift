//
//  PopularView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-17.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class PopularView:UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    private var shows:[Show] = []
    private var images: [URLImageView] = []
    
    var showDelegate: ViewShowDelegate?
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        super.init(frame: CGRectZero, collectionViewLayout: layout)
        self.backgroundColor = COLOR_WHITE
        self.delegate = self
        self.dataSource = self
        self.registerClass(PopularShowCell.classForCoder(), forCellWithReuseIdentifier: PopularShowCell.identifier)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return shows.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(PopularShowCell.identifier, forIndexPath: indexPath) as PopularShowCell
        var r = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        var g = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        var b = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        cell.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        cell.setShow(self.shows[indexPath.item], cover: images[indexPath.item])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        if let del = self.showDelegate{
            del.shouldViewShow(shows[indexPath.item].id)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        var width = collectionView.bounds.width / 2
        return CGSize(width: width, height: width)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var height = size.width / 2
        var max_height = ceil(CGFloat(self.shows.count/2))
        return CGSize(width: size.width, height: height*max_height)
    }
    
    func setShows(shows: [Show]){
        self.shows = shows
        
        for show in shows{
            var image = URLImageView()
            image.setImageUrl(show.cover)
            image.contentMode = UIViewContentMode.ScaleAspectFill
            images.append(image)
        }
        self.reloadData()
    }    
}

class PopularShowCell: UICollectionViewCell{
    class var identifier:String{
        return "popular"
    }
    private var cover = URLImageView()
    private var title = UILabel()
    private var year = UILabel()
    private var overlay = UIView()
    private var gradient = CAGradientLayer()
    
    override init(frame: CGRect){
        super.init(frame:frame)
        
        cover.contentMode = UIViewContentMode.ScaleAspectFill
        cover.backgroundColor = COLOR_GRAY
        
        title.textColor = COLOR_WHITE
        title.adjustsFontSizeToFitWidth = false;
        title.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        title.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        title.numberOfLines = 1
        
        year.textColor = COLOR_LIGHT
        year.font = UIFont.systemFontOfSize(FONT_SIZE_SMALL)
        
        let color0 = UIColor(red:0, green:0, blue:0, alpha:0.0).CGColor
        let color1 = UIColor(red:0, green:0, blue:0, alpha:0.0).CGColor
        let color2 = UIColor(red:0, green:0, blue:0, alpha:0.5).CGColor
        let color3 = UIColor(red:0, green:0, blue:0, alpha:1).CGColor
        
        gradient.colors = [color0,color1,color2]
        gradient.locations = [0, 0.4, 0.6, 1]
        overlay.layer.insertSublayer(gradient, atIndex: 0)
        
        overlay.addSubview(year)
        overlay.addSubview(title)
        
        
        self.addSubview(overlay)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShow(show: Show, cover: URLImageView){
        self.cover = cover
        self.title.text = show.title
        if let y = show.year{
            self.year.text = "(\(y))"
        }else{
            self.year.text = "(----)"
        }
        
        self.insertSubview(cover, belowSubview: overlay)
        self.setNeedsLayout()
    }
    
    override func setNeedsLayout() {
        super.layoutSubviews()
        gradient.frame = self.bounds
        var lims = self.bounds.size
        
        cover.frame = self.bounds
        
        var offset = lims.height - ((PADDING*2) + title.font.lineHeight + year.font.lineHeight)
        overlay.frame = self.bounds
        
        title.frame = CGRect(x: PADDING, y: offset + PADDING, width: lims.width - PADDING*2, height: title.font.lineHeight)
        year.frame = CGRect(x: PADDING, y: offset + PADDING + title.font.lineHeight, width: lims.width - PADDING*2, height: title.font.lineHeight)
    }
}

