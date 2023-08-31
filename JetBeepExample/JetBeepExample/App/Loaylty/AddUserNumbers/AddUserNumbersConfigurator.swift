//
//  AddUserNumbersConfigurator.swift
//  Pods
//
//  Created by Max Tymchii on 28.03.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SwiftUI

protocol AddUserNumbersConfiguratorProtocol: AnyObject {
    func makeViewController() -> (UIViewController, AddUserNumbersViewModel)
}

class AddUserNumbersConfigurator {
}

extension AddUserNumbersConfigurator: AddUserNumbersConfiguratorProtocol {
    func makeViewController() -> (UIViewController, AddUserNumbersViewModel) {

		let viewModel = AddUserNumbersViewModel()
		let view = AddUserNumbersView(viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.navigationItem.title = "Coupons"
		let router = AddUserNumbersRouter(viewController: viewController)
		viewModel.router = router

        return (viewController, viewModel)
    }
}
