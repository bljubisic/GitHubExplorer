//
//  GitHubExplorerViewController.swift
//  GitHubExplorer
//
//  Created by Bratislav Ljubisic on 2/12/16.
//  Copyright © 2016 Bratislav Ljubisic. All rights reserved.
//

import UIKit

class GitHubExplorerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var languageSearch: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var gitHubRepositoriesTable: UITableView!
    
    @IBAction func searchPressed(sender: AnyObject) {
        
        searchLanguages(languageSearch.text!, returnFunc: reloadRepositories)
        
    }
    
    var repositoriesTable: [NSDictionary] = [NSDictionary]()
    var repositoriesDict: NSDictionary = NSDictionary()
    var repositoryDict: NSDictionary = NSDictionary()
    var destinationVCClass: RepositoryDetailsViewController = RepositoryDetailsViewController()
    
    
    func reloadRepositories(response: AnyObject) -> Void {
        
        
        repositoriesDict = response as! NSDictionary
        let repositoriesTmpOpt: [NSDictionary]? = repositoriesDict["items"] as? [NSDictionary]
        
        if let repositoriesTmp = repositoriesTmpOpt {
            repositoriesTable = repositoriesTmp
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.gitHubRepositoriesTable.reloadData()
            self.gitHubRepositoriesTable.setContentOffset(CGPoint.zero, animated:true)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tmpCell: GitHubDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier("GitHubDetailsCell") as! GitHubDetailsTableViewCell
        let row: Int = indexPath.row
        
        let repository: NSDictionary = repositoriesTable[row]
        
        let imageURL: NSURL? = NSURL(string: repository["owner"]!["avatar_url"] as! String)!
        
        if let imageURLTmp = imageURL {
            getImage(imageURLTmp.absoluteString, imageView: tmpCell.avatarImage, defaultImage: "")
            
            //tmpCell.avatarImage = UIImageView(image: UIImage(data: NSData(contentsOfURL: imageURLTmp)!))
        }
        
        let repositoryTitleOpt: String? = repository["name"] as? String
        
        if let repositoryTitleStr = repositoryTitleOpt {
            tmpCell.repositoryTitle.text = repositoryTitleStr
            print("repositoryTitleStr: \(repositoryTitleStr) : \(row)")
            print(tmpCell.repositoryTitle.text)
        }
        
        let repositoryDescriptionOpt: String? = repository["description"] as? String
        
        if let repositoryDescStr = repositoryDescriptionOpt {
            tmpCell.repositoryDescription.text = repositoryDescStr
            print("repositoryDescStr: \(repositoryDescStr) : \(row)")
            print(tmpCell.repositoryDescription.text)
        }
        
        return tmpCell
        /*
        tmpCell.listItem.text = self.items[row].word as String
        if(self.items[row].completed == 1) {
            tmpCell.usedButton.selected = true
        }
        else {
            tmpCell.usedButton.selected = false
        }
        cell = tmpCell
        */
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Number of items: \(repositoriesTable.count)")
        
        return repositoriesTable.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 85.0
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row: Int = indexPath.row
        
        repositoryDict = repositoriesTable[row]
        
        destinationVCClass.repositoryDict = repositoryDict
        
        destinationVCClass.reloadViews()

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails"
        {
            if let destinationVC = segue.destinationViewController as? RepositoryDetailsViewController{
                //destinationVC.repositoryDict = repositoryDict
                self.destinationVCClass = destinationVC
                
            }
        }
    }
    
    @IBAction func unwindToRed(segue: UIStoryboardSegue) {
    }
    
    
}

