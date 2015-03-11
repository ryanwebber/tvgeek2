//
//  RatingView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-10.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class RatingView:UIView{
    
    private var fullhearts: [UIImageView] = []
    private var halfhearts: [UIImageView] = []
    private var emptyhearts: [UIImageView] = []
    
    override init(){
        super.init(frame: CGRectZero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRating(rating: CGFloat){
        var r = rating / 2;
        while(!fullhearts.isEmpty){
            fullhearts[0].removeFromSuperview()
            fullhearts.removeAtIndex(0)
        }
        while(!halfhearts.isEmpty){
            halfhearts[0].removeFromSuperview()
            halfhearts.removeAtIndex(0)
        }
        while(!emptyhearts.isEmpty){
            emptyhearts[0].removeFromSuperview()
            emptyhearts.removeAtIndex(0)
        }
        
        var numFullStars = Int(round(r - 0.25))
        var numHalfStars = (r - floor(r)) > 0.25 && (r - floor(r)) < 0.75 ? 1 : 0
        var numEmptyStars = 5 - numFullStars - numHalfStars
        
        for(var i=0;i<numFullStars;i++){
            var imgview = UIImageView(image: UIImage(named: "heart"))
            imgview.contentMode = UIViewContentMode.ScaleAspectFit
            fullhearts.append(imgview)
            self.addSubview(imgview)
        }
        
        for(var i=0;i<numHalfStars;i++){
            var imgview = UIImageView(image: UIImage(named: "heart-half"))
            imgview.contentMode = UIViewContentMode.ScaleAspectFit
            fullhearts.append(imgview)
            self.addSubview(imgview)
        }
        
        for(var i=0;i<numEmptyStars;i++){
            var imgview = UIImageView(image: UIImage(named: "heart-empty"))
            imgview.contentMode = UIViewContentMode.ScaleAspectFit
            fullhearts.append(imgview)
            self.addSubview(imgview)
        }
    }
    
    override func layoutSubviews() {
        var lims = self.bounds.size
        
        var full_width = (lims.height * 5) + (PADDING_SMALL * 4)
        var hwidth = lims.height
        var offset = (lims.width - full_width) / 2
        
        for(var i=0;i<fullhearts.count;i++){
            fullhearts[i].frame = CGRect(
                x: offset + ((hwidth + PADDING_SMALL) * CGFloat(i)),
                y: 0,
                width: hwidth,
                height: hwidth
            )
        }
        
        for(var i=0;i<halfhearts.count;i++){
            fullhearts[i].frame = CGRect(
                x: offset + ((hwidth + PADDING_SMALL) * CGFloat(i + fullhearts.count)),
                y: 0,
                width: hwidth,
                height: hwidth
            )
        }
        
        for(var i=0;i<emptyhearts.count;i++){
            fullhearts[i].frame = CGRect(
                x: offset + ((hwidth + PADDING_SMALL) * CGFloat(i + fullhearts.count + halfhearts.count)),
                y: 0,
                width: hwidth,
                height: hwidth
            )
        }
    }
    
}