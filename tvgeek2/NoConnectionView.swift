//
//  NoConnectionView.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2015-03-16.
//  Copyright (c) 2015 Ryan Webber. All rights reserved.
//

import Foundation
import UIKit

class NoConnectionViewController: UIViewController{
    private var connectionView:NoConnectionView
    
    init(error: String){
        self.connectionView = NoConnectionView(error)
        super.init(nibName: nil, bundle: nil)
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = connectionView
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.navigationController?.pushViewController(SearchViewController(searchBar.text), animated: true)
        searchBar.text = nil
    }
    
    func shouldViewShow(showId: Int) {
        self.navigationController?.pushViewController(ShowViewController(showId: showId), animated: true)
    }
}

class NoConnectionView:UIView{
    
    private var label = UILabel()
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ err: String){
        super.init()
        self.backgroundColor = COLOR_DARK
        
        label.text = err
        label.textColor = COLOR_WHITE
        label.font = UIFont.systemFontOfSize(FONT_SIZE_LARGE)
        
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        var lims = self.bounds.size
        
        var size = label.sizeThatFits(lims)
        label.frame = CGRect(x:PADDING, y:(lims.height-size.height)/2, width:lims.width - PADDING*2, height: size.height)
    }
}

