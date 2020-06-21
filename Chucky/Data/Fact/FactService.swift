//
//  FactService.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FactServiceContract {
    func search(with query: String) -> Single<[Fact]>
    func categories() -> Single<[String]>
}

class FactService: FactServiceContract {
    
    private let provider = ApiProvider<FactAPI>()
    
    func search(with query: String) -> Single<[Fact]> {
        return self.provider
            .rx
            .request(.search(query: query))
            .mapDefault(SearchResponse.self)
            .map { $0.result }
            
    }
    
    func categories() -> Single<[String]> {
        return self.provider
            .rx
            .request(.categories)
            .map([String].self)
    }
    
}
