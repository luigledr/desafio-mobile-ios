//
//  JVHContainerConfigurator.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import AlamofireImage

class JVHContainer {
    static let sharedInstance = JVHContainer();
    let container: Container
    var mainStoryboard: SwinjectStoryboard?
    
    private init() {
        container = Container()
    }
    
    public func configureServices() {
        container.register(JVHRepositoryServiceProtocol.self, factory: { _ in JVHRepositoryService() })
        container.register(AutoPurgingImageCache.self, factory: { c in AutoPurgingImageCache() })
        container.register(ImageDownloader.self, factory: { c in ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                                                                 downloadPrioritization: .fifo,
                                                                                 maximumActiveDownloads: 4,
                                                                                 imageCache: c.resolve(AutoPurgingImageCache.self)) })
    }
    
    public func configureControllers() {
        container.storyboardInitCompleted(JVHContainerNavigationController.self, initCompleted: {r, c in })
        container.storyboardInitCompleted(JVHHomeTableViewController.self, initCompleted: {r, c in
            c.repositoryService = r.resolve(JVHRepositoryServiceProtocol.self)
        })
        container.storyboardInitCompleted(JVHPullRequestsTableViewController.self, initCompleted: {r, c in
            c.repositoryService = r.resolve(JVHRepositoryServiceProtocol.self)
        })
        
        mainStoryboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
    }
    
    public func initializeContainerNavigationController() -> UIViewController? {
        guard let mainStoryboard = self.mainStoryboard else {
            return nil
        }
        
        return mainStoryboard.instantiateViewController(withIdentifier: "ContainerNavigationController") as! JVHContainerNavigationController
    }
}
