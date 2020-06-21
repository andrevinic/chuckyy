//
//  FactServiceMock.swift
//  ChuckyTests
//
//  Created by Andre Nogueira on 19/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit
import RxSwift
@testable import Chucky

class FactServiceMock: FactServiceContract {
    
    func search(with query: String) -> Single<[Fact]> {
        
        switch self.mockType {
        case .success:
            return Single.just(
                
                SearchResponse(result: [
                    Fact(categories: ["dev", "test"], iconUrl: "1", id: "3", value: "4"),
                    Fact(categories: ["santos", "bh"], iconUrl: "www.stone.com.br", id: "10", value: "20"),
                    Fact(categories: ["Italia", "Spain", "UK"], iconUrl: "", id: "3", value: "110")
                    ], total: 3)).map{ $0.result }
        case .successWith(let jsonFile):
            guard let response: SearchResponse = jsonFile.toObject() else {
                return Single.error(ServiceError.default)
            }
            return Single.just(response.result)
        case .empty:
            return Single.just(SearchResponse(result: [], total: 0)).map {$0.result}
        case .error:
            return Single.error(ServiceError.invalidResponse)
        }
        
    }
    
    func categories() -> Single<[String]> {
        
        switch self.mockType {
        case .success:
            return Single.just(["animal", "test", "service"])
        case .successWith(jsonFile: let jsonFile):
            guard let response: [String] = jsonFile.toObject() else {
                return Single.error(ServiceError.default)
            }
            return Single.just(response)
        case .empty:
            return Single.just([])
        case .error:
            return Single.error(ServiceError.default)
        }
    }

    private let mockType: MockType
    
    init(with mockType: MockType) {
        self.mockType = mockType
    }
    
    
}
