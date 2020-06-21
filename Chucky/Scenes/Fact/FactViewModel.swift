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
    internal var categoriesList: [String] = []
    private let _onCategories = PublishSubject<[String]>()
    var onCategories: Driver<[String]> {
        return self._onCategories.asDriver(onErrorJustReturn: [])
    }
    
    private let _onFetched = PublishSubject<[Fact]>()
    var onFetched: Driver<[Fact]> {
        return self._onFetched.asDriver(onErrorJustReturn: [])
    }
    
    private var query: String = ""
    private var localQuery: UserDefaultFacade
    var recentSearch: Driver<[String]>
    
    init(factService: FactServiceContract, localQuery: UserDefaultFacade) {
        self.factService = factService
        self.localQuery = localQuery
        self.recentSearch = localQuery.lastSearch.asDriver(onErrorJustReturn: [])
    }
    
    func categories() {
        self.factService
            .categories()
            .defaultLoading(super.isLoading)
            .subscribe(onSuccess: { (response) in
                self.categoriesList.append(contentsOf: response)
                self._onCategories.onNext(response)
            }, onError: self.handleError(error:))
            .disposed(by: disposeBag)
    }
    
    func fetch(with query: String) {
        self.query = query
        guard !self.query.isEmpty else {
            return
        }
        self.localQuery.addSearch(query)

        self.factService
            .search(with: self.query)
            .defaultLoading(super.isLoading)
            .subscribe(onSuccess: { (response) in
                self.facts.append(contentsOf: response)
                self._onFetched.onNext(response)
            }, onError: self.handleError(error:))
            .disposed(by: disposeBag)
    }
    
    func clearData() {
        self.query = ""
        self.facts.removeAll()
        self._onFetched.onNext([])
    }
}
