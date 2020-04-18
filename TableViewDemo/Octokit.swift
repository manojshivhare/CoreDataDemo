//
//  Octokit.swift
//  TableViewDemo
//
//  Created by Manoj Shivhare on 03/04/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import Foundation
struct OctokitModel: Codable {
    var name: String?
    var description: String?
//    var license: String?
//    var permissions: String?
    var openIssuesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case openIssuesCount = "open_issues_count"
        case description = "description"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        openIssuesCount = try values.decode(Int.self, forKey: .openIssuesCount)
    }
    
}
