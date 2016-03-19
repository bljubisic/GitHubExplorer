//
//  GitHubDetailsTableViewCell.swift
//  GitHubExplorer
//
//  Created by Bratislav Ljubisic on 2/14/16.
//  Copyright © 2016 Bratislav Ljubisic. All rights reserved.
//

import UIKit

class GitHubDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var repositoryTitle: UILabel!
    @IBOutlet weak var repositoryDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
