//
//  Repository.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import Foundation

struct JVHRepository : Codable {
    let id : Int?
    let name : String?
    let owner : JVHOwner?
    let description : String?
    let pullsUrl : String?
    let createdAt : String?
    let updatedAt : String?
    let pushedAt : String?
    let gitUrl : String?
    let stargazersCount : Int?
    let forksCount : Int?
    let forks : Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case pullsUrl = "pulls_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case gitUrl = "git_url"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case forks
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        owner = try values.decodeIfPresent(JVHOwner.self, forKey: .owner)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        pullsUrl = try values.decodeIfPresent(String.self, forKey: .pullsUrl)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        pushedAt = try values.decodeIfPresent(String.self, forKey: .pushedAt)
        gitUrl = try values.decodeIfPresent(String.self, forKey: .gitUrl)
        stargazersCount = try values.decodeIfPresent(Int.self, forKey: .stargazersCount)
        forksCount = try values.decodeIfPresent(Int.self, forKey: .forksCount)
        forks = try values.decodeIfPresent(Int.self, forKey: .forks)
    }
}
