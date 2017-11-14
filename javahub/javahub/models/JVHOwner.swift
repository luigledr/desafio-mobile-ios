//
//  RepositoryOwner.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import Foundation

struct JVHOwner : Codable {
    let login : String?
    let id : Int?
    let avatarUrl : String?
    let gravatarId : String?
    let url: String?
    let type : String?
    let siteAdmin : Bool?
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case type = "type"
        case siteAdmin = "site_admin"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        gravatarId = try values.decodeIfPresent(String.self, forKey: .gravatarId)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        siteAdmin = try values.decodeIfPresent(Bool.self, forKey: .siteAdmin)
    }
}
