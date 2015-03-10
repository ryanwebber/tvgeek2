//
//  URLImageView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-07.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class URLImageView : UIImageView{
    
    private var loader = UIActivityIndicatorView()
    
    override init(){
        super.init(frame: CGRectZero)
        self.backgroundColor = COLOR_DARK
        self.clipsToBounds = true
        
        loader.startAnimating()
        loader.alpha = 0.2
        
        self.addSubview(loader)
    }
    
    func setImageUrl(url: String?){
        Api().getImageDataFromUrl(url, success: {(data: NSData) -> Void in
            self.loader.hidden = true;
            UIView.transitionWithView(self,
                duration:1,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: {
                    self.image = UIImage(data: data)
                },
                completion: nil
            )
        }, failure: {() -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.setImageUnknown()
            }
            NSLog("[ImageView] Failure to get image {\(url)}")
        })
    }
    
    func setImageUnknown(){
        loader.stopAnimating()
        loader.hidden = true
        self.backgroundColor = COLOR_GRAY
        self.setNeedsLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var lims = self.bounds.size
        loader.frame = CGRect(
            x: (lims.width + loader.frame.width) / 2,
            y: (lims.height + loader.frame.height) / 2,
            width: loader.frame.width,
            height: loader.frame.height
        )
    }
}