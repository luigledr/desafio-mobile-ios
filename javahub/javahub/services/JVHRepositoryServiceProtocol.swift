//
//  JVHAPIClientProtocol.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import Foundation
import PromiseKit

internal typealias JVHRepositoriesFetchResult = (repositories: [JVHRepository]?, hasMore: Bool)

protocol JVHRepositoryServiceProtocol {
    func fetchJavaRepositories(page: Int?) -> Promise<JVHRepositoriesFetchResult?>
    func fetchOwner(url: String) -> Promise<JVHUser?>
    func fetchPulls(pullsUrl: String) -> Promise<[JVHPullRequest]?>
}
