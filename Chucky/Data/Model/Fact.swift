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
    let icon_url: String?
    let id: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
          case categories
          case icon_url
          case id
          case value
      }
    
    init(categories: [String] = [],
          icon_url: String = "",
          id: String = "",
          value: String = "") {
         self.categories = categories
         self.icon_url = icon_url
         self.id = id
         self.value = value
     }
     
     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         
         if let categories = try container.decodeIfPresent([String].self, forKey: .categories) {
             self.categories = categories
         } else {
             self.categories = ["unknown"]
         }
         
         self.icon_url = try container.decodeIfPresent(String.self, forKey: .icon_url)
         self.id = try container.decode(String.self, forKey: .id)
         self.value = try container.decode(String.self, forKey: .value)
         
     }
}
