//
//  JVHPullRequestsTableViewCell.swift
//  javahub
//
//  Created by Luiz Alberto on 13/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import UIKit
import PromiseKit
import AlamofireImage

class JVHPullRequestsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerUsername: UILabel!
    @IBOutlet weak var ownerFullName: UILabel!
    
    let repositoryService = JVHContainer.sharedInstance.container.resolve(JVHRepositoryServiceProtocol.self)
    
    func setup(pullRequest: JVHPullRequest) {
        titleLabel.text = pullRequest.title
        descriptionLabel.text = pullRequest.body
        
        guard let owner = pullRequest.user else {
            return
        }
        
        setup(with: owner)
    }
    
    fileprivate func setup(with owner: JVHOwner) {
        ownerUsername.text = owner.login
        
        if
            let repositoryService = self.repositoryService,
            let ownerPath = owner.url {
            firstly {
                repositoryService.fetchOwner(url: ownerPath)
            }.then { [weak self] data -> Void in
                guard
                    let _self = self,
                    let user = data else {
                    return
                }
                
                _self.ownerFullName.text = user.name
            }
        }
        
        if
            let ownerImagePath = owner.avatarUrl,
            let ownerAvatarUrl = URL(string: ownerImagePath) {
            ownerImageView.af_setImage(withURL: ownerAvatarUrl)
        }
    }
}
