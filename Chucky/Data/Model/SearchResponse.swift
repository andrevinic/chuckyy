//
//  SearchResponse.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    
    let result: [Fact]
    let total: Int
    
}
