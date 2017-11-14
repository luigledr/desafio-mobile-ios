//
//  JVHRepositoryTableViewCell.swift
//  javahub
//
//  Created by Luiz Alberto on 13/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import UIKit
import PromiseKit
import AlamofireImage

class JVHRepositoryTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerUserNameLabel: UILabel!
    @IBOutlet weak var ownerFullNameLabel: UILabel!
    
    // MARK: Properties
    var repositoryService = JVHContainer.sharedInstance.container.resolve(JVHRepositoryServiceProtocol.self)
    
    func setup(repository: JVHRepository) {
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        starsLabel.text = repository.stargazersCount != nil ? "\(repository.stargazersCount!)" : ""
        forksLabel.text = repository.forks != nil ? "\(repository.forks!)" : ""
        
        if let owner = repository.owner {
            ownerUserNameLabel.text = owner.login
            ownerImageView.af_setImage(withURL: URL(string: owner.avatarUrl!)!)
            
            guard
                let repositoryService = self.repositoryService,
                let ownerUrl = owner.url else {
                return
            }
            
            firstly {
                repositoryService.fetchOwner(url: ownerUrl)
            }.then { [weak self] owner -> Void in
                guard let _self = self else {
                    return
                }
                
                _self.ownerFullNameLabel.text = owner?.name
            }
        }
    }
}
