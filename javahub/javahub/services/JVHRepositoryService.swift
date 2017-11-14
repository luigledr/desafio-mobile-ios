//
//  JVHAPIClient.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import PMKAlamofire

class JVHRepositoryService : JVHRepositoryServiceProtocol {
    let decoder = JSONDecoder()
    
    func fetchJavaRepositories(page: Int?) -> Promise<JVHRepositoriesFetchResult?> {
        return fetchAndWrapRequestWithPromise({ fetchJavaRepositories(page: page, completion: $0) })
    }
    
    func fetchOwner(url: String) -> Promise<JVHUser?> {
        return fetchAndWrapRequestWithPromise({ fetchOwner(url: url, completion: $0) })
    }
    
    func fetchPulls(pullsUrl repositoryPath: String) -> Promise<[JVHPullRequest]?> {
        return fetchAndWrapRequestWithPromise({ fetchPulls(pullsUrl: repositoryPath, completion: $0) })
    }
    
    fileprivate func fetchJavaRepositories(page: Int?, completion: @escaping (JVHRepositoriesFetchResult?, Error?) -> Void) {
        var effectivePage = 1
        
        if let _page = page {
            effectivePage = _page
        }
        
        let url = JVHGithubUrl.repositories("java", effectivePage).path
        
        Alamofire.request(url, method: .get).response { response in
            if let error = response.error {
                completion(nil, error)
                
                return
            }
            
            guard let statusCode = response.response?.statusCode else {
                let repositories: [JVHRepository]? = []
                let result = (repositories: repositories, hasMore: false)
                
                completion(result, nil)
                
                return
            }
            
            if (statusCode != 200) {
                completion(nil, JVHHTTPError(code: statusCode, description: nil))
                
                return
            }
            
            let linkHeader = response.response?.allHeaderFields["Link"] as! String
            let linkData = JVHGithubLinkHeaderParser.parseGithubLinkHeader(input: linkHeader)
            let data = response.data
            let repositoriesResponse = try! self.decoder.decode(JVHRepositoriesResponse.self, from: data!)
            let result = (repositories: repositoriesResponse.items, hasMore: linkData.contains { key, value in key == "next" })
            
            completion(result, nil)
        }
    }
    
    fileprivate func fetchOwner(url: String, completion: @escaping (JVHUser?, Error?) -> Void) {
        let requestUrl = URL(string: url)!
        
        Alamofire.request(requestUrl, method: .get).response { response in
            if let error = response.error {
                completion(nil, error)
                
                return
            }
            
            guard let statusCode = response.response?.statusCode else {
                completion(nil, JVHHTTPError.unknown(description: nil))
                
                return
            }
            
            if (statusCode != 200) {
                completion(nil, JVHHTTPError(code: statusCode, description: nil))
                
                return
            }
            
            guard let data = response.data else {
                completion(nil, nil)
                
                return
            }
            
            let user = try! self.decoder.decode(JVHUser.self, from: data)
            
            completion(user, nil)
        }
    }
    
    fileprivate func fetchPulls(pullsUrl: String, completion: @escaping ([JVHPullRequest]?, Error?) -> Void) {
        Alamofire.request(pullsUrl, method: .get).response { response in
            if let error = response.error {
                completion(nil, error)
                
                return
            }
            
            guard let statusCode = response.response?.statusCode else {
                completion(nil, JVHHTTPError.unknown(description: nil))
                
                return
            }
            
            if (statusCode != 200) {
                completion(nil, JVHHTTPError(code: statusCode, description: nil))
                
                return
            }
            
            guard let data = response.data else {
                completion(nil, nil)
                
                return
            }
            
            let pullRequests = try! self.decoder.decode([JVHPullRequest]?.self, from: data)
            
            completion(pullRequests, nil)
        }
    }
    
    fileprivate func fetchAndWrapRequestWithPromise<T>(_ body: (@escaping (T, Error?) -> Swift.Void) throws -> Swift.Void) -> Promise<T> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return firstly {
            PromiseKit.wrap(body)
        }.then(on: DispatchQueue.global()) { data in
            data
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
