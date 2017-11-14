//
//  JVHGithubLinkHeaderParser.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import Foundation

struct JVHGithubLinkHeaderParser {
    static func parseGithubLinkHeader(input: String) -> [String: String] {
        guard (input.count != 0) else {
            return [:]
        }
        
        // Split parts by comma
        let parts = input.components(separatedBy: ",")
        var links = [String: String]()
        // Parse each part into a named link
        for p in parts {
            var section = p.components(separatedBy: ";")
            guard section.count == 2 else {
                continue
            }
            
            let urlRegex = try! NSRegularExpression(pattern: "<(.*)>", options: [])
            let url = urlRegex.stringByReplacingMatches(in: section[0], options: [], range: NSRange(location: 0, length: section[0].count), withTemplate: "$1").trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
            
            let nameRegex = try! NSRegularExpression(pattern: "rel=\"(.*)\"", options: [])
            let name = nameRegex.stringByReplacingMatches(in: section[1], options: [], range: NSRange(location: 0, length: section[1].count), withTemplate: "$1").trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
            
            links[name] = url;
        }
        
        return links;
    }
}
