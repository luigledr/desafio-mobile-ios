//
//  JVHPullRequestsTableViewController.swift
//  javahub
//
//  Created by Luiz Alberto on 13/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import UIKit
import PromiseKit
import SafariServices

class JVHPullRequestsTableViewController: UITableViewController {
    var repositoryService: JVHRepositoryServiceProtocol?
    var pullsUrl: String?
    var repository: JVHRepository?
    var pullRequests: [JVHPullRequest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setup(repository: JVHRepository) {
        self.repository = repository
        self.title = repository.name
        
        guard let pullsUrl = repository.pullsUrl else {
            return
        }
        
        self.pullsUrl = JVHGithubUrl.removeUnnecessaryParameters(from: pullsUrl)
        
        load()
    }
    
    // MARK: - Private Methods
    
    func setupUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 118
        tableView.sectionFooterHeight = 0.0
    }
    
    func load() {
        guard
            let repositoryService = self.repositoryService,
            let pullsUrl = self.pullsUrl else {
            return
        }

        firstly {
            repositoryService.fetchPulls(pullsUrl: pullsUrl)
        }.then { [weak self] result -> Void in
            guard let _self = self, let pullRequests = result else {
                return
            }
            
            _self.pullRequests = pullRequests

            _self.tableView.reloadData()
        }.catch { error in
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pullRequests = self.pullRequests else {
            return 0
        }
        
        return pullRequests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PullRequestTableViewCell", for: indexPath) as! JVHPullRequestsTableViewCell

        cell.setup(pullRequest: pullRequests![indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let pullRequest = pullRequests?[indexPath.row],
            let pullRequestHtmlPath = pullRequest.htmlUrl,
            let pullRequestHtmlUrl = URL(string: pullRequestHtmlPath) else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: pullRequestHtmlUrl)
        
        if #available(iOS 11.0, *) {
            if let principalColor = UIColor(named: "Principal") {
                safariViewController.preferredControlTintColor = principalColor
            }
        }
        
        self.present(safariViewController, animated: true, completion: nil)
    }
}
