//
//  FactModelTests.swift
//  ChuckyTests
//
//  Created by Andre Nogueira on 19/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import XCTest
import Foundation
@testable import Chucky

class FactModelTests: XCTestCase {
    
    func test_methods_data_model() {
        let fact = Fact(categories: ["animal", "dev"], iconUrl: "", id: "", value: "")
        
        XCTAssertFalse(fact.categories.isEmpty)
        XCTAssertEqual(fact.categories.count, 2)
    }
}
