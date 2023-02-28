//
//  LocationsConfigurator.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit
import SwiftUI


protocol LocationsConfiguratorProtocol: AnyObject {
    func makeViewController() -> (UIViewController, LocationsViewModel)
}

class LocationsConfigurator {
}

extension LocationsConfigurator: LocationsConfiguratorProtocol {
    func makeViewController() -> (UIViewController, LocationsViewModel) {
		
		let viewModel = LocationsViewModel()
		let view = LocationsView(viewModel)
        let viewController = UIHostingController(rootView: view)
		let router = LocationsRouter(viewController: viewController)
		viewModel.router = router

        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = "Locations"
        navigationController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController.tabBarItem.title = "Locations"
        navigationController.tabBarItem.image = UIImage(systemName: "map.fill")
        return (navigationController, viewModel)
    }
}
