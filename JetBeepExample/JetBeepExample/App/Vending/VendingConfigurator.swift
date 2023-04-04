//
//  VendingConfigurator.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 31.03.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit
import SwiftUI


protocol VendingConfiguratorProtocol: AnyObject {
    func makeViewController() -> (UIViewController, VendingViewModel)
}

class VendingConfigurator {
}

extension VendingConfigurator: VendingConfiguratorProtocol {
    func makeViewController() -> (UIViewController, VendingViewModel) {
		
		let viewModel = VendingViewModel()
		let view = VendingView(viewModel)
        let viewController = UIHostingController(rootView: view)
		let router = VendingRouter(viewController: viewController)
		viewModel.router = router

        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = "Vending"
        navigationController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController.tabBarItem.title = "Vending"
        navigationController.tabBarItem.image = UIImage(systemName: "bolt.horizontal")
        return (navigationController, viewModel)
    }
}
