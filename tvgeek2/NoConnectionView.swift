//
//  NoConnectionView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-16.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class NoConnectionViewController: UIViewController, RefreshConnectionDelegate{
    private var connectionView:NoConnectionView
    private var failQuotes:[String] = [
        "\"Is Star Wars the one with the little wizard boy?\" - Ron Swanson, Parks and Rec",
        "\"Dear frozen yogurt, you are the celery of desserts. Be ice cream or be nothing. Zero stars.\" - Ron Swanson, Parks and Rec",
        "\"Whenever I’m really unsure about an idea, first I abuse the people whose help I need. And then I take a nap.\" - Don Draper, Mad Men",
        "\"He put my stuff in jello again!\" - Dwite Schrute, The Office",
        "\"You know I always wanted to pretend I was an architect.\" - George Costanza, Seinfeld",
        "\"If you can’t say something bad about a relationship you shouldn’t say anything at all.\" - George Costanza, Seinfeld",
        "\"With great mustache, comes great responsibility.\" - Peter Griffen, Family Guy",
        "\"This woman hates me so much, I'm starting to like her.\" - George Costanza, Seinfeld",
    ]
    
    init(){
        
        var quote:UInt32 = arc4random_uniform(UInt32(failQuotes.count))
        self.connectionView = NoConnectionView(failQuotes[Int(quote)])
        
        super.init(nibName: nil, bundle: nil)
        
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = connectionView
    }
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        connectionView.delegate = self
        
        var view = UIAlertView(
            title: "Connection Error",
            message: "TVGeek could not connect to the server. Please try again later",
            delegate: nil,
            cancelButtonTitle: "Okay"
        )
        
        view.show()
    }
    
    func refreshConnection() {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
}

class NoConnectionView:UIView{
    
    private var label = UILabel()
    private var button = UIButton()
    var delegate: RefreshConnectionDelegate?
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ err: String){
        super.init(frame: CGRectZero)
        self.backgroundColor = COLOR_DARK
        
        label.text = err
        label.textColor = COLOR_GRAY_FADE
        label.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        
        button.setTitle("Retry", forState: UIControlState.Normal)
        button.backgroundColor = COLOR_GRAY
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = COLOR_LIGHT.CGColor
        button.addTarget(self, action: Selector("retry:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(label)
        self.addSubview(button)
    }
    
    func retry(sender: AnyObject){
        if let d = delegate{
            d.refreshConnection()
        }
    }
    
    override func layoutSubviews() {
        var lims = self.bounds.size
        
        
        var button_size = button.sizeThatFits(self.bounds.size)
        
        var size = label.sizeThatFits(lims)
        label.frame = CGRect(x:PADDING, y:(lims.height-size.height)/2 - (button_size.height + PADDING * 2), width:lims.width - PADDING*2, height: size.height)
        
        button.frame = CGRect(x: lims.width/3, y: label.frame.origin.y + label.frame.height + PADDING*2, width: lims.width/3, height: button_size.height)
    }
}

