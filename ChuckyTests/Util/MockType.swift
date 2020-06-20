//
//  MockType.swift
//  ChuckyTests
//
//  Created by Andre Nogueira on 19/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation

enum MockType {
    
    case success
    case successWith(jsonFile: String)
    case empty
    case error
    
}
