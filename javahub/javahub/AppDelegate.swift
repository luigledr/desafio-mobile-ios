//
//  AppDelegate.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initializeContainer()
        initializeRootViewController()

        return true
    }

    //MARK: - Custom Methods
    
    func initializeContainer() {
        JVHContainer.sharedInstance.configureServices()
        JVHContainer.sharedInstance.configureControllers()
    }
    
    func initializeRootViewController() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        window.rootViewController = JVHContainer.sharedInstance.initializeContainerNavigationController()
    }
}
