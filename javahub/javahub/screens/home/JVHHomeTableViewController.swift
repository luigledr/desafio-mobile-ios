//
//  JVHHomeTableViewController.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import UIKit
import PromiseKit

class JVHHomeTableViewController: UITableViewController {
    let fetchThreshold = 5
    var page = 1
    var repositoryService: JVHRepositoryServiceProtocol?
    var repositories: [JVHRepository]? = []
    var isLoadingMore = false
    var canLoadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadRepositories(page: page)
    }

    // MARK: - Private Methods
    
    func setupUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 118
        tableView.sectionFooterHeight = 0.0
    }
    
    func loadRepositories(page: Int) {
        isLoadingMore = true
        
        guard let repositoryService = repositoryService else {
            return
        }
        
        firstly {
            repositoryService.fetchJavaRepositories(page: page)
        }.then { [weak self] weakResult -> Void in
            guard let _self = self, let result = weakResult, let repositories = result.repositories else {
                return
            }
            
            if let globalRepositories = _self.repositories {
                _self.repositories = globalRepositories + repositories
            }
            
            _self.canLoadMore = result.hasMore
            
            _self.tableView.reloadData()
        }.catch { error in
        }.always { [weak self] in
            guard let _self = self else {
                return
            }
            
            _self.isLoadingMore = false
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repositories = self.repositories else {
            return 0
        }
        
        return repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! JVHRepositoryTableViewCell
        let repository = self.repositories![indexPath.row]
        
        cell.setup(repository: repository)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (repositories!.count - indexPath.row) == fetchThreshold && canLoadMore && !isLoadingMore {
            page = page + 1

            loadRepositories(page: page)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let pullRequestsViewController = segue.destination as? JVHPullRequestsTableViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let selectedRepository = repositories?[selectedIndexPath.row],
            segue.identifier == "ShowPullRequestsSegue" else {
            return
        }
        
        pullRequestsViewController.setup(repository: selectedRepository)
    }
}
