//
//  FactViewModelTest.swift
//  ChuckyTests
//
//  Created by Andre Nogueira on 19/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import XCTest
import RxSwift
@testable import Chucky

class FactViewModelTest: XCTestCase {

    private let disposeBag = DisposeBag()
    
    func test_fetch_facts_success() {
        let mockService = FactServiceMock(with: .success)
        let viewModel = FactViewModel(factService: mockService)
        viewModel.fetch(with: "test")
        
        let facts = viewModel.facts
        XCTAssertEqual(facts.count, 3)
        let fact = facts[0]
        XCTAssertEqual(fact.id, "3")
        XCTAssertEqual(fact.iconUrl, "1")
        XCTAssertEqual(fact.categories.count, 2)

        viewModel.categories()
        let categories = viewModel.categoriesList
        
        XCTAssertEqual(categories.count, 3)
    }
    
    func test_fetch_facts_with_json() {
        let mockService = FactServiceMock(with: .successWith(jsonFile: "search_query_chuck_success"))
        let viewModel = FactViewModel(factService: mockService)
        viewModel.fetch(with: "test")
        
        let facts = viewModel.facts
        XCTAssertEqual(facts.count, 9669)
        XCTAssertNotNil(facts[0])
        
    }
    
    func test_fetch_empty_error() {
        let mockService = FactServiceMock(with: .empty)
        let viewModel = FactViewModel(factService: mockService)
        viewModel.fetch(with: "")
        
        let facts = viewModel.facts
        XCTAssertTrue(facts.isEmpty)
        
        viewModel.categories()
        let categories = viewModel.categoriesList
        
        XCTAssertEqual(categories.count, 0)
    }
    
    func test_fetch_facts_receive_error() {
        let mockService = FactServiceMock(with: .error)
        let viewModel = FactViewModel(factService: mockService)
        
        viewModel.fetch(with: "")
        let facts = viewModel.facts
        
        XCTAssertEqual(facts.count, 0)
        
        viewModel.categories()
        let categories = viewModel.categoriesList
        
        XCTAssertEqual(categories.count, 0)
    }
   
}
