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
    func search(with query: String) -> Single<SearchResponse>
}

class FactService: FactServiceContract {
    
    private let provider = ApiProvider<FactAPI>()

    func search(with query: String) -> Single<SearchResponse> {
        return self.provider
        .rx
        .request(.search(query: query))
        .mapDefault(SearchResponse.self)
    }
    
}
