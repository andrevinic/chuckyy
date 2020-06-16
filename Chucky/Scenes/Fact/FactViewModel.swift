//
//  FactViewModel.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FactViewModel: BaseViewModel {

    private let factService: FactServiceContract
    internal var facts: [Fact] = []
    private var query: String = ""
    
    init(factService: FactServiceContract) {
        self.factService = factService
    }
    
    func fetch(with query: String) {
        self.query = query
        guard !self.query.isEmpty else {
            return
        }
        
        self.factService
            .search(with: self.query)
            .defaultLoading(super.isLoading)
            .subscribe(onSuccess: { (response) in
                print(response)
            }, onError: self.handleError(error:))
        .disposed(by: disposeBag)
    }
}
