//
//  Environment.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation

class Environment {
    
    static let baseURL = Environment.pList(key: "BASE_URL")
    
    private static func pList(key: String) -> String {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
    }
    
}
