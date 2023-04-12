//
//  LockerConfigurator.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit
import SwiftUI

protocol LockerConfiguratorProtocol: AnyObject {
    func makeViewController() -> (UIViewController, LockerViewModel)
}

class LockerConfigurator {
}

extension LockerConfigurator: LockerConfiguratorProtocol {
    func makeViewController() -> (UIViewController, LockerViewModel) {

		let viewModel = LockerViewModel()
		let view = LockerView(viewModel)
        let viewController = UIHostingController(rootView: view)
		let router = LockerRouter(viewController: viewController)
		viewModel.router = router

        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = "Lockers"
        navigationController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController.tabBarItem.title = "Lockers"
        navigationController.tabBarItem.image = UIImage(systemName: "lock.fill")
        return (navigationController, viewModel)
    }
}
