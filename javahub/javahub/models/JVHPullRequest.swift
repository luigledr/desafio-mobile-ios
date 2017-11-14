//
//  JVHPullRequest.swift
//  javahub
//
//  Created by Luiz Alberto on 13/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import Foundation

struct JVHPullRequest : Codable {
    let id : Int?
    let htmlUrl : String?
    let title : String?
    let user : JVHOwner?
    let body : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case htmlUrl = "html_url"
        case title = "title"
        case user
        case body = "body"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        user = try values.decodeIfPresent(JVHOwner.self, forKey: .user)
        body = try values.decodeIfPresent(String.self, forKey: .body)
    }
}
