//
//  FactAPI.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import Moya

enum FactAPI {
    
    case search(query: String)
    case categories
    
}

extension FactAPI: TargetType {
    
    var baseURL: URL {
        return Environment.baseURL.url
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search/"
        case .categories:
            return "/categories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        case .categories:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search:
            return Bundle.main.dataFromJsonFile(name: "mock_norris_response_success")
        case .categories:
            return Bundle.main.dataFromJsonFile(name: "mock_norris_response_success")

        }
    }
    var parameters: [String: Any]? {
          switch self {
         
          case .search(let query):
              return ["query": query]
          case .categories:
                return nil
          }
      }
    
    var task: Task {
           if let `parameters` = parameters {
               return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
           } else {
               return .requestPlain
           }
     }
    
    var headers: [String : String]? {
        return nil
    }
}
