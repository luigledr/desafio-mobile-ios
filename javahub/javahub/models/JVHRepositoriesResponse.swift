//
//  JVHRepositoriesResponse.swift
//  javahub
//
//  Created by Luiz Alberto on 12/11/17.
//  Copyright © 2017 Luiz Alberto. All rights reserved.
//

import UIKit

struct JVHRepositoriesResponse : Codable {
    let totalCount : Int?
    let incompleteResults : Bool?
    let items : [JVHRepository]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        incompleteResults = try values.decodeIfPresent(Bool.self, forKey: .incompleteResults)
        items = try values.decodeIfPresent([JVHRepository].self, forKey: .items)
    }
}
