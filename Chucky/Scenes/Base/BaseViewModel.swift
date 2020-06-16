//
//  BaseViewModel.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BaseViewModelContract {
    var loading: Driver<Bool> { get }
    var onError: Driver<ServiceError> { get }
    func handleError(error: Error)
}

class BaseViewModel: BaseViewModelContract {
    
    internal let disposeBag = DisposeBag()
    private let handleError = HandleError()

    private let _onError = PublishSubject<ServiceError>()
    var onError: Driver<ServiceError> {
        return _onError.asDriver(onErrorJustReturn: .none)
    }
    
    internal let isLoading = PublishSubject<Bool>()
    var loading: Driver<Bool> {
        return isLoading.asDriver(onErrorJustReturn: false)
    }

    func handleError(error: Error) {
        self._onError.onNext(self.handleError.handle(with: error))
    }
    
    deinit {
        print("🅼 the \(self) was deinitalized")
    }
}
