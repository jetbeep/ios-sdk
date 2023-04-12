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

        let userNumbersButton = addUserNumberBarButton {
            router.openNextScreen()
        }

        viewController.navigationItem.rightBarButtonItem = userNumbersButton
        return (navigationController, viewModel)

    }

    private func addUserNumberBarButton(with completion: @escaping () -> Void?) -> UIBarButtonItem {

        let button = UIButton()
        let image = UIImage(systemName: "creditcard.fill")
        button.setImage(image, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let action = UIAction { _ in
            completion()
        }

        if #available(iOS 14.0, *) {
            button.addAction(action, for: .touchUpInside)
        } else {
            print("Please move to iOS 14.0 or higher")
        }

        return UIBarButtonItem(customView: button)
    }

}
