//
//  JVHUser.swift
//  javahub
//
//  Created by Luiz Alberto on 13/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import Foundation

struct JVHUser : Codable {
    let login : String?
    let id : Int?
    let avatarUrl : String?
    let gravatarId : String?
    let url : String?
    let organizationsUrl : String?
    let reposUrl : String?
    let type : String?
    let name : String?
    let company : String?
    let email : String?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url = "url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case type = "type"
        case name = "name"
        case company = "company"
        case email = "email"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        gravatarId = try values.decodeIfPresent(String.self, forKey: .gravatarId)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        organizationsUrl = try values.decodeIfPresent(String.self, forKey: .organizationsUrl)
        reposUrl = try values.decodeIfPresent(String.self, forKey: .reposUrl)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }
}
