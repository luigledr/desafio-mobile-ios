//
//  JVHConstants.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import Foundation

indirect enum JVHGithubUrl {
    case repositories(String, Int)
    case pulls(String)
}

extension JVHGithubUrl : Path {
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    var path: URL {
        switch self {
        case .repositories(let language, let page): return URL(string: "/search/repositories?q=language:\(language)&sort=stars&page=\(page)", relativeTo: baseURL)!
        case .pulls(let repositoryPath): return URL(string: "\(repositoryPath)/pulls")!
        }
    }
    
    /// Remove unnecessary parameters coming from URLs from GitHub API.
    ///
    /// - Parameter path: The will be fixed path.
    /// - Returns: Fixed path.
    static func removeUnnecessaryParameters(from path: String) -> String {
        guard let discartablePartStartIndex = path.index(of: "{") else {
            return path
        }
        
        return String(path[..<discartablePartStartIndex])
    }
}
