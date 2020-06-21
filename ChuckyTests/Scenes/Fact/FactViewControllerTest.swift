//
//  FactViewControllerTest.swift
//  ChuckyTests
//
//  Created by Andre Nogueira on 20/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import XCTest
import RxSwift
@testable import Chucky

class FactViewControllerTest: XCTestCase {

    func test_view_number_of_lines_collection_view() {
        
        let viewModel = FactViewModel(factService: FactServiceMock(with: .success))
        let viewController = FactMainViewController(viewModel: viewModel)

        viewModel.fetch(with: "test")
        UIApplication.shared
        .windows
            .filter { $0.isKeyWindow }
        .first?
        .rootViewController = viewController
        
        XCTAssertEqual(viewController.tableView?.numberOfRows(inSection: 0), 2)
        
    }

}
