//
//  SLUser.swift
//  StockList
//
//  Created by Pankaj Teckchandani on 09/04/20.
//  Copyright © 2020 Pankaj Teckchandani. All rights reserved.
//

import UIKit

class SLUser: Codable {
    
    let avatarUrl: String?
    let displayName: String?
    let username: String?
    let id: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case username
        case displayName = "display_name"
        case id
    }
    
    init(avatarUrl : String, displayName : String, id : Int, username: String) {
        self.avatarUrl = avatarUrl
        self.displayName = displayName
        self.username = username
        self.id = id
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }
}
