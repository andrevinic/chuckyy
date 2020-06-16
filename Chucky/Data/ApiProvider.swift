//
//  ApiProvider.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import Moya

class ApiProvider<Target: TargetType>: MoyaProvider<Target> {
    
    private let enabledMock = ProcessInfo.processInfo.arguments.contains("UITest")
    private let logEnabled: Bool = false
    
    init() {
        let configuration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let plugin = NetworkLoggerPlugin(configuration: configuration)
        let networkLogger = self.logEnabled ? [plugin] : []
        if self.enabledMock {
            super.init(stubClosure: MoyaProvider.delayedStub(1),
                       plugins: networkLogger)
        } else {
            super.init(plugins: networkLogger)
        }
    }
}
