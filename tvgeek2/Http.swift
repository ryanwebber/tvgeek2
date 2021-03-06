//
//  Http.swift
//  tvgeek2
//
//  Created by Ryan Webber on 2014-12-02.
//  Copyright (c) 2014 Ryan Webber. All rights reserved.
//

import Foundation

class Http {
    
    func get(url: NSURL, headers: Dictionary<String, String>, completionHandler: ((result: HttpResult) -> Void)!) {
        action("GET", url: url, headers: headers, data: NSData() ) { (result) in
            completionHandler(result: result)
        }
    }
    
    func action(verb: String, url: NSURL, headers: Dictionary<String, String>, data: NSData, completionHandler: ((result: HttpResult) -> Void)!) {
        let httpRequest = NSMutableURLRequest(URL: url)
        httpRequest.HTTPMethod = verb
        
        for (headerKey, headerValue) in headers {
            httpRequest.setValue(headerValue, forHTTPHeaderField: headerKey)
        }
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(httpRequest, fromData: data) { (data, response, error) in
            completionHandler(result: HttpResult(data: data, request: httpRequest, response: response, error: error))
        }
        task.resume()
    }
}

class HttpResult {
    
    var request: NSURLRequest
    var response: NSHTTPURLResponse?
    var data: NSData?
    var error: NSError?
    var statusCode: Int = 0
    var success: Bool = false
    var headers : Dictionary<String, String> {
        get {
            if let responseValue = response {
                return responseValue.allHeaderFields as! Dictionary<String,String>
            }
            else {
                return Dictionary<String, String>()
            }
        }
    }
    
    init(data: NSData?, request: NSURLRequest, response: NSURLResponse?, error : NSError?) {
        self.data = data
        self.request = request
        self.response = response as! NSHTTPURLResponse?
        self.error = error
        self.success = false
        
        if error != nil {
            print("Http.\(request.HTTPMethod!): \(request.URL)")
            print("Error: \(error!.localizedDescription)")
        }
        else {
            if let responseValue = self.response {
                statusCode = responseValue.statusCode
                if statusCode >= 200 && statusCode < 300 {
                    success = true
                }
                else {
                    print("Http.\(request.HTTPMethod!) \(request.URL)")
                    print("Status: \(statusCode)")
                    if let jsonError: AnyObject = jsonObject {
                        var err: NSError?
                        var errData: NSData?
                        do {
                            errData = try NSJSONSerialization.dataWithJSONObject(jsonError, options:NSJSONWritingOptions.PrettyPrinted)
                        } catch let error as NSError {
                            err = error
                            errData = nil
                        }
                        let errMessage = NSString(data: errData!, encoding: NSUTF8StringEncoding)
                        print("Error: \(errMessage)")
                    }
                }
            }
        }
    }
    
    var jsonObject: AnyObject? {
        var resultJsonObject: AnyObject?
        var jsonError: NSError?
        if let contentType = headers["Content-Type"] {
            if contentType.rangeOfString("application/json") != nil {
                do {
                    try resultJsonObject = NSJSONSerialization.JSONObjectWithData(self.data!, options: .AllowFragments) as AnyObject?
                } catch {
                    resultJsonObject = nil
                }
            }
        }
        return resultJsonObject
    }    
}