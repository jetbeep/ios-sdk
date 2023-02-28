//
//  LogConfigurator.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit
import SwiftUI


protocol LogConfiguratorProtocol: AnyObject {
    func makeViewController() -> (UIViewController, LogViewModel)
}

class LogConfigurator {
}

extension LogConfigurator: LogConfiguratorProtocol {
    func makeViewController() -> (UIViewController, LogViewModel) {
		
		let viewModel = LogViewModel()
		let view = LogView(viewModel)
        let viewController = UIHostingController(rootView: view)        
		let router = LogRouter(viewController: viewController)
		viewModel.router = router
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = "Logs"
        navigationController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController.tabBarItem.title = "Logs"
        navigationController.tabBarItem.image = UIImage(systemName: "paperplane.fill")
        return (navigationController, viewModel)
    }
}
