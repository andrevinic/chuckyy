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
    let iconUrl: String?
    let id: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
          case categories
          case iconUrl
          case id
          case value
      }
    
    init(categories: [String] = [],
          iconUrl: String = "",
          id: String = "",
          value: String = "") {
         self.categories = categories
         self.iconUrl = iconUrl
         self.id = id
         self.value = value
     }
     
     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         
         if let categories = try container.decodeIfPresent([String].self, forKey: .categories), !categories.isEmpty {
             self.categories = categories
         } else {
             self.categories = ["UNCATEGORIZED"]
         }
         
         self.iconUrl = try container.decodeIfPresent(String.self, forKey: .iconUrl)
         self.id = try container.decode(String.self, forKey: .id)
         self.value = try container.decode(String.self, forKey: .value)
         
     }
}
