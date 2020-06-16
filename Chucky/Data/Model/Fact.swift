//
//  Fact.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation

struct Fact: Decodable {
    
    let categories: [String]
    let icon_url: String
    let id: String
    let value: String
    let created_at: String
    
}
