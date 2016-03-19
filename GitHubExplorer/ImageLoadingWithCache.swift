//
//  ImageLoadingWithCache.swift
//  GitHubExplorer
//
//  Created by Bratislav Ljubisic on 2/15/16.
//  Copyright © 2016 Bratislav Ljubisic. All rights reserved.
//

import Foundation
import UIKit


class ImageLoadingWithCache {
    
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
                    self.imageCache[url] = image
                    
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
}