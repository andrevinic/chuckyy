//
//  AppCoordinator.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
    private weak var appDelegate: AppDelegate?
    private let window: UIWindow

    init(appDelegate: AppDelegate, window: UIWindow) {
        self.appDelegate = appDelegate
        self.window = window
    }
    
    func start() {
        self.navigateToHome()
    }
    
    private func navigateToHome() {
        let factService = FactService()
        let factViewModel = FactViewModel(factService: factService)
        let factViewController = FactViewController(viewModel: factViewModel)
        let navigationController = UINavigationController(rootViewController: factViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        
    }
}
