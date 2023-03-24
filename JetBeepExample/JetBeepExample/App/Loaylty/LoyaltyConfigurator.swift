//
//  LoyaltyConfigurator.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 15.03.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit
import SwiftUI


protocol LoyaltyConfiguratorProtocol: AnyObject {
    func makeViewController() -> (UIViewController, LoyaltyViewModel)
}

class LoyaltyConfigurator {
}

extension LoyaltyConfigurator: LoyaltyConfiguratorProtocol {
    func makeViewController() -> (UIViewController, LoyaltyViewModel) {
		
		let viewModel = LoyaltyViewModel()
		let view = LoyaltyView(viewModel)
        let viewController = UIHostingController(rootView: view)
		let router = LoyaltyRouter(viewController: viewController)
		viewModel.router = router

        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = "Loyalty"
        navigationController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController.tabBarItem.title = "Loyalty"
        navigationController.tabBarItem.image = UIImage(systemName: "heart.fill")
        return (navigationController, viewModel)

    }
}
