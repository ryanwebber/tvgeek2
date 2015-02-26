//
//  urlBuilder.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2014-12-04.
//  Copyright (c) 2014 Ryan Webber. All rights reserved.
//

import Foundation

class urlBuilder{
    var url = "";
    var identity = "unknown";
    
    init(_ url: String, _ id: String="unknown"){
        self.url = url;
        self.identity = id;
    }
    
    func identifier() -> String{
        return self.identity;
    }
    
    func build() -> String{
        return url;
    }
}

class popularURL : urlBuilder {
    
    init(){
        super.init("http://api.trakt.tv/shows/trending.json/"+ApiKeys.trakt, "Popular");
    }
    
    override func build() -> String {
        return self.url;
    }
}

class showURL : urlBuilder {
    var id: Int;
    
    init(_ id: Int){
        self.id=id;
        super.init("http://api.trakt.tv/show/summary.json/"+ApiKeys.trakt, "Show-\(id)");
    }
    
    override func build() -> String {
        return self.url+"/"+String(self.id);
    }
}