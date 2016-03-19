//
//  RepositoryDetailsViewController.swift
//  GitHubExplorer
//
//  Created by Bratislav Ljubisic on 2/16/16.
//  Copyright © 2016 Bratislav Ljubisic. All rights reserved.
//

import UIKit

class RepositoryDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var repositoryTitle: UILabel!
    @IBOutlet weak var repositoryDescription: UILabel!
    @IBOutlet weak var contributorsTable: UITableView!
    @IBOutlet weak var issuesTable: UITableView!
    @IBOutlet weak var avatarImage: UIImageView!
    
    var repositoryDict: NSDictionary = NSDictionary()
    var issues: [NSDictionary] = [NSDictionary]()
    var contributors: [NSDictionary] = [NSDictionary]()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.repositoryDescription.lineBreakMode = .ByWordWrapping
        self.repositoryDescription.numberOfLines = 0
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func reloadIssues(response: AnyObject, issuesUrl: String, openIssuesCountNew: Int) -> Void {
       
        //if let responseTmp = response as!
        issues.append(response as! NSDictionary)

        if(openIssuesCountNew > 0) {
            getIssues(issuesUrl, openIssuesCount: openIssuesCountNew, returnFunc: reloadIssues)
        }
        //repositoriesTable = repositoriesDict["items"] as! [NSDictionary]
        else {
            dispatch_async(dispatch_get_main_queue(), {
                self.issuesTable.reloadData()
                self.issuesTable.setContentOffset(CGPoint.zero, animated:true)
            })
        }
    }
    
    func reloadContributors(response: AnyObject) -> Void {
        contributors = response as! [NSDictionary]
        
        //repositoriesTable = repositoriesDict["items"] as! [NSDictionary]
        
        dispatch_async(dispatch_get_main_queue(), {
            self.contributorsTable.reloadData()
            self.contributorsTable.setContentOffset(CGPoint.zero, animated:true)
        })
    }
    
    func reloadViews() {
        
        let openIssuesCount: Int = repositoryDict["open_issues_count"] as! Int
        
        var issuesUrl = repositoryDict["issues_url"] as! NSString
        let range: NSRange = issuesUrl.rangeOfString("{/number}")
        //let lenght =  range.length
        let location = range.location
        
        issuesUrl = issuesUrl.substringToIndex(location)
        
        getIssues(issuesUrl as String, openIssuesCount: openIssuesCount, returnFunc: reloadIssues)
        getContributors(repositoryDict["contributors_url"] as! String, returnFunc: reloadContributors)
        
        let imageURL: NSURL? = NSURL(string: repositoryDict["owner"]!["avatar_url"] as! String)!
        
        if let imageURLTmp = imageURL {
            getImage(imageURLTmp.absoluteString, imageView: avatarImage, defaultImage: "")
            
            //tmpCell.avatarImage = UIImageView(image: UIImage(data: NSData(contentsOfURL: imageURLTmp)!))
        }
        
        let repositoryTitleOpt: String? = repositoryDict["name"] as? String
        
        if let repositoryTitleStr = repositoryTitleOpt {
            repositoryTitle.text = repositoryTitleStr
            //print("repositoryTitleStr: \(repositoryTitleStr) : \(row)")
            print(repositoryTitle.text)
        }
        
        let repositoryDescriptionOpt: String? = repositoryDict["description"] as? String
        
        if let repositoryDescStr = repositoryDescriptionOpt {
            repositoryDescription.text = repositoryDescStr
            //print("repositoryDescStr: \(repositoryDescStr) : \(row)")
            print(repositoryDescription.text)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if(tableView == issuesTable) {
            let tmpCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("issueCell")!
            let row: Int = indexPath.row
            let issue = issues[row]
            
            let user = issue["user"] as? NSDictionary
            if let userTmp = user {
                tmpCell.textLabel!.text = issue["title"] as! String + " by " + (userTmp["login"] as! String)
            }
            cell = tmpCell
            
        }
        else {
            let tmpCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("contributorCell")!
            let row: Int = indexPath.row
            let contributor = contributors[row]
            
            tmpCell.textLabel!.text = contributor["login"] as? String
            
            cell = tmpCell

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == contributorsTable) {
            if (contributors.count > 3) {
                return 3
            }
            else {
                return contributors.count
            }
        }
        else {
            if (issues.count > 3) {
                return 3
            }
            else {
                return issues.count
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
    }
    
}
