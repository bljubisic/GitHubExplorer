//
//  GitHubManager.swift
//  GitHubExplorer
//
//  Created by Bratislav Ljubisic on 2/13/16.
//  Copyright © 2016 Bratislav Ljubisic. All rights reserved.
//

import Foundation
import UIKit

func searchLanguages(languages: String, returnFunc: AnyObject -> Void) -> Void {
    
    let url : NSURL = NSURL(string: "https://api.github.com/search/repositories?q=+language:\(languages)&sort=stars&order=desc&per_page=100")!
    let request: NSURLRequest = NSURLRequest(URL:url)
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    
    let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
        
        // notice that I can omit the types of data, response and error
        do {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            returnFunc(jsonDict)
            
        }  catch _ {
            
        }
    });
    
    // do whatever you need with the task e.g. run
    task.resume()
}

func getIssues(issueURL: String, openIssuesCount: Int, returnFunc: (AnyObject, issueUrlNew: String, openIssuesCountNew: Int) -> Void) -> Void {
    
    let issueURLNew = issueURL + "/" + String(openIssuesCount)
    let url : NSURL = NSURL(string: issueURLNew)!
    var openIssuesCountNew = openIssuesCount
    
    let request: NSURLRequest = NSURLRequest(URL:url)
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    
    let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
        
        // notice that I can omit the types of data, response and error
        do {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            if openIssuesCount > 0 {
                openIssuesCountNew -= 1
            }
            returnFunc(jsonDict, issueUrlNew: issueURL, openIssuesCountNew: openIssuesCountNew)
            
        }  catch _ {
            
        }
    });
    
    // do whatever you need with the task e.g. run
    task.resume()
    
}

func getContributors(contributorsURL: String, returnFunc: AnyObject -> Void) -> Void {
    
    let url : NSURL = NSURL(string: contributorsURL)!
    let request: NSURLRequest = NSURLRequest(URL:url)
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    
    let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
        
        // notice that I can omit the types of data, response and error
        do {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
            returnFunc(jsonDict)
            
        }  catch _ {
            print("error")
        }
    });
    
    // do whatever you need with the task e.g. run
    task.resume()
}

var imageCache = [String:UIImage]()

func getImage(url: String, imageView: UIImageView, defaultImage: String) {
    if let img = imageCache[url] {
        imageView.image = img
    } else {
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
        let mainQueue = NSOperationQueue.mainQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                let image = UIImage(data: data!)
                imageCache[url] = image
                
                dispatch_async(dispatch_get_main_queue(), {
                    imageView.image = image
                })
            }
            else {
                imageView.image = UIImage(named: defaultImage)
            }
        })
    }
}